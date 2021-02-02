class StatsView extends View {

  // target, delivered and delta are measured in inches from the button; weight = y, line = x
  // I have no idea why I couldn't have just called them x and y.
  float target_weight;
  float delivered_weight;
  
  float target_line;
  float delivered_line;  
  
  float delta_line;
  float delta_weight;
  
  StatsView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    construct();
  }
  
  void construct() {
    delta_line = 0;
    delta_weight = 0;
  }
  
  void set_targets(float weight, float line) {
    target_weight = weight;
    target_line = line;
  }
  
  void set_delivered(float weight, float line) {
    delivered_weight = weight;
    delivered_line = line;
  }
  
  void compute_deltas() {
    delta_weight = delivered_weight - target_weight;
    delta_line = delivered_line - target_line;
  }
  
  
  @Override
  void drawContent() {
    
    compute_deltas();
 
    color lineColor = color(150);
    color weightColor = color(150);
    
    String plusString_w = " ";
    String plusString_l = " ";
    
    float dw = abs(int(delta_weight*10)/10.0);
    float dl = abs(int(delta_line*10)/10.0);
    
    if (delta_weight < 0) {
      plusString_w = "   light";
      weightColor = color(0,255,0);
    }
    
    if (delta_weight > 0) {
      plusString_w = "   heavy";
      weightColor = color(250,0,0);
    }
    
    if (delta_line > 0) {
      plusString_l = "   <<<";
    }

    if (delta_line < 0) {
      plusString_l = "    >>>";
    }
    
    lineColor = color(0);
           
    // text labels:
    pg_current.beginDraw();
    pg_current.textSize(2*settings.standard_text_height);
    pg_current.textAlign(CENTER,CENTER);
    
    float center_x = blocks_to_pixels(1.0);
    
    pg_current.fill(weightColor);
    pg_current.text(dw + plusString_w,center_x,blocks_to_pixels(0.45));
    
    pg_current.fill(lineColor);
    pg_current.text(dl + plusString_l,center_x,blocks_to_pixels(0.7));

    pg_current.endDraw();
  }
}
