class SettingsController {
  
  // appearance settings -- pixels
 
    // view:
  int standard_block_size = 160;
  int standard_topbar_height = int(0.25 * standard_block_size);
  int standard_component_spacing = 4;
  int standard_minimized_width = standard_block_size;
  
  // button size:
  int standard_button_height = int(0.175 * standard_block_size);;
  int standard_button_width = int(0.875 * standard_block_size);
  int standard_button_radius = 5;
  
  // input:
  int standard_input_height = int(0.375 * standard_block_size);;
  int standard_input_width = standard_button_width;
  
  // slider:
  int standard_slider_height = standard_button_height;
  int standard_slider_width = standard_button_width;
  
  // text:
  int standard_text_height = int(0.1125 * standard_block_size);
  int standard_title_height = int(0.125 * standard_block_size);
  int standard_console_text_height = 13;
  int standard_text_indent = 5;
  
  // colors:
  //color background_color = random_color_light();
  color background_color = color(200,190,150);
  color topbar_color = color(150,165,200);

   SettingsController() {

   }
}

// Button, Input, and Slider Classes

// ************************************************
// Button Classes
// ************************************************

class Button {
  
  //private ArrayList<ButtonListener> listeners = new ArrayList<ButtonListener>();
  ArrayList<ButtonListener> listeners = new ArrayList<ButtonListener>();
  SettingsController settings;
  View parent_view;
    
  int buttonIndex=0;
  String buttonIdentifier;
  String buttonLabel;
  Boolean buttonValue = false;

  PVector origin;
  int buttonWidth, buttonHeight, buttonRadius;
  boolean isClickable = true;
  boolean isVisible = true;
  private boolean isMouseOver = false;
  private boolean hasBeenClicked = false;
  
  color inactive_color = color(200);
  color highlight_color = color(240,240,0);
  color active_color = color(100,240,30);
  color background_color = active_color;
  color resize_box_color = color(240,30,100);
  color text_color = color(0);
  
  Button(View parent) {
    origin = new PVector(0,0);
    parent_view = parent;
    parent_view.addButton(this);
    
    settings = parent_view.settings;
    
    buttonWidth = settings.standard_button_width;
    buttonHeight = settings.standard_button_height;
    buttonRadius = settings.standard_button_radius;
  }
  
  Button(View parent, float xpos_blocks, float ypos_blocks, String label) {
    settings = parent.settings;
    origin = new PVector((int) (xpos_blocks*settings.standard_block_size),(int) (ypos_blocks*settings.standard_block_size));
    
    buttonLabel = label;
    buttonIdentifier = label;
    parent_view = parent;
    parent_view.addButton(this);
    settings = parent_view.settings;
    
    buttonWidth = settings.standard_button_width;
    buttonHeight = settings.standard_button_height;
    buttonRadius = settings.standard_button_radius;
  }
  
  // *************** listener functions: ****************
  
  public void addListener(ButtonListener b) {
     listeners.add(b); 
  }
  
  public void onClick() {
    if (!parent_view.isClickable) return;
    if (!isClickable) return;
    hasBeenClicked = true;
    for (ButtonListener b : listeners) b.onClick(this);
  }
  
  // **************** operability functions: ***************
  void enable() {
    isClickable = true;  
    background_color = active_color;
  }
  
  void disable() {
    isClickable = false;  
    background_color = inactive_color;
  }
  
  // **************** mouse functions: **********************
  
  boolean mouseIsOver() {
    float xo = parent_view.origin.x + origin.x - buttonWidth/2;
    float yo = parent_view.origin.y + origin.y - buttonHeight/2;
    
    if (mouseX > xo && mouseX < xo+buttonWidth && mouseY > yo && mouseY < yo+buttonHeight) {
      return true;
    }
    else {
      return false;
    }
  }
  
  void mseMoved() {
    background_color = inactive_color;
    
    if (mouseIsOver()) {
      isMouseOver = true;
    }
    else {
     isMouseOver = false;   
    }
  }
  
