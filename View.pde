class ViewController {
  
   int index;
   ArrayList<View> view_stack = new ArrayList<View>();
   View current_view = new View();
   
   boolean allFrozen = false;
   
   ViewController() {
     index = 0;
   }
   
   void addView(View v) {
     v.viewIndex = index;
     v.resetMinimizedOrigin();
     view_stack.add(v);
     current_view = v;
     index++;
   }
  
   void change_view(View v) {
     View last_view = current_view;
     current_view = v;
     last_view.lost_focus();
     current_view.got_focus();
     placeOnTop(current_view);
   }
   
   void check_viewChange(View v) {
     if (current_view==v) return;
     change_view(v);
   }
   
 // ************* control how views are displayed ********************
 
   void placeOnTop(View v) {
     for (View vv : view_stack) vv.isOnTop = false;
     v.isOnTop = true;
   }
   
   void display_views() {
     View vtop = null;

     for (View v : view_stack) if (v.isOnTop) vtop = v;
         
     if (vtop != null) {
       view_stack.add(vtop);
       view_stack.remove(vtop.viewIndex);
     }
     
     resetIndexes();
    
    // draw the minimized views first, then maximized, so maxed are on top:
    
     for (View v : view_stack) {
       if (!v.isExpanded) v.display();
     }
     for (View v : view_stack) {
       if (v.isExpanded) v.display();
     }
     
   }
   
   void minimizeAll() {
     for (View v : view_stack) {
       v.minimize();
       if (!v.isResizable && !v.isAlwaysOpen) v.isVisible = false;
     }
   }
   
   void resetIndexes() {
     for (int i=0; i<view_stack.size(); i++) {
       View v = view_stack.get(i);
       v.viewIndex = i;
     }
   }
   
   void freezeAll() {
     for (View v : view_stack) {
       if (!v.isPopup) v.isFrozen = true;
     }
     allFrozen = true;
   }
   
   void unfreezeAll() {
     for (View v : view_stack) v.isFrozen = false;
     allFrozen = false;
   }
   
   boolean isClickable(View v) {
      
      //if (freezeAll && !v.isPopup) return false;
      
      if (!v.mouseIsOver()) return false;
      
      for (int i=v.viewIndex+1; i<view_stack.size(); i++) {
      View v1 = view_stack.get(i);
      if (v1.mouseIsOver()) return false;
      }
       
      return true; 
   }
   
}

class View implements ButtonListener, InputListener, SliderListener, DraggableListener, ColorChangeListener {

  SettingsController settings;
  PGraphics pg_expanded, pg_minimized, pg_current;
  ArrayList<Button> buttons = new ArrayList<Button>();
  ArrayList<Input> inputs = new ArrayList<Input>();
  ArrayList<Slider> sliders = new ArrayList<Slider>();
  ArrayList<Draggable> draggers = new ArrayList<Draggable>();
  
  int viewIndex;
  String viewIdentifier;
  
  // mouse wheel
  float wheel_steps = 0;
  float wheel_factor = 8.0;
  
  // PGraphics parameters:
  PVector origin, offset;
  PVector expanded_origin, minimized_origin;
  int expanded_width, expanded_height;
  int minimized_width, minimized_height;
  int current_width, current_height;

  boolean isExpanded = true;
  boolean isClickable = true;
  boolean isLocked = false;
  boolean isOnTop = false;
  boolean isBaseView = false;
  boolean hasFocus = true;
  boolean showGrid = false;
  boolean isVisible = true;
  boolean isResizable = true;
  boolean isPopup = false;
  boolean isFrozen = false;
  boolean isAlwaysOpen = false;
  
  // title parameters:
  String title;
  //int title_height;
  
  // resize button
  Button resizeButton;
  
  View(float percent_oX, float percent_oY, float blocks_wide, float blocks_high, boolean threeD, String viewTitle) {
    // percent_oX, percent_oY: location of the top left corner of the view (its origin) expressed as a pecentage of the screen width and height
    
    settings = new SettingsController();
    
    current_width = expanded_width = (int)(blocks_wide*settings.standard_block_size);
    current_height = expanded_height = (int)(blocks_high*settings.standard_block_size);
    viewIdentifier = viewTitle;
    title = viewTitle;
    
    origin = setOrigin(percent_oX, percent_oY, current_width, current_height);
    offset = new PVector(origin.x, origin.y);
    expanded_origin = new PVector(origin.x,origin.y);
    
    // add resize button
    resizeButton = new ResizeCircleButton(this);
    //buttons.add(resizeButton);
    
    // minimized graphics:
    int spacer = settings.standard_component_spacing;
    minimized_height = settings.standard_topbar_height;
    minimized_origin = new PVector(spacer,viewIndex*(minimized_height+spacer));
    minimized_width = settings.standard_minimized_width;
    
    pg_minimized = createGraphics(minimized_width,minimized_height,P2D);
    pg_minimized.smooth(8);
    
    setExpandedSize(expanded_width,expanded_height,threeD);
  }
  
  // empty constructor for use with BaseView subclass:
  View() {
    
  }
  
  // these functions can be overridden to perform actions when view gets or loses control
  void lost_focus() {
    
  }
  
