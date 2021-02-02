class ControlPanel extends View {
    
  ButtonOnOff sound_Button;
  ButtonOnOff pan_Button;
  
  Button replay_Button;
  Button newGame_Button;
  
  CategoriedSlider simSpeed_Slider;
  String[] simSpeed_categories = {"1x","2x","4x","100x"};
  
  ControlPanel(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);

    construct();
    isResizable = false;

  }
  void construct() {    
    
    sound_Button = new ButtonOnOff(this, 0.5, 0.4, "sound");
    pan_Button = new ButtonOnOff(this, 0.5, 0.6, "dynamic pan");
    
    simSpeed_Slider = new CategoriedSlider(this, 0.5, 1.0, "> speed:",simSpeed_categories);
    simSpeed_Slider.setDimensions();
    simSpeed_Slider.setValue(0);
    
    replay_Button = new Button(this, 0.5, 1.5, "replay shot");
    newGame_Button = new Button(this, 0.5, 1.7, "new game");
    
    sound_Button.buttonValue = true;
    pan_Button.buttonValue = true;
    game.soundOn = true;
    game.panOn = true;
    
  }
  
  void relocateToMinOrigin() {
    origin = minimized_origin.copy();
    expanded_origin = minimized_origin.copy();
  }
 
 // **********implement listener interface functions: *********************
  
  @Override
  void onClick(Button b) {
    
    if (b==newGame_Button) {
      mode_controller.transfer_control(setup_mode);
      return;
    }
    
    if (b==replay_Button) {
            
      if (mode != play_mode) return;
      if (game.type == PRACTICE) return;
      
      // we got here from play mode, so we've already switched teams, stored positions, and incremented player, relative to the stone we want to replay
      // in addition, virtual.stone points to next player from other team
      // so we must unwind: decrement current player, switch teams back, reset positions to previous, point virtual.stone.
      // update call_view display
      
      game.team.currentStone--;
      game.switch_teams();
      for (VirtualStone s : game.team1.stones) s.unwind_position(1);
      for (VirtualStone s : game.team2.stones) s.unwind_position(1);
      
      game.virtual.stone = game.team.stones[game.team.currentStone];
      game.virtual.stone.reset();
      
      call_view.set_playerUp();
      minimize();
      
      return; 

    }
    
    game.soundOn = sound_Button.buttonValue;
    game.panOn = pan_Button.buttonValue;
    
  }
  
  @Override
  void onUpdate(Input i) {
    
  }
  
  @Override
  void onSlide(Slider s) {
     game.simSpeedFactor = setSimSpeed(simSpeed_Slider.sliderCategory);
  }
  
  // these categories must tie to simSpeed_Slider manually -- find a more elegant way.
  float setSimSpeed(String s) {
    if (s == "1x") return 1.0;
    if (s == "2x") return 2.0;
    if (s == "4x") return 4.0;
    if (s == "100x") return 100.0;
    return 1.0;
  }
  
    // ****************** display ******************
  @Override 
  void drawContent() {
    pg_current.beginDraw();
    pg_current.fill(0);
    pg_current.strokeWeight(1);
    pg_current.textAlign(LEFT,CENTER);
    pg_current.textSize(settings.standard_text_height);
    draw_horizontal_line(blocks_to_pixels(1.3));
    pg_current.endDraw();
    
  }
  
}