  void mseClicked() {
    if (isMouseOver) onClick();
  }
  
  void set_background_color() {
    background_color = inactive_color;
    if (isClickable) {
      background_color = active_color;
      if (isMouseOver) background_color = highlight_color;
    }
  }
  
  void display() {
    
    if (!isVisible) return;
    
    set_background_color();
    
    PGraphics pg = parent_view.pg_current;
    
    // begin:
    pg.beginDraw();
    
    // position and draw rectangle:
    pg.strokeWeight(1);
    pg.stroke(0);
    pg.rectMode(CENTER);
    pg.fill(background_color);
    pg.rect(origin.x,origin.y,buttonWidth,buttonHeight,buttonRadius);
    
    // add text:
    if (buttonLabel == "") {}
    else {
      pg.fill(text_color);
      pg.textSize(settings.standard_text_height);
      pg.textAlign(CENTER,CENTER); 
      pg.text(buttonLabel,origin.x,origin.y);
    }
    
    // finish:
    pg.endDraw();
   
  }
   
}

// ************************************************************************************

class ButtonOnOff extends Button {
  
   ButtonOnOff(View parent, float xpos_blocks, float ypos_blocks, String label) {
     super(parent, xpos_blocks, ypos_blocks, label);
   }
   
   @Override 
   void onClick() {
    if (!parent_view.isClickable) return;
    if (!isClickable) return;
    buttonValue = !buttonValue;
    for (ButtonListener b : listeners) b.onClick(this);
   }
   
   @Override
   void display() {
     
    set_background_color();
    
    float spacer = 0.15*buttonHeight;
    float circle_dia = 0.5*buttonHeight;
    PGraphics pg = parent_view.pg_current;
    
    pg.beginDraw();
    
     // position and draw rectangle:
    pg.strokeWeight(1);
    pg.stroke(0);
    pg.rectMode(CENTER);
    pg.fill(background_color);
    pg.rect(origin.x,origin.y,buttonWidth,buttonHeight,buttonRadius);
    
    // add text:
    if (buttonLabel == "") {}
    else {
      pg.fill(text_color);
      pg.textSize(settings.standard_text_height);
      pg.textAlign(LEFT,CENTER); 
      pg.text(buttonLabel,origin.x - buttonWidth*0.5 + spacer,origin.y);
    }
    
    // position and draw on-off circle:
    pg.strokeWeight(1);
    pg.stroke(0);
    //pg.noStroke();
    
    if (buttonValue) pg.fill(255,0,0);
    else pg.fill(255);
    
    pg.ellipse(origin.x + buttonWidth/2 - buttonHeight/2, origin.y,circle_dia,circle_dia);
    
    pg.endDraw();
   }
}

class ButtonSwitch extends Button {
  
   float switchBoxHeight,switchBoxWidth;
   color switchBoxColor   = color(255,0,0);
    
   ButtonSwitch(View parent, float xpos_blocks, float ypos_blocks, String label) {
     super(parent, xpos_blocks, ypos_blocks, label);
        
       switchBoxHeight = 0.7*buttonHeight;
       switchBoxWidth = switchBoxHeight;
       
   }
   
   @Override 
   void onClick() {
    if (!parent_view.isClickable) return;
    if (!isClickable) return;
    buttonValue = !buttonValue;
    for (ButtonListener b : listeners) b.onClick(this);
   }
   