  void got_focus() {
    
  }
  
  void setExpandedSize(int pwide, int phigh, boolean threeDim) { 
    expanded_width = pwide;
    expanded_height = phigh;
    current_width = expanded_width;
    current_height = expanded_height;
    
    if (threeDim) {
      pg_expanded = createGraphics(pwide,phigh,P3D); 
    }
    else {
      pg_expanded = createGraphics(pwide,phigh,P2D);
    }
    
    pg_expanded.smooth(8);
    pg_current = pg_expanded;
    maximize();
  }
  
  PVector setOrigin(float percent_oX, float percent_oY, int pixels_wide, int pixels_high) {
    int o_x = (int)(percent_oX*width);
    int o_y = (int)(percent_oY*height);
    
    // 0.5 assumes the user wants to center the view in the screen:
    if (percent_oX == 0.5) {
      o_x -= (pixels_wide/2);
    }
    
    int delta_x = width - (o_x + pixels_wide);
    int delta_y = height - (o_y + pixels_high);
    
    if (delta_x < 0) o_x += (delta_x - settings.standard_component_spacing);
    if (delta_y < 0) o_y += (delta_y - settings.standard_component_spacing);
    
    if (o_x < settings.standard_component_spacing) o_x = settings.standard_component_spacing;
    if (o_y < settings.standard_component_spacing) o_y = settings.standard_component_spacing;
    
    return new PVector(o_x,o_y);
  }
  
  void resetMinimizedOrigin() {
    int spacer = settings.standard_component_spacing;
    int offset_due_to_control = (int)blocks_to_pixels(2.0);
    minimized_origin.y = spacer + offset_due_to_control + viewIndex*(settings.standard_topbar_height+spacer);
  }
  
  void resetOrigin() {
    int o_x = (int)origin.x;
    int o_y = (int)origin.y;
    
    int delta_x = width - (o_x + expanded_width);
    int delta_y = height - (o_y + expanded_height);
    
    if (delta_x < 0) o_x += (delta_x - settings.standard_component_spacing);
    if (delta_y < 0) o_y += (delta_y - settings.standard_component_spacing);
    
    if (o_x < settings.standard_component_spacing) o_x = settings.standard_component_spacing;
    if (o_y < settings.standard_component_spacing) o_y = settings.standard_component_spacing;
    
    origin.set(o_x,o_y);
    expanded_origin.set(o_x,o_y);
  }
  
  void center() {
    float o_x, o_y;
    
    o_x = (width - expanded_width)/2.0;
    o_y = (height - expanded_height)/2.0;
   
    origin.set(o_x,o_y);
    expanded_origin.set(o_x,o_y);
  }
  
  float blocks_to_pixels(float nblocks) {
     return nblocks*settings.standard_block_size; 
  }
  
    // **********implement listener interface functions: *********************
  
  @Override
  void onClick(Button b) {

  }
  
  @Override
  void onUpdate(Input i) {
    
  }
  
  @Override
  void onSlide(Slider s) {
    
  }
  
  @Override
  void onDrag(Draggable d) {
    
  }
  
  @Override
  void onColorChange(Button b) {
    
  }
  
  // ******************* adding components: ****************************
  
  void addButton(Button b) {
     buttons.add(b); 
     b.buttonIndex = buttons.size()-1;
     b.addListener(this);
  }
  
  void addInput(Input i) {
     inputs.add(i); 
     i.inputIndex = inputs.size()-1;
     i.addListener(this);
  }
  
  void addSlider(Slider s) {
     sliders.add(s); 
     s.sliderIndex = sliders.size()-1;
     s.addListener(this);
  }
  
  void addDragger(Draggable d) {
     draggers.add(d); 
     d.draggerIndex = draggers.size()-1;
     d.addListener(this);
  } 
 
  
  // ************** mouse functions: ********************
  
  void mseMoved() { 
    
    if (isFrozen) return;
    
    hasFocus = false;
        
    if (view_controller.isClickable(this)) {
      hasFocus = true;
    }
        
    for (Button b : buttons) {
        b.mseMoved();
    }  
    for (Input i : inputs) {
        i.mseMoved();
    }  
  }
  
  void msePressed() {
    
    if (isFrozen) return;
    
    // check to see if we're pressing a slider or draggable; if so, don't move view:
    for (Slider s : sliders) {
      if (s.msePressed()) return;
    }  
    
    for (Draggable d : draggers) {
      if (d.msePressed()) return;
    }  
    
    if (hasFocus) {
      isLocked = true;
      offset.x = mouseX - origin.x;
      offset.y = mouseY - origin.y;
      
      view_controller.check_viewChange(this);
    }
    else {
      isLocked = false;
    }
    

  }
  
  void mseClicked() {
    if (isFrozen) return;
    
    if (hasFocus) {
      for (Button b : buttons) {
        b.mseClicked();
      }  
      for (Input i : inputs) {
        i.mseClicked();
      } 
    }
    
    // else run the got_focus routine here??
  }
  
