class ScoreView extends View {

  House2D house;
  Button score_Button;
  
  ScoreView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    construct();
  }
  
  void construct() {
    house = new House2D(this,1.0,1.0,0.6,0,0);
    house.showStones = true;
    
    score_Button = new Button(this,1.0, 1.75, "0");
    score_Button.isClickable = false;
  }
  
  @Override
  void display() {
    int score = house.get_score();
    score_Button.buttonLabel = str(score);
    score_Button.inactive_color = house.score_color;
    super.display();
  }
  
  @Override
  void drawContent() { 
    house.display(); 
    house.muteHouseIce();
    house.displayStones();
  }
}