   @Override
   void display() {
     
    set_background_color();
    
    float spacer = 0.15*buttonHeight;
    PGraphics pg = parent_view.pg_current;
    
    pg.beginDraw();
    
     // position and draw rectangle:
    pg.strokeWeight(1);
    pg.stroke(0);
    pg.rectMode(CENTER);
    pg.fill(background_color);
    pg.rect(origin.x,origin.y,buttonWidth,buttonHeight,buttonRadius);
    
    // add text:
    if (buttonLabel == "") {}
    else {
      pg.fill(text_color);
      pg.textSize(settings.standard_text_height);
      pg.textAlign(LEFT,CENTER); 
      pg.text(buttonLabel,origin.x - buttonWidth*0.5 + spacer,origin.y);
    }
    
    // position and draw on-off switch:

    float boxRight = origin.x + buttonWidth/2 - buttonHeight/2 - spacer;
    float boxLeft = boxRight - switchBoxWidth;
    float boxY = origin.y;
    
    pg.fill(switchBoxColor);
    pg.stroke(0);
    pg.strokeWeight(2);
    pg.line(boxLeft-switchBoxWidth/2,boxY,boxRight+switchBoxWidth/2,boxY);
    pg.rectMode(CENTER);
    pg.strokeWeight(1);
    if (buttonValue) {
      pg.rect(boxRight,boxY,switchBoxWidth,switchBoxWidth);   
    }
    else {
      pg.rect(boxLeft,boxY,switchBoxWidth,switchBoxWidth);
    }
    
    pg.endDraw();
   }   
}

// ***************************************************************************************
// ResizeButtons are used at the top of all the views to open / close the view (minimize)
// ***************************************************************************************

class ResizeButton extends Button {
  
  ResizeButton(View parent) {
    super(parent);
    buttonLabel = "";
    buttonIdentifier = "resize";
    
    buttonWidth = settings.standard_button_width / 2;
  }
  
  @Override
  void onClick() {
    if (!parent_view.isClickable) return;
    parent_view.toggle_size();
  }
  
  @Override
  void display() {
    
    PGraphics pg = parent_view.pg_current;
    int spacer = settings.standard_component_spacing;
    
    // first set new origin to put in top right corner of parent view:
    int viewWidth = pg.width;
    origin.x = viewWidth - buttonWidth/2 - spacer;
    origin.y = settings.standard_topbar_height/2;
    
    // call super to draw button outline:
    super.display();

    // draw the open/close view symbols:
    pg.beginDraw();
    int boxWidth = int(buttonWidth * 0.35);
    int boxHeight = int(buttonHeight * 0.75);
    int boxRadius = 0;
    pg.fill(resize_box_color);
    pg.rectMode(CENTER);
    pg.noStroke();
    pg.rect(origin.x - 0.23*buttonWidth,origin.y,boxWidth,(int)(boxHeight*0.25),boxRadius);
    pg.rect(origin.x + 0.23*buttonWidth,origin.y,boxWidth,boxHeight,boxRadius);
    pg.endDraw();
    
  }  
}

// ***************************************************************************************
// ResizeButtons are used at the top of all the views to open / close the view (minimize)
// ***************************************************************************************

class ResizeCircleButton extends Button {
  
  ResizeCircleButton(View parent) {
    super(parent);
    buttonLabel = "";
    buttonIdentifier = "resize";
    buttonWidth = (int)(0.6*buttonHeight);
  }
  
  @Override
  void onClick() {
    if (!parent_view.isClickable) return;
    if (!parent_view.isResizable) return;
    parent_view.toggle_size();
  }
  
  @Override
  void display() {
    
    if (!parent_view.isResizable) return;
    
    PGraphics pg = parent_view.pg_current;
    
    // first set new origin to put in top right corner of parent view:
    int viewWidth = pg.width;
    origin.x = viewWidth - buttonWidth;
    origin.y = settings.standard_topbar_height/2;

    // draw the open/close red circle:
    pg.beginDraw();   
    pg.stroke(0);
    pg.strokeWeight(1);
    
    //pg.noStroke();
    if (pg == parent_view.pg_expanded) pg.fill(255,0,0);
    //else pg.fill(0,200,0);
    else pg.fill(active_color);
    pg.ellipseMode(CENTER);
    pg.ellipse(origin.x,origin.y,buttonWidth,buttonWidth);
    
    pg.endDraw();
    
  }
  
}

// ******************************************************************

class TestButton extends Button  {
  
