class ColorView extends View {

  ArrayList<ColorChangeListener> listeners = new ArrayList<ColorChangeListener>();
    
  Slider redSlider, greenSlider, blueSlider;
  Button changeButton;
  float red_comp=250, green_comp=0, blue_comp=0;
  
  ColorView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    construct();
    isVisible = true;
  }
  
  void construct() {

    redSlider = new Slider(this, 0.5, 0.5, "red:");
    greenSlider = new Slider(this, 0.5, 0.9, "green:");
    blueSlider = new Slider(this, 0.5, 1.3, "blue:");
    
    redSlider.setParameters(0,255,250,0);
    greenSlider.setParameters(0,255,0,0);
    blueSlider.setParameters(0,255,0,0);
    
    changeButton = new Button(this, 0,0,"dummy");
    changeButton.isVisible = false;
   
  }
  
 // *************** listener functions: ****************
  
  public void addListener(ColorChangeListener c) {
     listeners.add(c); 
  }
  
  public void onColorChange() {
    for (ColorChangeListener c : listeners) c.onColorChange(this.changeButton);
  }
  
  void open(Button changer) {
    red_comp = red(changer.active_color);
    green_comp = green(changer.active_color);
    blue_comp = blue(changer.active_color);
    
    redSlider.setValue(red_comp);
    greenSlider.setValue(green_comp);
    blueSlider.setValue(blue_comp);
    
    isVisible = true;
    isExpanded = false;
    maximize();
    view_controller.placeOnTop(this);
    changeButton = changer;
  }
  
  @Override
  void onSlide(Slider s) {
     
    if (s==redSlider) {
      red_comp = s.sliderValue;
      changeButton.active_color = color(red_comp,green_comp,blue_comp);
    }
    
    if (s==greenSlider) {
      green_comp = s.sliderValue;
      changeButton.active_color = color(red_comp,green_comp,blue_comp);
    }
    
    if (s==blueSlider) {
      blue_comp = s.sliderValue;
      changeButton.active_color = color(red_comp,green_comp,blue_comp);
    }    
    
    onColorChange();

  }
  
  @Override
  void display() {
    if (!isExpanded) isVisible = false;
    super.display();
  }
  
  @Override
  void drawContent() {
    
    float o_x = blocks_to_pixels(1.5);
    float o_y = blocks_to_pixels(1.0);
    float boxSize = blocks_to_pixels(0.8);
    
    pg_current.beginDraw();
    pg_current.fill(red_comp,green_comp,blue_comp);
    pg_current.stroke(0);
    pg_current.rectMode(CENTER);
    pg_current.rect(o_x,o_y,boxSize,boxSize);
    pg_current.endDraw();

  }
  
}
