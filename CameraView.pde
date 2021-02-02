class CameraView extends View {
  
  SettingsController settings = new SettingsController();
  Utilities ut;

  String[] camera_choices;
  String messageString = "Select camera:";
  ArrayList<Button> cam_choice_Buttons = new ArrayList<Button>();
  
  PVector cam_origin;
  color pressedColor,trackColor1, trackColor2; 
  color brightOrange = color(250,150,80);
  
  boolean isPressed = false;
  boolean highlightOn = true;
  boolean pictureOn = true;
  
  CameraRGB camera = game.real.camera;
  
  CameraView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    cam_origin = new PVector(0,settings.standard_topbar_height);
    pressedColor = color(255);  
    settings.background_color = random_color_light();
    
    ut = new Utilities();
 
  }
  
  boolean start_camera() {
    if (camera.isRunning) return true;
    
    if (camera.camera_name == "none") {
     createCameraSelector();
     return false;
    }

    try {
      camera.start(camera.camera_name);
      setExpandedSize(camera.imageWidth,camera.imageHeight + settings.standard_topbar_height,false);
      resetOrigin();
      return true;
    }
    catch (Exception e) {
      camera.isRunning = false;
      return false;
    }
  }
  
  void createCameraSelector() {
    if (camera.isRunning) camera.stop();
    camera_choices = Capture.list();
    
    if (camera_choices.length == 0) {
       messageString = "No camera found.";
       return;
    }
    
    messageString = "Select camera:";
    
    cam_choice_Buttons = new ArrayList<Button>();
    
    // now make a button for each camera choice:
    for (int i=0; i<camera_choices.length; i++) {
       cam_choice_Buttons.add(new Button(this,1.5,1.0 + 0.25*i,camera_choices[i]));
    }
    
    for (Button b : cam_choice_Buttons) {
      b.buttonWidth = (int)blocks_to_pixels(2.0);
    }
     
  }

  // ****************** display ******************
  @Override 
  void display() {
    
    super.display();
    
    if (!isVisible) return;
    if (!camera.isRunning) return;

    int x,y;
    x = (int)(origin.x + cam_origin.x);
    y = (int)(origin.y + cam_origin.y);
    if (isExpanded) {
      if (pictureOn) camera.display(x, y);
      if (highlightOn) {
        highlight_pixels(pressedColor,brightOrange); 
        game.real.stone.selectedColor = pressedColor;
        PVector cm = game.real.dzone.center_mass_pixels(camera.cam_image,pressedColor);
        fill(0);
        if (cm != null) ellipse(x + cm.x,y + cm.y,10,10); 
        
        // highlight the center of mass of the current real.stone colors:
        noFill();
        stroke(0);
        strokeWeight(1);
        cm = game.real.dzone.center_mass_pixels(camera.cam_image,game.real.stone.color1);
        if (cm != null) ellipse(x + cm.x,y + cm.y,20,20);
        cm = game.real.dzone.center_mass_pixels(camera.cam_image,game.real.stone.color2);
        if (cm != null) ellipse(x + cm.x,y + cm.y,20,20);
        
        outline_search_region();
      }
    }

  }
  
  @Override
  void drawContent() {
    // show message:
    if (camera.isRunning) return;
    pg_current.beginDraw();
    pg_current.fill(0);
    pg_current.text(messageString,10,100);
    pg_current.endDraw();
  }
  

  
// **********implement listener interface functions: *********************
  
  @Override
  void onClick(Button b) {
    
    for (Button cb : cam_choice_Buttons) {
      if (b == cb) {
        camera.camera_name = b.buttonLabel;
        start_camera();
      }
      cb.isVisible = false;
      cb.isClickable = false;
    }

  }  
  
  // **************** mouse **********************
  @Override 
  void msePressed() {
     super.msePressed();
     
     if (!camera.isRunning) return;
     
     if (mouseIsOverImage()) {
       isPressed = true;
       int loc = int(mouseX-origin.x-cam_origin.x) + int(mouseY-origin.y-cam_origin.y)*camera.imageWidth;
       pressedColor = camera.cam_image.pixels[loc];
     }
     else isPressed = false;
    
  }
  
  boolean mouseIsOverImage() {
    float xmin = origin.x + cam_origin.x;
    float xmax = origin.x + cam_origin.x + camera.imageWidth;
    float ymin = origin.y + cam_origin.y;
    float ymax = origin.y + cam_origin.y + camera.imageHeight; 
    
    if (mouseX > xmin && mouseX < xmax && mouseY > ymin && mouseY < ymax) {
      return true;
    }
    return false;
  }
  
  // ********************************************
  
  void highlight_pixels(color p, color h) {
      
    noStroke();
    fill(h);
    float r2 = red(p);
    float g2 = green(p);
    float b2 = blue(p);
    float tol = (game.real.stone.color_tolerance)*(game.real.stone.color_tolerance);
    
    camera.cam_image.loadPixels();
    
    for (int x = 0; x < camera.imageWidth; x++ ) {
      for (int y = 0; y < camera.imageHeight; y++ ) {
       
       int loc1 = x + y * camera.imageWidth;
       color currentColor = camera.cam_image.pixels[loc1];
       
       float r1 = red(currentColor);
       float g1 = green(currentColor);
       float b1 = blue(currentColor);
 
       float d = ut.distSq(r1, g1, b1, r2, g2, b2); 
  
       if (d < tol) { 
         ellipse(origin.x+cam_origin.x+x,origin.y+cam_origin.y+y,2,2); // drawing many tiny circles is very time consuming
       }
        
      }
    }
  }
  
  void outline_search_region() {
    float offset_x = origin.x+cam_origin.x;
    float offset_y = origin.y+cam_origin.y;
    float xmin = camera.search_region_min.x + offset_x;
    float ymin = camera.search_region_min.y + offset_y;
    float xmax = camera.search_region_max.x + offset_x;
    float ymax = camera.search_region_max.y + offset_y;
    
    noFill();
    stroke(0);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(xmin,ymin,xmax,ymax);
    
  }
  
}
