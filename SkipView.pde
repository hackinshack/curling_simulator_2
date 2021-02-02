class SkipView extends View {
   
   PGraphics view_image;
   PVector image_origin;
   float image_margin = 0.05; 
  
   SkipView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
      super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle); 

      float image_width = (int)((1-2*image_margin)*expanded_width);
      float image_height = (int)((1-2*image_margin)*expanded_height - settings.standard_topbar_height);
      
      view_image = createGraphics((int)image_width, (int)image_height,P3D);
      image_origin = new PVector(image_margin*expanded_width, image_margin*expanded_height + settings.standard_topbar_height);
      
      isVisible = false;
      isExpanded = true;
      
    }
    
   void open() { 
     isExpanded = false;
     maximize();
     view_controller.placeOnTop(this);
   }
   
   void shut() {
     isExpanded = true;
     minimize();
   }
  
  @Override
  void display() {
    if (!isExpanded) isVisible = false;
    super.display();
  }
  
  @Override 
  void drawContent() {   
    view_image.beginDraw();
    view_image.background(color(0));
    
    boolean simMode = false;
    if (mode==simulate_mode) simMode = true;
    game.skip_scene.renderToExternalBuffer(view_image, simMode); 
    view_image.endDraw();
    
    pg_current.beginDraw();
    pg_current.image(view_image,(int)image_origin.x, (int)image_origin.y);
    pg_current.endDraw();
  }
}
