// ********************************
// House2D class
// ********************************

class House2D {
  
  PVector origin;
  float iceWidth_pix, iceHeight_pix;
  float rad12, rad8, rad4, radButton;
  float pixels_per_ft = 1.0;
  float stone_diameter;
  float min_ft_y, max_ft_y;
  
  PVector ice_min_pix, ice_max_pix;
  PVector top_left_blocks;

  float hack_x, hack_y, hack_width, hack_height, hack_spacing;
  
  boolean showIce = true;
  boolean showHacks = false;
  boolean showStones = false;
  boolean inHouseOnly = true;
  boolean showStoneRank = true;
  
  color score_color;
  color delivered_color = color(100,240,30,150);
  color target_color = color(180,180,180,150);
  
  Stone2D[] stones;
  View parent_view;
  
  House2D(View parent, float xblocks, float yblocks, float radius_blocks, float minYft, float maxYft) {
    // house is defined by specifying the location of the button in terms of blocks from upper left corner of parent view
    // and the radius of the house in blocks of parent view.  So we do a lot of backtracking to figure out all the other dimensions
    
    // this is so f-ed up -- minYft is above the house with negative implying further from delivery hack; 
    // maxYft is nearer the delivery hack, with positive implying closer to delivery hack
    // functions all written to make this bastardized system work; to change would requuire hours of coordinate system rework.  stupid.
    
    parent_view = parent;
    top_left_blocks = new PVector(xblocks, yblocks);
    min_ft_y = minYft;
    max_ft_y = maxYft;
    
    // location of button center in pixels:
    float xpix = parent_view.blocks_to_pixels(xblocks);
    float ypix = parent_view.blocks_to_pixels(yblocks);
    origin = new PVector(xpix,ypix);
    
    if (minYft == maxYft) showIce = false;

    rad12 =  parent_view.blocks_to_pixels(radius_blocks);
    pixels_per_ft = rad12 / 6;
    stone_diameter = 9./12.* pixels_per_ft;
    
    // house radii in pixels:
    rad8 = 4 * pixels_per_ft;
    rad4 = 2 * pixels_per_ft;
    radButton = 0.5 * pixels_per_ft;
    
    // ice boundaries (top left and bottom right) in pixels:
    // ice_min_pix = top left; ice_max_pix = bottom right
    ice_min_pix = new PVector(origin.x - feet_to_pixels(8.0), origin.y + minYft * pixels_per_ft);
    ice_max_pix = new PVector(origin.x + feet_to_pixels(8.0), origin.y + maxYft * pixels_per_ft);
    
    // defining the hack positions and dimensions in pixels:
    hack_width = 4./12. * pixels_per_ft;
    hack_height = 8./12. * pixels_per_ft;
    hack_x = origin.x - 3./12. * pixels_per_ft - hack_width;
    hack_y = origin.y - 12.*pixels_per_ft - hack_height;
    hack_spacing = 2. * (origin.x - hack_x) - hack_width;
    
    // parameters may be used elsewhere?
    iceWidth_pix = ice_max_pix.x - ice_min_pix.x;
    iceHeight_pix = ice_max_pix.y - ice_min_pix.y;
    
    // create PVector to hold team stone positions:
    stones = new Stone2D[16];
    for (int i = 0; i < 8; i++) {
      stones[i] = new Stone2D(this,game.team1);
      stones[i+8] = new Stone2D(this,game.team2);
    }   
  } 
  
  float feet_to_pixels(float ft) {
    return ft * pixels_per_ft;
  }
  
  float pixels_to_feet(float pix) {
    return pix / pixels_per_ft;
  }
  
  // **** keep in mind, virtual.ice x position is left-handed (opposite house2D pixels)
  // **** also keep in mind, positive y-direction of virtual.ice implies lower pixel value for display
  
  // position in pixels converted to ft relative to far button:
  PVector pixels_to_virtual_ice(PVector house_pix) {
    // distance from far button in feet:
    float x = pixels_to_feet(house_pix.x - origin.x);
    float y = pixels_to_feet(origin.y - house_pix.y);
    return new PVector(x,y);
  }
  
