class BroomView extends View {
  
  float boxWidth;
  float boxHeight;
  float box_baseline_y;
  float force_baseline_x, freq_baseline_x, power_baseline_x;
  float force_max=1.0, freq_max=1.0, power_max=1.0;
  float force_y_pix, freq_y_pix, power_y_pix;
  float text_y_pix;
  
  ButtonOnOff sweep_Button;
  Slider sweepLevel_Slider;
  
  BroomView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    construct();
    
    boxWidth = blocks_to_pixels(0.33);
    boxHeight = blocks_to_pixels(1.0);
    
    box_baseline_y = blocks_to_pixels(1.4);
    text_y_pix = blocks_to_pixels(1.6);
    
    force_baseline_x = blocks_to_pixels(0.35);
    freq_baseline_x = blocks_to_pixels(0.75);
    power_baseline_x = blocks_to_pixels(1.15);
  }
  
  void construct() {
    sweep_Button = new ButtonOnOff(this,0.75,1.8,"sweep!");
    sweep_Button.buttonValue = false;
  }
    
  @Override
  void onClick(Button b) {
    if (b == sweep_Button) {
      game.broom.isActive = b.buttonValue;
    }
  }
  
  @Override
  void onSlide(Slider s) {   
  }
  
  @Override
  void drawContent() {
     
     pg_current.beginDraw();
     
     // text labels:
     pg_current.fill(0);
     pg_current.textAlign(CENTER,BOTTOM);
     pg_current.text("force",force_baseline_x,text_y_pix);
     pg_current.text("freq",freq_baseline_x,text_y_pix);
     pg_current.text("power",power_baseline_x,text_y_pix);
     
     // full boxes:
     pg_current.stroke(0);
     pg_current.strokeWeight(1);
     pg_current.fill(255);
     pg_current.rectMode(CORNER);
     pg_current.rect(force_baseline_x-boxWidth/2,box_baseline_y-boxHeight,boxWidth,boxHeight);
     pg_current.rect(freq_baseline_x-boxWidth/2,box_baseline_y-boxHeight,boxWidth,boxHeight);
     pg_current.rect(power_baseline_x-boxWidth/2,box_baseline_y-boxHeight,boxWidth,boxHeight);
     
     // measured boxes:
     force_y_pix = map(game.broom.force,0,100,0,boxHeight); 
     freq_y_pix = map(game.broom.frequency,0,100,0,boxHeight); 
     power_y_pix = map(game.broom.power,0,100,0,boxHeight);
     
     pg_current.fill(255,50,50);
     pg_current.rectMode(CORNER);
     pg_current.rect(force_baseline_x-boxWidth/2,box_baseline_y-force_y_pix,boxWidth,force_y_pix);
     pg_current.rect(freq_baseline_x-boxWidth/2,box_baseline_y-freq_y_pix,boxWidth,freq_y_pix);
     pg_current.rect(power_baseline_x-boxWidth/2,box_baseline_y-power_y_pix,boxWidth,power_y_pix);
     
     pg_current.endDraw();
  }
}