  TestButton(View parent, float xpos_blocks, float ypos_blocks, String label) {
    super(parent, xpos_blocks, ypos_blocks, label);
    
    parent_view.addButton(this);
  }


}

class ToggleGroupButton extends ButtonOnOff {
  
  int toggle_index = -1;
  ToggleGroup toggle_group = null;

  ToggleGroupButton(View parent, float xpos_blocks, float ypos_blocks, String label, ToggleGroup tg) {
    super(parent, xpos_blocks, ypos_blocks, label);
    toggle_group = tg;
    toggle_group.addButton(this);
  }

  @Override
  void onClick() {
    if (!parent_view.isClickable) return;
    if (!isClickable) return;
    buttonValue = !buttonValue;
    if (toggle_group != null) toggle_group.onClick(this);
    
    for (ButtonListener b : listeners) b.onClick(this);
  } 
 
}

class ToggleGroup {
  
  View parent_view;
  ArrayList<ToggleGroupButton> buttons = new ArrayList<ToggleGroupButton>();
  
  ToggleGroup(View parent) {
    parent_view = parent;
  }
  
  void addButton(ToggleGroupButton b) {
    buttons.add(b);
    b.toggle_index = buttons.size()-1;
  }
  
  int get_toggleIndex() {
    int index = -1;
    for (ToggleGroupButton b: buttons) {
       if (b.buttonValue) index = b.toggle_index;
    }
    return index;
  }
  
  void set_toggleIndex(int index) {
    for (ToggleGroupButton b: buttons) b.buttonValue = false;
    buttons.get(index).buttonValue = true;
  }
  
  void onClick(ToggleGroupButton b_clicked) {
    if (!parent_view.isClickable) return;
    for (ToggleGroupButton b: buttons) {
      if (b.buttonIndex==b_clicked.buttonIndex) b.buttonValue = true;
      else b.buttonValue = false;
    }
  }
  
}


// *****************************************************
// Input Class
// *****************************************************


class Input {
  
  private ArrayList<InputListener> listeners = new ArrayList<InputListener>();
    
  View parent_view;
  SettingsController settings;
    
  int inputIndex;
  float inputValue=-99999;
  String inputIdentifier;
  String inputLabel;
  String input_string = "";

  PVector origin;
  int inputWidth, inputHeight;
 
  boolean isClickable = true;
  boolean isMouseOver = false;
  boolean isFocus = false;
  
  color inactive_color = color(200);
  color highlight_color = color(240,240,0);
  color active_color = color(100,240,30);
  color edit_color = color(200,180,240);
  color background_color = active_color;
  color foreground_color = color(240,30,100);
  
  Input(View parent) {
    origin = new PVector(0,0);
    parent_view = parent;  
    parent_view.addInput(this);
    
    inputWidth = settings.standard_input_width;
    inputHeight = settings.standard_input_height;
  }
  
  Input(View parent, float pos_x, float pos_y, String label) {
    settings = parent.settings;

    inputLabel = label;
    inputIdentifier = label;
    parent_view = parent; 
    parent_view.addInput(this);
    
    inputWidth = settings.standard_input_width;
    inputHeight = settings.standard_input_height;
    
    int xo = (int)(pos_x*settings.standard_block_size) - inputWidth/2;
    int yo = (int)(pos_y*settings.standard_block_size) - inputHeight/2;
    
    origin = new PVector(xo,yo);

  }
  
  void enable() {
    isClickable = true;  
    background_color = active_color;
  }
  
  void disable() {
    isClickable = false;  
    background_color = inactive_color;
  }
  
    // *************** listener functions: ****************
  
  public void addListener(InputListener i) {
     listeners.add(i); 
  }
  
  public void onUpdate() {
    if (!parent_view.isClickable) return;
    if (!isClickable) return;
    for (InputListener i : listeners) i.onUpdate(this);
  }
  
  //***********************************************************
  
  void set_input_string(String s) {
     input_string = s; 
  }
  
    // **************** mouse functions: **********************
  