  // position in feet, relative to the far button, converted to pixels for display:
  // here, x (ft) is still positive to right
  PVector virtual_ice_to_pixels(PVector ice_feet) {
    // return position on virtual ice relative to far button:
    float x = origin.x + feet_to_pixels(ice_feet.x);
    float y = origin.y - feet_to_pixels(ice_feet.y);
    return new PVector(x,y);
  }
  
  // virtual.ice position, converted to pixels for display:
  PVector ice_position_to_pixels(PVector pos) {
    float x_rel_house_ft = -pos.x / 12;
    float y_rel_house_ft = (pos.y - game.virtual.ice.farTee) / 12;
    PVector p = new PVector(x_rel_house_ft,y_rel_house_ft);
    return virtual_ice_to_pixels(p);
  }
  
  // pixels for display converted to virtual.ice position:
  PVector pixels_to_ice_position(PVector pix) {
    float x = 12*pixels_to_feet(origin.x - pix.x);
    float y = 12 * (pixels_to_feet(origin.y - pix.y) + game.virtual.ice.farTee);
    return new PVector(x,y);
  }
  
  void upload_stone_positions() { // from team.stones to Stone2D stones
    for (int i = 0; i < 8; i++) {
      
      PVector p1 = game.team1.stones[i].pos.copy();
      PVector p2 = game.team2.stones[i].pos.copy();
      PVector stone1_pos = ice_position_to_pixels(p1);
      PVector stone2_pos = ice_position_to_pixels(p2);
      
      stones[i].set_pos_pix(stone1_pos);
      stones[i+8].set_pos_pix(stone2_pos);
    }   
    
  }
  
  void rank_stones() {
    for (Stone2D s: stones) s.get_rank();
  }
  
  int get_score() {
    int shotrock_index = -1;
    int score = 0;
    int jstart, kstart;
    
    for (int i=0; i<stones.length; i++) {
      if (!stones[i].inHouse) stones[i].rank = 99;
      if (stones[i].rank == 1) shotrock_index = i;
    }
    if (shotrock_index == -1) { // no shot rock
      score_color = color(200);
      return 0;
    }
    
    if (shotrock_index < 8) {
      jstart = 8;
      kstart = 0;
      score_color = game.team1.team_color;
    } 
    else {
      jstart = 0;
      kstart = 8;
      score_color = game.team2.team_color;
    }
    
    float closest_opp = 999;
    for (int j=jstart; j<jstart+8; j++) {
      float d = stones[j].pos_ft.mag();
      if (d < closest_opp) closest_opp = d;
    }
    
    for (int k=kstart; k<kstart+8; k++) {
      float d = stones[k].pos_ft.mag();
      if (d < closest_opp) score++;
    } 
    
    return score;
  }
  
  void display() {
    PGraphics pg = parent_view.pg_current;
    
    pg.beginDraw();
    pg.ellipseMode(RADIUS);
    pg.rectMode(CORNERS);
    pg.stroke(0);
    pg.strokeWeight(1);

    // hog-to-tee solid ice on bottom:
    if (showIce) {
      pg.fill(255);
      pg.rect(ice_min_pix.x,ice_min_pix.y,ice_max_pix.x,ice_max_pix.y);
    }
    
    // blue 12-ft:
    pg.fill(0,0,255);
    pg.ellipse(origin.x,origin.y,rad12,rad12); 
 
    // white:
    pg.fill(255);
    pg.ellipse(origin.x,origin.y,rad8,rad8); 
  
    // red:
    pg.fill(255,0,0);
    pg.ellipse(origin.x,origin.y,rad4,rad4); 
  
    // button:
    pg.fill(255);
    pg.ellipse(origin.x,origin.y,radButton,radButton);
    
    // hog-to-tee translucent ice on top:
    if (showIce) {
      // lines:
      pg.line(origin.x,ice_min_pix.y,origin.x,ice_max_pix.y); // center
      pg.line(ice_min_pix.x,origin.y,ice_max_pix.x,origin.y); // tee
      float backline_y_pix = origin.y - feet_to_pixels(6.0);
      pg.line(ice_min_pix.x,backline_y_pix,ice_max_pix.x,backline_y_pix); // back
      
      pg.strokeWeight(3);
      float hogline_y_pix = origin.y + feet_to_pixels(21.0);
      pg.line(ice_min_pix.x+2,hogline_y_pix,ice_max_pix.x-2,hogline_y_pix); // back
      pg.strokeWeight(1);
    
      pg.fill(255,255,255,200);
      pg.rect(ice_min_pix.x,ice_min_pix.y,ice_max_pix.x,ice_max_pix.y);
      
      if (showHacks) {
      // hacks:
        pg.fill(200); 
        pg.rect(hack_x, hack_y, hack_x+hack_width, hack_y + hack_height);
        pg.rect(hack_x + hack_spacing, hack_y, hack_x + hack_spacing + hack_width, hack_y + hack_height);
      }
    }
    
    pg.endDraw();
  }
  
