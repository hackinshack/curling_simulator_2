class PopView extends View {

  Button okButton;
  String message = "Pop-up message here.";
  
  PopView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    construct();
    isPopup = true;
    isVisible = true;
    isResizable = false;
    settings.background_color = color(255,100,0);
  }
  
  void construct() {
    okButton = new Button(this,1.5,0.75,"OK");
  }
  
  void show_message(String s) {
   message = s; 
   isVisible = true;
   center();
   maximize();
   view_controller.freezeAll();
  }
  
  void closePopup() {
    minimize();
    view_controller.unfreezeAll();
  }
  
  @Override
  void onClick(Button b) {
    minimize();
    view_controller.unfreezeAll();
  }
  
  
  @Override
  void display() {
    if (!isExpanded) isVisible = false;
    super.display();
  }
  
  @Override
  void drawContent() {
    pg_current.beginDraw();
    pg_current.fill(0);
    pg_current.textAlign(CENTER,CENTER);
    pg_current.text(message,blocks_to_pixels(1.5),blocks_to_pixels(0.5));
    pg_current.endDraw();
  }
  
}
