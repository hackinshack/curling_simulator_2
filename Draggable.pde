// ***********************************************************************
// Draggable Class
// ***********************************************************************
//

class Draggable {
  
  private ArrayList<DraggableListener> listeners = new ArrayList<DraggableListener>();
  View parent_view;
  SettingsController settings;
  int draggerIndex;
  
  PVector origin;
  PVector initial_position;
  
  float draggerWidth, draggerHeight;
  float startPixel_x, startPixel_y;
  float deltaPixel_x, deltaPixel_y;
  float draggerMinPixel_x=-99999, draggerMaxPixel_x=99999;
  float draggerMinPixel_y=-99999, draggerMaxPixel_y=99999;

  boolean isClickable = true;
  boolean isVisible = true;
  boolean isMouseOver = false;
  boolean isFocus = false;
  boolean isLocked = false;
  boolean team1 = true;
  
  color fill_color = color(255,0,0);
  
  Draggable(View parent, float xpos_blocks, float ypos_blocks, float wblocks, float hblocks) {
    
    //initial_position = new PVector(pos_x,pos_y);
    settings = parent.settings;
    parent_view = parent; 
    parent_view.addDragger(this);
    
    origin = new PVector((int) (xpos_blocks*settings.standard_block_size),(int) (ypos_blocks*settings.standard_block_size));
    initial_position = origin.copy();
    
    draggerWidth = wblocks*settings.standard_block_size;
    draggerHeight = hblocks*settings.standard_block_size;
  }
  
  
  // ************* listener functions ***********
  
  public void addListener(DraggableListener d) {
     listeners.add(d); 
  }

  public void onDrag() {
    if (!parent_view.isClickable) return;
    for (DraggableListener d : listeners) d.onDrag(this);
  }
  
  // ********************************************
  
  void set_constraints(float xmin, float ymin, float xmax, float ymax) {
    draggerMinPixel_x = xmin;
    draggerMaxPixel_x = xmax;
    draggerMinPixel_y = ymin;
    draggerMaxPixel_y = ymax;    
  }
  
  void reset_position() {
    origin = initial_position.copy();
  }
  
// ************** mouse functions: ************
  boolean mouseIsOver() {
    
    float xo = parent_view.origin.x + origin.x - draggerWidth/2;
    float yo = parent_view.origin.y + origin.y - draggerHeight/2;
    
    if (mouseX > xo && mouseX < xo+draggerWidth && mouseY > yo && mouseY < yo+draggerHeight) {
      isMouseOver = true;
    }
    else {
      isMouseOver = false;
    }
    
    return isMouseOver;
  }
  
  boolean msePressed() {
    if (!parent_view.isClickable) return false;
    if (!isClickable) return false;
    
    if (mouseIsOver()) {
      startPixel_x = mouseX;
      startPixel_y = mouseY;
      isLocked = true;
      return true;
    }
    return false;
  }
  
  void mseDragged() {
    if (!parent_view.isClickable) return;
    if (!isClickable) return;
    
   if (isLocked) {
     deltaPixel_x = mouseX - startPixel_x;
     deltaPixel_y = mouseY - startPixel_y;
     
     origin.x += deltaPixel_x;
     origin.y += deltaPixel_y;

     startPixel_x = mouseX;
     startPixel_y = mouseY;

     origin.x = constrain(origin.x,draggerMinPixel_x,draggerMaxPixel_x);
     origin.y = constrain(origin.y,draggerMinPixel_y,draggerMaxPixel_y);
     
     onDrag();
   }
  }
  
  void mseReleased() {
   if (!parent_view.isClickable) return;
   if (!isClickable) return;
   
   if (isLocked) {
     isLocked = false;
   }
  }
  
  // **************** display functions: **********************
                 
  void display() {
    
    if (!isVisible) return;
    
    PGraphics pg = parent_view.pg_current;
    
    fill_color = game.team1.team_color;
    if (!team1) fill_color = game.team2.team_color;

    // begin:
    pg.beginDraw();
    
    // position and draw rectangle:
    
    pg.stroke(0);
    pg.fill(fill_color);
    pg.ellipseMode(CENTER);
    pg.ellipse(origin.x,origin.y,draggerWidth,draggerHeight);
    
    // finish:
    pg.endDraw();
   
  }
}