  void muteHouseIce() {
    PGraphics pg = parent_view.pg_current;
    pg.beginDraw();
    pg.ellipseMode(RADIUS);
    pg.stroke(255);
    pg.fill(255,255,255,200);
    pg.ellipse(origin.x,origin.y,rad12,rad12);
    pg.endDraw();
  }
  
  // this is redundant to some other functions we currently use:
  void displayStones() {
    PGraphics pg = parent_view.pg_current;
    pg.beginDraw();
    pg.ellipseMode(RADIUS);
    pg.stroke(0);
    upload_stone_positions(); 
    rank_stones();
    for (int i = 0; i < 16; i++) stones[i].display();
    pg.endDraw();
  }
  
  void drawTargetLine() {
    PGraphics pg = parent_view.pg_current;
    float y_ft_total = (game.virtual.ice.farTee - game.virtual.ice.nearHack)/12;
    float dx_min, dx_max;
    float inv_slope = game.virtual.skip_broom.target.x / game.virtual.skip_broom.target.y;
 
    dx_min = feet_to_pixels((y_ft_total - min_ft_y) * inv_slope);
    dx_max = feet_to_pixels((y_ft_total - max_ft_y) * inv_slope);

    pg.beginDraw();
    pg.stroke(target_color);
    pg.strokeWeight(1);
    pg.line(origin.x - dx_min, ice_min_pix.y, origin.x - dx_max, ice_max_pix.y);
    pg.endDraw();
  }
  
  void drawDeliveredLine() {
    PGraphics pg = parent_view.pg_current;
    float dy2 = game.virtual.ice.farTee / 12 - max_ft_y - game.virtual.stone.p0.y / 12;
    float dy1 = game.virtual.ice.farTee / 12 - min_ft_y - game.virtual.stone.p0.y / 12;
    float inv_slope = game.virtual.stone.v0.x / game.virtual.stone.v0.y;
    float x1 = game.virtual.stone.p0.x / 12 + dy1 * inv_slope;
    float x2 = game.virtual.stone.p0.x / 12 + dy2 * inv_slope;

    pg.beginDraw();
    pg.stroke(delivered_color);
    pg.strokeWeight(1);
    pg.line(origin.x - feet_to_pixels(x1), ice_min_pix.y, origin.x - feet_to_pixels(x2), ice_max_pix.y);
    pg.endDraw();  
  }
  
  void drawTrajectoryPoints() {
    PGraphics pg = parent_view.pg_current;
    PVector po;
    
    pg.beginDraw();
    pg.noStroke();
    pg.fill(250,0,0,150);
    //pg.stroke(0,0,250);
    for (PVector p : game.virtual.stone.sweptTrack) {
      po = ice_position_to_pixels(p);
      pg.point(po.x,po.y);
      pg.ellipse(po.x,po.y,3,3);
    }
    
    pg.fill(0,0,250,150);
    //pg.stroke(250,0,0);
    for (PVector p : game.virtual.stone.unsweptTrack) {
      po = ice_position_to_pixels(p);
      //pg.point(po.x,po.y);
      pg.ellipse(po.x,po.y,3,3);
    }
    pg.endDraw();
  }
  