  boolean mouseIsOver() {
    float xo = parent_view.origin.x + origin.x;
    float yo = parent_view.origin.y + origin.y;
    
    if (mouseX > xo && mouseX < xo+inputWidth && mouseY > yo && mouseY < yo+inputHeight) {
      isMouseOver = true;
    }
    else {
      isMouseOver = false;
    }
    
    return isMouseOver;
  }
  
  void mseMoved() {
    
    if (!isClickable) {
      background_color = inactive_color;
      return;
    }
    background_color = active_color;
    
    if (mouseIsOver()) {
      if (isFocus) background_color = edit_color;
    }  
    else {
      if (isFocus) background_color = edit_color; 
    }
    
  }
  
  void mseClicked() {
    if (!isClickable) return;
    
    if (isMouseOver) {
      background_color = edit_color;
      isFocus = true;
    }
    else {
      if (isFocus) {
        lostFocus();
        return;
      }
      isFocus = false;
    }
    
  }
  
  void lostFocus() {
    isFocus = false;
    if (input_string.length()>0) {
      inputValue = Float.valueOf(input_string);
      onUpdate();
    }
  }
  
  
// **************** key functions: **********************

  void key_pressed() {
    
    if (parent_view.isFrozen) return;
    
    if (!isFocus) return;
    
    char c = key;
    
    if (c==BACKSPACE || c==DELETE) {
  
      int s = input_string.length();
      if (s > 0) input_string = input_string.substring(0,s-1);
      return;
    }
    
    if (c==ENTER || c==RETURN) {
      lostFocus();
      mseMoved();
      return;
    }
    
    // right now, only allow numbers, based on ascii char code:
    if (c >= '-' && c <= '9' && c != '/') input_string += c;
    
  }
  
  void key_typed() {
    
    if (parent_view.isFrozen) return;
    
    if (!isFocus) return;
    
    char c = key;
    
    if (c==BACKSPACE || c==DELETE) {
      int s = input_string.length();
      if (s > 0) input_string = input_string.substring(0,s-1);
      return;
    }
  }
  
  String blinker() {
    return isFocus && (frameCount>>4 & 1) == 0 ? "_" : "";
  }
      
      
// **************** display functions: **********************
          
          
  void display() {
    
    PGraphics pg = parent_view.pg_current;
    float spacer = textWidth('0');
    
    // begin:
    pg.beginDraw();
    
    // position and draw rectangle:
    pg.strokeWeight(1);
    pg.stroke(0);
    pg.rectMode(CORNER);
    pg.fill(background_color);
    pg.rect(origin.x,origin.y,inputWidth,inputHeight);
    pg.fill(inactive_color);
    pg.rect(origin.x,origin.y,inputWidth,inputHeight/2);
    
    // add label text:

    pg.fill(0);
    pg.textSize(settings.standard_text_height);
    pg.textAlign(LEFT,CENTER); 
    pg.text(inputLabel,origin.x+spacer,origin.y+inputHeight/4);

    // add input text:
    if (isClickable) pg.fill(foreground_color);
    else pg.fill(background_color);
    
    pg.textAlign(LEFT,BOTTOM); 
    pg.text(input_string+blinker(),origin.x+spacer,origin.y+inputHeight);
    
    // finish:
    pg.endDraw();
   
  }
}

// ***********************************************************************
// Slider Class
// ***********************************************************************
// slider class adapted from HScrollbar example on Processing website

class Slider {
  
  private ArrayList<SliderListener> listeners = new ArrayList<SliderListener>();
  View parent_view;
  SettingsController settings;
  int sliderIndex;
  
  PVector origin;
  PVector initial_position; // save from constructor parameters pos_x and pos_y (blocks)
  int sliderWidth, sliderHeight;
  String sliderLabel;
  float sliderPixel, sliderMinPixel, sliderMaxPixel;
  float sliderValue, sliderMinValue, sliderMaxValue;
  float startPixel,deltaPixel;
  float sliderBoxWidth, sliderBoxHeight;
  int sliderPrecision = 0;
    
