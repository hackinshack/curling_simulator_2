class SettingsView extends View {
 
  // game options:
  ToggleGroup gameOptions_group;
  ToggleGroupButton standard_Button;
  ToggleGroupButton doubles_Button;
  ToggleGroupButton crazy_Button;
  ToggleGroupButton practice_Button;
  
  // red team options:
  ToggleGroup redOptions_group;
  ToggleGroupButton redPhysical_Button;
  ToggleGroupButton redVirtual_Button;
  Button red_Button;
  
  Slider redDelivery_Slider;
  Slider redSweep_Slider;
  
  // yellow team options:
  ToggleGroup yellowOptions_group;
  ToggleGroupButton yellowPhysical_Button;
  ToggleGroupButton yellowVirtual_Button;
  
  //ToggleGroupButton yellowAI_Button;
  Button yellow_Button;  
  Slider yellowDelivery_Slider;
  Slider yellowSweep_Slider;
  
  // doubles power play options:
  ButtonOnOff powerPlay_Button;
  ButtonSwitch powerPosition_Button;
  
  // ice conditions:
  Slider curl_Slider;
  Slider speed_Slider;
  Slider range_Slider;
  
  // broom:
  ToggleGroup broomOptions_group;
  ToggleGroupButton broomVirtual_Button;
  ToggleGroupButton broomPhysical_Button;
  
  // virtual camera:
  Slider vcamFOV_Slider;
  Slider vcamDepth_Slider;
  
  // other buttons:
  ButtonSwitch hammer_Button;
  Button play_Button;
  Button calibrate_Button;
  Button outerHouseColor_Button;
  Button innerHouseColor_Button;
  Button skipColor_Button;
  Button defaults_Button;
  
   
  SettingsView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    construct();
    
  }
  
  void construct() {
    
    // column 1:
    gameOptions_group = new ToggleGroup(this);
    standard_Button = new ToggleGroupButton(this, 0.5, 0.55, "standard",gameOptions_group);
    doubles_Button = new ToggleGroupButton(this, 0.5, 0.75, "doubles",gameOptions_group);
    crazy_Button = new ToggleGroupButton(this, 0.5, 0.95, "crazy 8",gameOptions_group);
    practice_Button = new ToggleGroupButton(this, 0.5, 1.15, "practice",gameOptions_group);
    
    powerPlay_Button = new ButtonOnOff(this, 0.5, 1.6, "power play");
    powerPosition_Button = new ButtonSwitch(this, 0.5, 1.8, "position:");
    
    hammer_Button = new ButtonSwitch(this,0.5,2.15,"hammer");
    defaults_Button = new Button(this,0.5,2.5,"defaults");
    
    // column 2:
    redOptions_group = new ToggleGroup(this);
    red_Button = new Button(this,1.5,0.55," ");   
    redPhysical_Button = new ToggleGroupButton(this,1.5,0.75,"physical",redOptions_group);
    redVirtual_Button = new ToggleGroupButton(this,1.5,0.95,"virtual",redOptions_group); 
    redDelivery_Slider = new Slider(this,1.5,1.55,"delivery: ");
    redSweep_Slider = new Slider(this,1.5,1.95,"sweep: ");
   
    // column 3:
    yellowOptions_group = new ToggleGroup(this);  
    yellow_Button = new Button(this,2.5,0.55," ");
    yellowPhysical_Button = new ToggleGroupButton(this,2.5,0.75,"physical",yellowOptions_group);
    yellowVirtual_Button = new ToggleGroupButton(this,2.5,0.95,"virtual",yellowOptions_group);
    yellowDelivery_Slider = new Slider(this,2.5,1.55,"delivery: ");
    yellowSweep_Slider = new Slider(this,2.5,1.95,"sweep: ");
    
    // column 4:
    curl_Slider = new Slider(this, 3.5, 0.65, "curl: ");
    speed_Slider = new Slider(this, 3.5, 1.05, "speed: ");
    range_Slider = new Slider(this, 3.5, 1.45, "range");
    
    curl_Slider.sliderMinValue = 0.0;
    curl_Slider.sliderMaxValue = 10.0;
    curl_Slider.sliderValue = 4.0;
    curl_Slider.sliderPrecision = 1;
    curl_Slider.updateSliderPixel();
    
    speed_Slider.sliderValue = 75;
    speed_Slider.sliderPrecision = 1;
    speed_Slider.updateSliderPixel();
    
    range_Slider.sliderMinValue = 0.0;
    range_Slider.sliderMaxValue = 30.0;
    range_Slider.sliderValue = 10.0;
    range_Slider.sliderPrecision = 1;
    range_Slider.updateSliderPixel();
    
    broomOptions_group = new ToggleGroup(this);
    broomPhysical_Button = new ToggleGroupButton(this, 3.5, 1.95, "physical", broomOptions_group);
    broomVirtual_Button = new ToggleGroupButton(this, 3.5, 2.15, "virtual", broomOptions_group);
    
    // column 5:
    outerHouseColor_Button = new Button(this,4.5,0.55,"outer house");
    innerHouseColor_Button = new Button(this,4.5,0.75,"inner house");
    skipColor_Button = new Button(this,4.5,0.95,"virtual skip");
    
    vcamFOV_Slider = new Slider(this, 4.5, 1.55, "1/FOV:");
    vcamDepth_Slider = new Slider(this, 4.5, 1.95, "depth:");
    
    vcamFOV_Slider.sliderMinValue = 1;
    vcamFOV_Slider.sliderMaxValue = 60;
    vcamFOV_Slider.sliderValue = 3;
    vcamFOV_Slider.sliderPrecision = 1;
    vcamFOV_Slider.updateSliderPixel();

    vcamDepth_Slider.sliderMinValue = -100;
    vcamDepth_Slider.sliderMaxValue = 30;
    vcamDepth_Slider.sliderValue = 10;
    vcamDepth_Slider.sliderPrecision = 1;
    vcamDepth_Slider.updateSliderPixel();
    

    // bottom section:
    calibrate_Button = new Button(this,3.5,2.5,"calibrate");
    play_Button = new Button(this,4.5,2.5,"play");
    
    // until we add the physical broom, later version:
    broomPhysical_Button.disable();  

  }
  
  void set_hammer_color() {
    if (hammer_Button.buttonValue) hammer_Button.switchBoxColor = yellow_Button.active_color;
    else hammer_Button.switchBoxColor = red_Button.active_color;
  }
  
 // **************** GUI functions: **************************************

  void pushToGUI() { 
    
     gameOptions_group.set_toggleIndex(game.type);
     curl_Slider.sliderValue = game.ice_curl;
     speed_Slider.sliderValue = game.nominal_button_velocity;  
     range_Slider.sliderValue = game.ice_velocity_range;
     broomOptions_group.set_toggleIndex(game.broom_type);
     hammer_Button.buttonValue = game.hammer;
     
     red_Button.active_color = game.team1.team_color;
     redOptions_group.set_toggleIndex(game.team1.player_mode);
     redDelivery_Slider.sliderValue = game.team1.skill_delivery;
     redSweep_Slider.sliderValue = game.team1.skill_sweep;

     yellow_Button.active_color = game.team2.team_color;
     yellowOptions_group.set_toggleIndex(game.team2.player_mode); 
     yellowDelivery_Slider.sliderValue = game.team2.skill_delivery;
     yellowSweep_Slider.sliderValue = game.team2.skill_sweep;   
     
     vcamFOV_Slider.sliderValue = PI / game.conversions.scene.camera.fovy;
     vcamDepth_Slider.sliderValue = game.conversions.scene.camera.eyeY / 12;
     
     outerHouseColor_Button.active_color = game.virtual.ice.outer_color;
     innerHouseColor_Button.active_color = game.virtual.ice.inner_color;
     skipColor_Button.active_color = game.virtual.skip_broom.broom_color;
    
     // update slider values:
     curl_Slider.updateSliderPixel();
     speed_Slider.updateSliderPixel();
     range_Slider.updateSliderPixel();
     redDelivery_Slider.updateSliderPixel();
     redSweep_Slider.updateSliderPixel();
     yellowDelivery_Slider.updateSliderPixel();
     yellowSweep_Slider.updateSliderPixel();
     vcamFOV_Slider.updateSliderPixel();
     vcamDepth_Slider.updateSliderPixel();
     
     set_hammer_color();

  }
  
  void pullFromGUI() {
    // could distribute these update throughout the click/slide/update functions
    // for real-time updates, as some are already
    
    game.type = gameOptions_group.get_toggleIndex();
    game.ice_curl = curl_Slider.sliderValue;
    game.nominal_button_velocity = speed_Slider.sliderValue;
    game.ice_velocity_range = range_Slider.sliderValue;
    game.broom_type = broomOptions_group.get_toggleIndex();
    game.hammer = hammer_Button.buttonValue;
    
    game.team1.team_color = red_Button.active_color;
    game.team1.player_mode = redOptions_group.get_toggleIndex();
    game.team1.skill_delivery = redDelivery_Slider.sliderValue;
    game.team1.skill_sweep = redSweep_Slider.sliderValue;
    
    game.team2.team_color = yellow_Button.active_color;
    game.team2.player_mode = yellowOptions_group.get_toggleIndex();
    game.team2.skill_delivery = yellowDelivery_Slider.sliderValue;
    game.team2.skill_sweep = yellowSweep_Slider.sliderValue;    
    
    game.set_hammer(hammer_Button.buttonValue);
    game.powerPlay = powerPlay_Button.buttonValue;
    game.powerPosition = powerPosition_Button.buttonValue;
     
    game.conversions.scene.camera.fovy = PI / vcamFOV_Slider.sliderValue;
    game.conversions.scene.camera.eyeY = 12 * vcamDepth_Slider.sliderValue;
    
  }
  
  void onDraw() {
   // these are things that happen every draw loop
   
   powerPlay_Button.disable();
   powerPosition_Button.disable();
   redDelivery_Slider.disable();
   yellowDelivery_Slider.disable();
   speed_Slider.disable();
   range_Slider.disable();
   calibrate_Button.disable();
   
   yellowPhysical_Button.enable();
   yellowVirtual_Button.enable();
   yellowSweep_Slider.enable();
     
   if (game.type == DOUBLES) {
     powerPlay_Button.enable();
     powerPosition_Button.enable();
   }
   
   if (game.type == PRACTICE) {
     yellowPhysical_Button.disable();
     yellowVirtual_Button.disable();
     yellowSweep_Slider.disable();
   }
   
   if (game.team1.player_mode == VIRTUAL) {
     redDelivery_Slider.enable();
   }
   
   if (game.team2.player_mode == VIRTUAL && game.type != PRACTICE) {
     yellowDelivery_Slider.enable();
   }
    
   if (game.team1.player_mode == PHYSICAL || game.team2.player_mode == PHYSICAL) {
     speed_Slider.enable();
     range_Slider.enable();
     calibrate_Button.enable();
   }
    
  }

  @Override
  void onClick(Button b) {
   
    game.type = gameOptions_group.get_toggleIndex();
    game.team1.player_mode = redOptions_group.get_toggleIndex();
    game.team2.player_mode = yellowOptions_group.get_toggleIndex();
    
    // color buttons:
    
    if (b == red_Button) { 
      color_view.open(red_Button);
      return; 
    }
    
    if (b == yellow_Button) { 
      color_view.open(yellow_Button);
      return; 
    }    
    
    if (b == outerHouseColor_Button) { 
      color_view.open(outerHouseColor_Button);
      return; 
    }
    
    if (b == innerHouseColor_Button) { 
      color_view.open(innerHouseColor_Button);
      return; 
    }
    
    if (b == skipColor_Button) { 
      color_view.open(skipColor_Button);
      return; 
    }
    
    if (b == calibrate_Button) { 

      mode_controller.transfer_control(calibrate_mode);
      return; 
    }

    if (b == play_Button) {  
      // if we have a physical player, make sure the calibrations are set and the camera is running
      // if so, begin play.  if not, go to calibration mode.
      
      if (game.team1.player_mode == PHYSICAL || game.team2.player_mode == PHYSICAL) {
        if (!game.real.dzone.isCalibrated() || !camera_view.start_camera())  {
          mode_controller.transfer_control(calibrate_mode);
          return; 
        }
      }

      game.conversions.get_conversion_factors();
      settingsIO.pushToFile();
      settingsIO.pullFromFile(); // this reloads the parameters and runs the functions that run on reload
      game.reset();
      mode_controller.transfer_control(play_mode);
      return; 
    }
    
    if (b == hammer_Button) { 
      set_hammer_color();
      return; 
    }
    
    if (b == defaults_Button) {
       settingsIO.setDefaults();
       settingsIO.pushToGUI();
       return;
    }
    
  }
  
  @Override
  void onColorChange(Button b) {
    
    set_hammer_color();
    
    if (b == outerHouseColor_Button) { 
      game.virtual.ice.outer_color = b.active_color;
      return; 
    }
    
    if (b == innerHouseColor_Button) { 
      game.virtual.ice.inner_color = b.active_color;
      return; 
    }
    
    if (b == skipColor_Button) { 
      game.virtual.skip_broom.broom_color = b.active_color;
      return; 
    }   
    
  }
  
  @Override
  void onSlide(Slider s) {
    
    if (s==vcamFOV_Slider) {
      game.delivery_scene.camera.fovy = PI / vcamFOV_Slider.sliderValue;
      game.delivery_scene.camera.store();
      return;
    }
    
    if (s==vcamDepth_Slider) {
      game.delivery_scene.camera.eyeY = 12 * vcamDepth_Slider.sliderValue;
      game.delivery_scene.camera.store();
      return;
    }  
    
  }
  
  float setSimSpeed(String s) {
    if (s == "1x") return 1.0;
    if (s == "2x") return 2.0;
    if (s == "4x") return 4.0;
    if (s == "100x") return 100.0;
    return 1.0;
  }
  
  @Override 
  void display() {
    // take care of operations that need to happen every loop:
    onDraw();
    super.display(); 
  }
  
  @Override
  void drawContent() {
    float low = blocks_to_pixels(2.3);
     pg_current.beginDraw();
     pg_current.stroke(0);
     pg_current.strokeWeight(1);
     
     draw_vertical_line(blocks_to_pixels(1.0),0,low);
     draw_vertical_line(blocks_to_pixels(2.0),0,low);
     draw_vertical_line(blocks_to_pixels(3.0),0,low);
     draw_vertical_line(blocks_to_pixels(4.0),0,low);
     draw_horizontal_line(low);
     
     //// text labels:
     pg_current.fill(0);
     pg_current.textAlign(CENTER,CENTER);
     pg_current.textSize(settings.standard_text_height);
     pg_current.text("game:",blocks_to_pixels(0.5),blocks_to_pixels(0.35));
     pg_current.text("team 1:",blocks_to_pixels(1.5),blocks_to_pixels(0.35));
     pg_current.text("team 2:",blocks_to_pixels(2.5),blocks_to_pixels(0.35));
     pg_current.text("ice:",blocks_to_pixels(3.5),blocks_to_pixels(0.35));
     pg_current.text("colors:",blocks_to_pixels(4.5),blocks_to_pixels(0.35));
     
     pg_current.text("skill set:",blocks_to_pixels(1.5),blocks_to_pixels(1.25));
     pg_current.text("skill set:",blocks_to_pixels(2.5),blocks_to_pixels(1.25));
     pg_current.text("broom:",blocks_to_pixels(3.5),blocks_to_pixels(1.75));
     pg_current.text("virtual camera:",blocks_to_pixels(4.5),blocks_to_pixels(1.25));
     
     pg_current.endDraw();
  }
  
}