   void drawTrajectoryLines() {
    PGraphics pg = parent_view.pg_current;
    PVector p1,p2,po1,po2;
    
    pg.beginDraw();
    pg.strokeWeight(1);
    
    pg.stroke(0,250,250,255);
    for (int i=0; i<game.virtual.stone.unsweptTrack.size()-1; i++) {
      p1 = game.virtual.stone.unsweptTrack.get(i);
      p2  = game.virtual.stone.unsweptTrack.get(i+1);
      po1 = ice_position_to_pixels(p1);
      po2 = ice_position_to_pixels(p2);
      pg.line(po1.x,po1.y,po2.x,po2.y);
    }
    
    pg.stroke(250,250,0,255);
    for (int i=0; i<game.virtual.stone.sweptTrack.size()-1; i++) {
      p1 = game.virtual.stone.sweptTrack.get(i);
      p2  = game.virtual.stone.sweptTrack.get(i+1);
      po1 = ice_position_to_pixels(p1);
      po2 = ice_position_to_pixels(p2);
      pg.line(po1.x,po1.y,po2.x,po2.y);
    }

    pg.endDraw();
  }
  
}

class Stone2D {

  int rank=0;
  float diameter;
  PVector pos_pix;
  PVector pos_ft;
  House2D house;
  color team_color;
  Team team;
  boolean inHouse = false;
  
  Stone2D(House2D parent_house, Team parent_team) {
    house = parent_house;
    team = parent_team;
    pos_pix = new PVector(0,0);
    pos_ft = new PVector(0,0);
    diameter = house.stone_diameter;
  }
  
  // Stone2D(House2D parent_house, int team_number) {
  //  house = parent_house;
  //  team_color = tc;
  //  pos_pix = new PVector(0,0);
  //  pos_ft = new PVector(0,0);
  //  diameter = house.stone_diameter;
  //}
  
  void set_pos_ft(float x, float y) {
    pos_ft.set(x,y);
    
    float xpix = house.origin.x + pos_ft.x * house.pixels_per_ft;
    float ypix = house.origin.y - pos_ft.y * house.pixels_per_ft;
    
    pos_pix.set(xpix,ypix);
  }
  
  void set_pos_pix(float x, float y) {
    pos_pix.set(x,y);
    
    float xft = (pos_pix.x - house.origin.x) / house.pixels_per_ft;
    float yft = -(pos_pix.y - house.origin.y) / house.pixels_per_ft;
    
    pos_ft.set(xft,yft);    
    
  }
  
  void set_pos_ft(PVector p) {
    pos_ft.set(p.x,p.y);
    
    float xpix = house.origin.x + pos_ft.x * house.pixels_per_ft;
    float ypix = house.origin.y - pos_ft.y * house.pixels_per_ft;
    
    pos_pix.set(xpix,ypix);
  }
  
  void set_pos_pix(PVector p) {
    pos_pix.set(p.x,p.y);
    
    float xft = (pos_pix.x - house.origin.x) / house.pixels_per_ft;
    float yft = -(pos_pix.y - house.origin.y) / house.pixels_per_ft;
    
    pos_ft.set(xft,yft);    
    
  }
  
  
  void get_rank() {
    int n_closer = 0;
    
    for (Stone2D s: house.stones) {
      if (pos_ft.mag() > s.pos_ft.mag()) n_closer++;
    }
    
    rank = n_closer + 1; 
  }

  boolean check_in_house() {
    inHouse = false;
    float d = pos_ft.mag();
    float d_in = 6.0 + house.pixels_to_feet(diameter/2.0);
    
    if (d <= d_in) inHouse = true; 
    return inHouse;
  }
  
  void display() {
    if (house.inHouseOnly && !check_in_house()) return;
    
    PGraphics pg = house.parent_view.pg_current;
    
    pg.fill(team.team_color);
    pg.stroke(0);
    pg.ellipseMode(CENTER);
    pg.ellipse(pos_pix.x, pos_pix.y,diameter,diameter);
    if (house.showStoneRank) {
      pg.textAlign(CENTER,CENTER);
      pg.fill(0);
      pg.textSize(1.5*diameter);
      pg.text(rank,pos_pix.x + diameter,pos_pix.y);
    }

  }

}