  boolean isClickable = true;
  boolean isMouseOver = false;
  boolean isFocus = false;
  boolean isLocked = false;
  boolean roundHalf = false; // update slider value to the nearest 0.5
  
  color inactive_color = color(200);
  color highlight_color = color(240,240,0);
  color active_color = color(100,240,30);
  color background_color = active_color;
  color foreground_color = color(240,30,100);
  
  Slider(View parent, float pos_x, float pos_y, String label) {
    
    initial_position = new PVector(pos_x,pos_y);
    settings = parent.settings;
    parent_view = parent; 
    parent_view.addSlider(this);
    
    sliderWidth = settings.standard_input_width;
    sliderHeight = settings.standard_input_height;
    sliderLabel = label;
    
    sliderMinValue = 0;
    sliderMaxValue = 100;
    sliderValue = 50;
    
    setDimensions();    
  }
  
  void setDimensions() { 
    sliderBoxHeight = 0.35*sliderHeight;
    sliderBoxWidth = sliderBoxHeight;
    
    int xo = (int)(initial_position.x*settings.standard_block_size) - sliderWidth/2;
    int yo = (int)(initial_position.y*settings.standard_block_size) - sliderHeight/2;
    
    origin = new PVector(xo,yo);
    sliderMinPixel = origin.x + sliderBoxWidth/2;
    sliderMaxPixel = origin.x + sliderWidth - sliderBoxWidth/2;
    sliderPixel = (sliderMinPixel + sliderMaxPixel)/2;   
  }
  
  void setParameters(float min, float max, float current, int prec) {
    sliderMinValue = min;
    sliderMaxValue = max;
    sliderValue = current;
    sliderPrecision = prec;
    updateSliderPixel();
  }
  
  void updateSliderPixel() {
    float ratio = (sliderValue-sliderMinValue)/(sliderMaxValue-sliderMinValue);
    sliderPixel = sliderMinPixel + (sliderMaxPixel-sliderMinPixel)*ratio;
    
    // reset the precision:
    updateSliderValue();
  }
  
  void updateSliderValue() {
    float f = pow(10,sliderPrecision);
    sliderValue = map(sliderPixel,sliderMinPixel,sliderMaxPixel,sliderMinValue,sliderMaxValue);
    sliderValue = round(sliderValue*f) / f;
    
    if (roundHalf) sliderValue = round(2.0*sliderValue)/2.0;
  }
  
  void setValue(float v) {
     sliderValue = v;
     updateSliderPixel();
  }
  
  void enable() {
    isClickable = true;  
    background_color = active_color;
  }
  
  void disable() {
    isClickable = false;  
    background_color = inactive_color;
  }
  
  // ************* listener functions ***********
  
  public void addListener(SliderListener s) {
     listeners.add(s); 
  }

  public void onSlide() {
    if (!parent_view.isClickable) return;
    if (!isClickable) return;
    for (SliderListener s : listeners) s.onSlide(this);
  }
  
// ************** mouse functions: ************
  boolean mouseIsOver() {
    //float xo = parent_view.origin.x + origin.x;
    float xo = parent_view.origin.x + sliderPixel - sliderBoxWidth/2;
    float yo = parent_view.origin.y + origin.y + sliderHeight/2;
    
    if (mouseX > xo && mouseX < xo+sliderBoxWidth && mouseY > yo && mouseY < yo+sliderHeight/2) {
      isMouseOver = true;
    }
    else {
      isMouseOver = false;
    }
    
    return isMouseOver;
  }
  
  boolean msePressed() {
    if (!isClickable) return false;
    
    if (mouseIsOver()) {
      startPixel = mouseX;
      isLocked = true;
      return true;
    }
    return false;
  }
  
  void mseDragged() {
   if (isLocked) {
     deltaPixel = mouseX - startPixel;
     sliderPixel += deltaPixel;
     sliderPixel = constrain(sliderPixel,sliderMinPixel,sliderMaxPixel);
     startPixel = mouseX;
     updateSliderValue();
     onSlide();
   }
  }
  