  void mseDragged() {
    if (isFrozen) return;
    
    if (isLocked && !isBaseView) {
      origin.x = mouseX - offset.x;
      origin.y = mouseY - offset.y;
      return;
    }
    
    for (Slider s : sliders) {
      s.mseDragged();
    } 
    
    for (Draggable d : draggers) {
      d.mseDragged();
    } 
  }
  
  void mseReleased() {
    if (isFrozen) return;
    
    isLocked = false;
    for (Slider s : sliders) {
      s.mseReleased();
    } 
    
    for (Draggable d : draggers) {
      d.mseReleased();
    } 
  }
  
  void mseWheel(float e) {
  }
  
  boolean mouseIsOver() {  
    
    if (!isVisible) return false;
    
    if (mouseX > origin.x && mouseX < origin.x+current_width && mouseY > origin.y && mouseY < origin.y+current_height) {
      return true;
    }
    return false;
  }
  
  
  // **************** drawing and display functions: ************************
  
  void display() {

    if (!isVisible) return;
    
    drawBackground();
    drawViewTitle();
    if (isResizable) drawResizeButton();
   
    if (isExpanded) {
      if (showGrid) drawGrid();
      drawContent();
      drawButtons();
      drawInputs();
      drawSliders();
    }
    
    image(pg_current,origin.x,origin.y);
    
    if (isExpanded) postDraw();
  }
  
  void hide() {
    isVisible = false;
    isResizable = false;
  }
  
  void drawGrid() {
    
    int block_size = settings.standard_block_size;
    int ymin = settings.standard_topbar_height;
    int ymax = pg_current.height;
    int xmin = 0;
    int xmax = pg_current.width;
    
    pg_current.beginDraw();
    pg_current.stroke(255);
    pg_current.strokeWeight(1);
   
    // horizontal lines:
    for (int j = block_size; j < pg_current.height; j+=block_size) {
      pg_current.line(xmin,j,xmax,j);
    }
    
    //vertical lines:
    for (int i = block_size; i < pg_current.width; i+=block_size) {
      pg_current.line(i,ymin,i,ymax);
    }   
    
    pg_current.endDraw();
 
  }
  
  void draw_horizontal_line(float y) {
    float xmin = 0;
    float xmax = pg_current.width;
    
    pg_current.line(xmin,y,xmax,y);
  }
  
  void draw_horizontal_line(float y, float x1, float x2) {
    float xmin = max(x1,0);
    float xmax = min(x2,pg_current.width);
    pg_current.line(xmin,y,xmax,y);
  }
  
  void draw_vertical_line(float x) {
    int ymin = settings.standard_topbar_height;
    int ymax = pg_current.height;

    pg_current.line(x,ymin,x,ymax);
  }
  
  void draw_vertical_line(float x, float y1, float y2) {
    float ymin = max(y1,settings.standard_topbar_height);
    float ymax = min(y2,pg_current.height);
    pg_current.line(x,ymin,x,ymax);
  }
  
  void drawContent() {
    // this functions can be overridden by subclasses.
  }
  
  void postDraw() {
    // this functions can be overridden by subclasses to overlay images on view
  }
  
  void drawBackground() { 
    pg_current.beginDraw();
    
    // background:
    pg_current.background(settings.background_color);
    pg_current.rectMode(CORNER);
    
    // topbar:
    pg_current.stroke(0);
    pg_current.strokeWeight(1);
    pg_current.fill(settings.topbar_color);
    pg_current.rect(0,0,pg_current.width,settings.standard_topbar_height);    
    
    // outline:
    pg_current.strokeWeight(2);
    pg_current.noFill();
    pg_current.rect(0,0,pg_current.width,pg_current.height);

    pg_current.endDraw(); 
  }
  
  void drawViewTitle() {
    pg_current.beginDraw();
    pg_current.fill(0);
    pg_current.textSize(settings.standard_title_height);
    pg_current.textAlign(LEFT,CENTER);
    pg_current.text(title,settings.standard_text_indent,settings.standard_topbar_height/2);
    pg_current.endDraw(); 
  }
  
  void drawResizeButton() {
    resizeButton.display();
  }
  
  void drawButtons() {
    for (Button b : buttons) {
      b.display();
    } 
  }
  
  void drawInputs() {
    for (Input i : inputs) {
      i.display();
    } 
  }
  
  void drawSliders() {
    for (Slider s : sliders) {
      s.display();
    } 
  }
  
  void minimize() {
    if (!isExpanded) return;
    if (isAlwaysOpen) {
      isVisible = true;
      return;
    }
    current_width = minimized_width;
    current_height = minimized_height;
    expanded_origin = origin.copy();
    origin = minimized_origin.copy();
    pg_current = pg_minimized;
    isExpanded = false;
  }
  
  void maximize() {
    if (isExpanded) return;
    current_width = expanded_width;
    current_height = expanded_height;
    origin = expanded_origin.copy();
    pg_current = pg_expanded;
    isExpanded = true;
    isVisible = true;
    view_controller.placeOnTop(this);
  }
  
 
  void toggle_size() {
    // if it's big, make it small, and vice-versa
    
    if (isExpanded) {
      minimize();
    }
    else {
      maximize();
    } 
  }
   
}
