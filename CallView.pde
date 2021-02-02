class CallView extends View implements IceDimensions {

   Slider weight_Slider;
   Slider line_Slider;
   ButtonSwitch handle_Button;
   Button go_Button;
   Button player_Button;
   
   PGraphics view_image;
   PVector image_origin;
   float image_margin = 0.05; 
  
   CallView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
      super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle); 
      construct();
      
      float ratio = (float) height / (float) width;
      float image_width = (int)((1-2*image_margin)*expanded_width);
      float image_height = image_width * ratio;
      view_image = createGraphics((int)image_width, (int)image_height,P3D);
      image_origin = new PVector(image_margin*expanded_width, (1-image_margin)*expanded_height - blocks_to_pixels(0.4)- image_height);
      
    }
  
   void construct() {    
    
    player_Button = new Button(this,3.5, 0.4, "#:"); 
    go_Button = new Button(this,3.5, 0.6, "GO"); 
    handle_Button = new ButtonSwitch(this, 2.5, 0.5, "handle:");
    player_Button.isClickable = false;

    weight_Slider = new Slider(this, 1.0, 0.5, "weight:");
    line_Slider = new Slider(this, 2.0, 1.0, "line:");
    
    weight_Slider.sliderWidth = (int)(1.875*settings.standard_block_size);
    weight_Slider.setDimensions();
    weight_Slider.sliderMinValue = -25;
    weight_Slider.sliderMaxValue = 35;
    weight_Slider.sliderPrecision = 1;
    weight_Slider.roundHalf = true;
    
    line_Slider.sliderWidth = (int)(3.875*settings.standard_block_size);
    line_Slider.setDimensions();
    
    line_Slider.sliderMinValue = -8;
    line_Slider.sliderMaxValue = 8;
    line_Slider.sliderPrecision = 1;
    
    reset();
     
   }
   
   void reset() {
     weight_Slider.sliderValue = 0;
     weight_Slider.updateSliderPixel();
     line_Slider.sliderValue = 0;
     line_Slider.updateSliderPixel();
     game.skip_scene.camera.set_nominal_skip();
     game.virtual.skip_broom.target.z = (handle_Button.buttonValue ? 1 : 0);
   }
   
   void set_playerUp() {        
    player_Button.inactive_color = game.team.team_color;
    player_Button.buttonLabel = str(game.team.currentStone + 1);
    if (game.type == DOUBLES) player_Button.buttonLabel = str(game.team.currentStone - 2);
   }

 // **********implement listener interface functions: *********************
  
  @Override
  void onClick(Button b) {

    if (b==go_Button) {
      play_mode.tasksComplete = true;
      game.virtual.skip_broom.target.z = (handle_Button.buttonValue ? 1 : 0);
      return;
    }  
    
    if (b==handle_Button) {
      game.virtual.skip_broom.target.z = (handle_Button.buttonValue ? 1 : 0);
      return;
    }  
  }
  
  @Override
  void onSlide(Slider s) {
    
    if (s==weight_Slider) {
      game.virtual.skip_broom.target.y = farTee + weight_Slider.sliderValue * 12;
      return;
    }
    
    if (s==line_Slider) {
      //skip_scene.camera.eyeX = line_Slider.sliderValue * 12;
      //skip_scene.camera.centerX = line_Slider.sliderValue * 12;
      
      game.skip_scene.camera.set_x_positions(line_Slider.sliderValue * 12);
      game.virtual.skip_broom.target.x = -line_Slider.sliderValue * 12;
      return;
    }
    
  }
  
}