  void mseReleased() {
   if (isLocked) {
     // update the new slider value
     isLocked = false;
   }
  }
  
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }
  
  // **************** display functions: **********************
                 
  void display() {
    
    PGraphics pg = parent_view.pg_current;
    float spacer = textWidth('0');
    
    if (!isClickable) background_color = inactive_color;
    
    // begin:
    pg.beginDraw();
    
    // position and draw rectangle:
    pg.strokeWeight(1);
    pg.stroke(0);
    pg.rectMode(CORNER);
    pg.fill(background_color);
    pg.rect(origin.x,origin.y,sliderWidth,sliderHeight);
    pg.fill(inactive_color);
    pg.rect(origin.x,origin.y,sliderWidth,sliderHeight/2);
    
    // slider line:
    pg.strokeWeight(2);
    float y=origin.y + 0.75*sliderHeight;
    pg.line(sliderMinPixel,y,sliderMaxPixel,y);
    
    // slider box:
    pg.rectMode(CENTER);
    pg.fill(255);
    pg.strokeWeight(1);
    pg.rect(sliderPixel,y,sliderBoxWidth,sliderBoxHeight);
    
    // add label text:
    String s = sliderLabel + " " + sliderValue;
    pg.fill(0);
    pg.textSize(settings.standard_text_height);
    pg.textAlign(LEFT,CENTER); 
    //pg.text(sliderLabel,origin.x+spacer,origin.y);
    pg.text(s,origin.x+spacer,origin.y+sliderHeight/4);
    
    // finish:
    pg.endDraw();
   
  }
}

// ***************************************************
class CategoriedSlider extends Slider {
  
  ArrayList<String> categories = new ArrayList<String>();
  int cat_index;
  int n_categories;
  String sliderCategory;
  
  CategoriedSlider(View parent, float pos_x, float pos_y, String label, String[] cats) {
    super(parent, pos_x, pos_y, label);
    
    for (int i=0; i<cats.length; i++) {
      categories.add(cats[i]);
    }
    cat_index = 0;
    sliderCategory = categories.get(cat_index);
  }
  
  int get_cat_index() {
    float r = (sliderPixel - sliderMinPixel) / (sliderMaxPixel - sliderMinPixel);
    int ind = (int) (r * (categories.size()-0.5));
    return ind;
  }
  
  @Override
  void updateSliderValue() {
    super.updateSliderValue();
    int index = get_cat_index();
    sliderCategory = categories.get(index);
  }
  
  @Override
  void display() {
    
    PGraphics pg = parent_view.pg_current;
    float spacer = textWidth('0');
    
    if (!isClickable) background_color = inactive_color;
    
    // begin:
    pg.beginDraw();
    
    // position and draw rectangle:
    pg.strokeWeight(1);
    pg.stroke(0);
    pg.rectMode(CORNER);
    pg.fill(background_color);
    pg.rect(origin.x,origin.y,sliderWidth,sliderHeight);
    pg.fill(inactive_color);
    pg.rect(origin.x,origin.y,sliderWidth,sliderHeight/2);
    
    // slider line:
    pg.strokeWeight(2);
    float y=origin.y + 0.75*sliderHeight;
    pg.line(sliderMinPixel,y,sliderMaxPixel,y);
    
    // slider box:
    pg.rectMode(CENTER);
    pg.fill(255);
    pg.strokeWeight(1);
    pg.rect(sliderPixel,y,sliderBoxWidth,sliderBoxHeight);
    
    // add label text:
    String s = sliderLabel + " " + sliderCategory;
    pg.fill(0);
    pg.textSize(settings.standard_text_height);
    pg.textAlign(LEFT,CENTER); 
    //pg.text(sliderLabel,origin.x+spacer,origin.y);
    pg.text(s,origin.x+spacer,origin.y+sliderHeight/4);
    
    // finish:
    pg.endDraw();
   
  }
  
}
