class PracticeView extends View {

  House2D house;
  
  Button random_Button;
  Button clear_Button;
  
  Slider inPlay_Slider;
  Slider inHouse_Slider;

  Button play_Button;
  
  Draggable[] team1_circles;
  Draggable[] team2_circles;
  
  PracticeView(float percent_oX, float percent_oY, float blocks_wide, float blocks_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, blocks_wide, blocks_high, threeD, viewTitle);
    
    team1_circles = new Draggable[8];
    team2_circles = new Draggable[8];
    
    construct();
  }
  
  void construct() {
    float house_x_blocks = 2.2;  // use a variable here to initialize so we know where we put it later
    house = new House2D(this,house_x_blocks,1.3,0.7,-8.0,21.0);
    house.showHacks = false;
    
    random_Button = new Button(this, 0.65, 0.5, "random");
    clear_Button = new Button(this, 0.65, 0.7, "clear");
    random_Button.buttonWidth = (int)blocks_to_pixels(1.1);
    clear_Button.buttonWidth = (int)blocks_to_pixels(1.1);
    
    inPlay_Slider = new Slider(this,0.65,2.0,"in play %: ");
    inHouse_Slider = new Slider(this,0.65,2.4,"in house %: ");
    
    inPlay_Slider.sliderWidth = (int)blocks_to_pixels(1.1);
    inPlay_Slider.setDimensions();
    inHouse_Slider.sliderWidth = (int)blocks_to_pixels(1.1);
    inHouse_Slider.setDimensions();
    
    inPlay_Slider.sliderValue = 30;
    inPlay_Slider.updateSliderPixel();

    play_Button = new Button(this, 0.65, 3.65, "Set");
    play_Button.buttonWidth = (int)blocks_to_pixels(1.1);
    
    float circle_pix = 9./12.*house.pixels_per_ft; // reduce size to look right when outlined
    float x_pix = house.ice_min_pix.x + circle_pix;
    float y_pix = house.ice_min_pix.y + circle_pix;
    
    float x_blocks = x_pix / blocks_to_pixels(1.0);
    float y_blocks = y_pix / blocks_to_pixels(1.0);
    float circle_blocks = circle_pix / blocks_to_pixels(1.0);
    float spacing = 1.25*circle_blocks;

    for (int i = 0; i < 8; i++) {
      team1_circles[i] = new Draggable(this, x_blocks + i*spacing, y_blocks, circle_blocks, circle_blocks);
      team2_circles[i] = new Draggable(this, house_x_blocks + (i+1)*spacing, y_blocks, circle_blocks, circle_blocks);
      team1_circles[i].set_constraints(house.ice_min_pix.x, house.ice_min_pix.y, house.ice_max_pix.x, house.ice_max_pix.y);
      team2_circles[i].set_constraints(house.ice_min_pix.x, house.ice_min_pix.y, house.ice_max_pix.x, house.ice_max_pix.y);
      team1_circles[i].team1 = true;
      team2_circles[i].team1 = false;
    }    
    
    // can't drag or see the first stone from team1 because that is the stone we will play:
    team1_circles[0].isClickable = false;
    team1_circles[0].isVisible = false;
  }
  
  void reset_draggables() {
    for (Draggable d : team1_circles) d.reset_position();
    for (Draggable d : team2_circles) d.reset_position();
  }
  
  void set_random_draggables() {
    float inPlay = inPlay_Slider.sliderValue;
    float inHouse = inHouse_Slider.sliderValue;
    
    // team1 starts with 1 because 0 is that stone that will be played
    for (int i = 1; i < 8; i++) {
       // team1:
      if (random(0,100) < inPlay) {
        if (random(0,100) < inHouse) team1_circles[i].origin = house.virtual_ice_to_pixels(random_inside());
        else team1_circles[i].origin = house.virtual_ice_to_pixels(random_outside());
      } 
    }
    
    for (int i = 0; i < 8; i++) {
      // team2:
      if (random(0,100) < inPlay) {
        if (random(0,100) < inHouse) team2_circles[i].origin = house.virtual_ice_to_pixels(random_inside());
        else team2_circles[i].origin = house.virtual_ice_to_pixels(random_outside());
      } 
    }   
    
    remove_overlapping();
  }
  
  PVector random_inside() {
    float radius = random(0,6.5);
    float angle = random(0,2*PI);
    float x = radius*cos(angle);
    float y = radius*sin(angle);
    return new PVector(x,y,random(0,2*PI));
  }
  
  PVector random_outside() {
    PVector p = new PVector(random(-6.5,6.5),0,random(0,2*PI));    
    while (p.mag() <= 6.5) {
      p.y = random(-21,0);
    }    
    return p;
  }
  
  void remove_overlapping() {
    float circle_pix = 9./12.*house.pixels_per_ft;
    Draggable[] d = new Draggable[16];
    
    for (int i=0; i<8; i++) {
      d[i] = team1_circles[i];
      d[i+8] = team2_circles[i];
    }
    
    for (int j=0; j<16; j++) {
      for (int k=0; k<16; k++) {
        if (j==k) continue;
        if (d[j].origin.dist(d[k].origin) <= circle_pix) d[j].reset_position();
      }
    }
  }
  
  void set_virtual_stones() {

    // team 1 starts with stone 1 because 0 will ne played:
    for (int i = 1; i < 8; i++) {
      PVector p = house.pixels_to_virtual_ice(team1_circles[i].origin);
      p.z = game.team1.stones[i].pos.z;
      game.team1.stones[i].set_position(p.x,p.y,p.z);
      if (p.y > 6.5) game.team1.stones[i].isActive = false;
    }   
    
    for (int i = 0; i < 8; i++) {
      PVector p = house.pixels_to_virtual_ice(team2_circles[i].origin);
      p.z = game.team2.stones[i].pos.z;
      game.team2.stones[i].set_position(p.x,p.y,p.z);
      if (p.y > 6.5) game.team2.stones[i].isActive = false;
    }   
    

  }

  // **********implement listener interface functions: *********************
  
  @Override
  void onClick(Button b) {

    if (b==play_Button) {
      
      remove_overlapping();
      set_virtual_stones();
      minimize();
      isVisible = false;
      return;
    }
    
    if (b==random_Button) {
      game.clear_stones();
      reset_draggables();
      set_random_draggables();
      remove_overlapping();
      set_virtual_stones();
      return;
    }
    
    if (b==clear_Button) {
      game.clear_stones();
      reset_draggables();
      set_virtual_stones();
      return;
    }
  
  }

  @Override
  void onUpdate(Input i) {
    
  }
  
  @Override
  void onSlide(Slider s) {

  }
  
  @Override
  void onDrag(Draggable d) {
    // could figure out which dragger corresponds to which virtual stone and only update that one,
    // but choosing the lazy option here and just setting them all whenever one is moved.

    remove_overlapping();
    set_virtual_stones();
  }
 
  @Override
  void drawContent() {
    
    house.display();

    // draw draggables:
    for (int i = 0; i < 8; i++) {
      team1_circles[i].display();
      team2_circles[i].display();
      
    } 
  }
}
