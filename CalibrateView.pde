 class CalibrateView extends View {

  Button color1_Button, color2_Button;
  Button clear_Button;
  ButtonOnOff frontL_Button, frontR_Button, backL_Button, backR_Button;
  ButtonOnOff image_Button, detect_Button, acquire_Button;
  Button camera_Button, play_Button;
  
  Input stoneDiameter_Input;
  Input zoneWidth_Input, zoneDepth_Input;
  Input screenHeight_Input, screenDepth_Input; 
  Input hackDepth_Input;
  Input viewWidth_Input;
  
  Slider colorTolerance_Slider;
  
  CalibrateView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    construct();
  }
  
  void construct() {
    
    // section 1:
    color1_Button = new Button(this,0.5, 0.6, "set color 1");
    color2_Button = new Button(this,0.5, 0.8, "set color 2");
    stoneDiameter_Input = new Input(this,2.5,0.7, "diameter:");
    colorTolerance_Slider = new Slider(this,1.5, 0.7, "tol:");
    
    // section 2:
    zoneWidth_Input = new Input(this,0.5, 1.4, "zoneWidth:");
    zoneDepth_Input = new Input(this,0.5, 1.8, "zoneDepth:");
    hackDepth_Input = new Input(this,1.5, 1.8, "hackDist:");
    
    frontL_Button = new ButtonOnOff(this,1.5,1.3,"frontLeft");
    frontR_Button = new ButtonOnOff(this,2.5,1.3,"frontRight");
    backL_Button = new ButtonOnOff(this,1.5,1.5,"backLeft");
    backR_Button = new ButtonOnOff(this,2.5,1.5,"backRight");
    clear_Button = new Button(this,2.5,1.7,"clear");
    
    // section 3:
    screenHeight_Input = new Input(this,0.5, 2.5, "screenHeight:");
    screenDepth_Input = new Input(this,1.5, 2.5, "screenDepth:");
    viewWidth_Input = new Input(this, 2.5, 2.5, "viewWidth:");
    
    // section 4:
    image_Button = new ButtonOnOff(this,0.5,3.1,"image:");
    detect_Button = new ButtonOnOff(this,1.5,3.1,"detect:");
    acquire_Button = new ButtonOnOff(this,2.5,3.1,"acquire:");
    image_Button.buttonValue = true;
    
    // section 5:
    play_Button = new Button(this,2.5,3.5,"save");
    camera_Button = new Button(this,0.5,3.5,"camera");

  }
  
  void reset() {
    game.real.dzone.resetAcquire();
    game.real.dzone.detectOn = false;
    game.real.dzone.acquireOn = false;
    game.virtual.stone.reset();
    
    detect_Button.buttonValue = false;
    acquire_Button.buttonValue = false;
  }
  
 // **************** GUI functions: **************************************

 void pushToGUI() { 
   
   colorTolerance_Slider.sliderValue = game.real.stone.color_tolerance;
   colorTolerance_Slider.updateSliderPixel();
   
   color1_Button.active_color = game.real.stone.color1;
   color2_Button.active_color = game.real.stone.color2;
   
   stoneDiameter_Input.set_input_string(String.valueOf(game.real.stone.diameter));
   
   zoneWidth_Input.set_input_string(String.valueOf(game.real.dzone.zoneWidth));
   zoneDepth_Input.set_input_string(String.valueOf(game.real.dzone.zoneDepth));
   hackDepth_Input.set_input_string(String.valueOf(game.real.dzone.hackDepth));
   
   screenHeight_Input.set_input_string(String.valueOf(game.real.screen.height_offset));
   screenDepth_Input.set_input_string(String.valueOf(game.real.screen.depth_offset));
   viewWidth_Input.set_input_string(String.valueOf(expanded_width / game.real.screen.pixels_per_PU));

 }
 
 void pullFromGUI() {
   // the GUI elements update the data variables upon click/slide/update
   // leave it this way to keep the test acquisition capability working properly
 }
 
 // **********implement listener interface functions: *********************
  
  @Override
  void onClick(Button b) {
    
    if (b==color1_Button) {
      game.real.stone.color1 = game.real.stone.selectedColor;
      b.active_color = game.real.stone.selectedColor;
      messages.addLine("stone color 1 set");
      return;
    }
    
    if (b==color2_Button) {
      game.real.stone.color2 = game.real.stone.selectedColor;
      b.active_color = game.real.stone.selectedColor;
      messages.addLine("stone color 2 set");
      return;
    }

    if (b==frontL_Button) {
      game.real.camera.cam_image.loadPixels();
      PVector p = game.real.dzone.stone_center_pixels(game.real.camera.cam_image);
      game.real.dzone.setCornerPixel(FRONT_LEFT,p);
      messages.addLine("front left corner set");
      return;
    }
    
    if (b==frontR_Button) {
      game.real.camera.cam_image.loadPixels();
      PVector p = game.real.dzone.stone_center_pixels(game.real.camera.cam_image);
      game.real.dzone.setCornerPixel(FRONT_RIGHT,p);
      messages.addLine("front right corner set");
      return;
    }
    
    if (b==backL_Button) {
      game.real.camera.cam_image.loadPixels();
      PVector p = game.real.dzone.stone_center_pixels(game.real.camera.cam_image);
      game.real.dzone.setCornerPixel(BACK_LEFT,p);
      messages.addLine("back left corner set");
      return;
    }
    
    if (b==backR_Button) {
      game.real.camera.cam_image.loadPixels();
      PVector p = game.real.dzone.stone_center_pixels(game.real.camera.cam_image);
      game.real.dzone.setCornerPixel(BACK_RIGHT,p);
      messages.addLine("back right corner set");
      return;
    }
    
    if (b==image_Button) {
      camera_view.pictureOn = !camera_view.pictureOn;
      return;
    }
    
    if (b==detect_Button) {
      game.real.dzone.detectOn = !game.real.dzone.detectOn;
      if (game.real.dzone.detectOn) game.real.stone.reset();
      return;
    }
    
    if (b==acquire_Button) {
      if (!game.real.dzone.detectOn) {
        b.buttonValue = false;
        messages.addLine("activate detection zone prior to acquire");
        return; 
      }
      
      if (b.buttonValue) {
        camera_view.minimize();
        game.virtual.stone.reset();
        game.real.stone.reset();
        game.real.dzone.resetAcquire();
        game.real.dzone.acquireOn = true;
      }
      return;
    }
    
    if (b==clear_Button) {
      game.real.dzone.clearCorners();
      game.conversions.updateRequired = true;
      messages.addLine("detection zone cleared");
      return;
    }
    
    if (b==play_Button) {
      calibrationsIO.pushToFile();
      //camera_view.start_camera();
      mode_controller.transfer_control(setup_mode);
      return;
    } 
    
    if (b==camera_Button) {
       camera_view.createCameraSelector();
    }
  
  }

  @Override
  void onUpdate(Input i) {
    
    if (i==stoneDiameter_Input) {
      game.real.stone.diameter = stoneDiameter_Input.inputValue;
      messages.addLine("sensor stone diameter set");
      return;
    }
    
    if (i==zoneWidth_Input) {
      game.real.dzone.zoneWidth = zoneWidth_Input.inputValue;
      game.real.dzone.computeTransform();
      messages.addLine("detection zone width set: " + game.real.dzone.zoneWidth);
      return;
    }
    
    if (i==zoneDepth_Input) {
      game.real.dzone.zoneDepth = zoneDepth_Input.inputValue;
      game.real.dzone.computeTransform();
      messages.addLine("detection zone depth set");
      return;
    }
    
    if (i==screenHeight_Input) {
      game.real.screen.height_offset = screenHeight_Input.inputValue;
      messages.addLine("height of screen set");
      return;
    }
    
    if (i==screenDepth_Input) {
      game.real.screen.depth_offset = screenDepth_Input.inputValue;
      messages.addLine("depth of screen set");
      return;
    }

    if (i==hackDepth_Input) {
      game.real.dzone.hackDepth = hackDepth_Input.inputValue;
      messages.addLine("hack distance set");
      return;
    }
    
    if (i==viewWidth_Input) {
      game.real.screen.update_pixels_per(expanded_width, viewWidth_Input.inputValue);
      messages.addLine("width of calibration view set");
      return;
    }
  }
  
  @Override
  void onSlide(Slider s) {
    
    if (s==colorTolerance_Slider) {
      if (s==colorTolerance_Slider) game.real.stone.color_tolerance = colorTolerance_Slider.sliderValue;
      return;
    }   

  }
  
  
  // ****************** display ******************
  @Override 
  void display() {
    super.display();

    frontL_Button.buttonValue = !(game.real.dzone.corner_pixels[FRONT_LEFT].x == UNASSIGNED);
    frontR_Button.buttonValue = !(game.real.dzone.corner_pixels[FRONT_RIGHT].x == UNASSIGNED);
    backL_Button.buttonValue = !(game.real.dzone.corner_pixels[BACK_LEFT].x == UNASSIGNED);
    backR_Button.buttonValue = !(game.real.dzone.corner_pixels[BACK_RIGHT].x == UNASSIGNED);
  }
  
  @Override
  void drawContent() {
   
    pg_current.beginDraw();
    
    int tsize = (int)((settings.standard_title_height+settings.standard_text_height)/2);
    
    // draw section headings:
    pg_current.fill(0);
    pg_current.textSize(tsize);
    pg_current.text("stone properties:",blocks_to_pixels(0.1),blocks_to_pixels(0.4));
    pg_current.text("detection zone properties:",blocks_to_pixels(0.1),blocks_to_pixels(1.1));
    pg_current.text("projection screen properties:",blocks_to_pixels(0.1),blocks_to_pixels(2.2));
    pg_current.text("test data acquisition:",blocks_to_pixels(0.1),blocks_to_pixels(2.9));
    
    // draw division lines:
    pg_current.stroke(0);
    pg_current.strokeWeight(1);
    
    draw_horizontal_line(blocks_to_pixels(1.0));
    draw_horizontal_line(blocks_to_pixels(2.1));
    draw_horizontal_line(blocks_to_pixels(2.8));
    draw_horizontal_line(blocks_to_pixels(3.3));
 
    pg_current.endDraw();
  }
  
}
