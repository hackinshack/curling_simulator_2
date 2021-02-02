// ********************************************************
// DetectView Class 
// ********************************************************

class DetectView extends View {
  
  float pixels_per_inch;  // pixels in detect_view per inch of detection zone
  PVector fieldSize;
  PVector stone_position;
  float stone_dia_pixels;
  float detectRate=0;
  Boolean noStone=true;
  float textSpacer = settings.standard_text_height * 0.156;
  
  DetectView(float percent_oX, float percent_oY, float percent_wide, float percent_high, boolean threeD, String viewTitle) {
      super(percent_oX, percent_oY, percent_wide, percent_high, threeD, viewTitle);
    
    fieldSize = new PVector(0,0);
    stone_position = new PVector(-1000,-1000);
    setScale();
  }
  
  void setScale() {
    float xscale = expanded_width / game.real.dzone.zoneWidth;
    float yscale = (expanded_height-settings.standard_topbar_height-textSpacer) / game.real.dzone.zoneDepth;
    
    pixels_per_inch = 0.9*min(xscale,yscale); // somewhat arbitrary choice, just make the field fit in window.
    fieldSize.x = game.real.dzone.zoneWidth * pixels_per_inch;
    fieldSize.y = game.real.dzone.zoneDepth * pixels_per_inch;
    
    stone_dia_pixels = game.real.stone.diameter*pixels_per_inch;
  }
  
  void setStonePosition(PVector pos) {
    if (pos == null) {
      noStone = true;
      stone_position.set(NO_STONE,NO_STONE,NO_STONE);
      return;
    }
    
    noStone = false;
    stone_position.x = pos.x;
    stone_position.y = pos.y;
    stone_position.z = pos.z;
  }
  
  int getDetectRate() {
   if (noStone) return 0;
   if (frameCount % 100 == 0) detectRate = game.real.time.effectiveFrameRate();
   return (int)detectRate;
  }
  
  // ****************** display ******************
  @Override 
  void display() {
    super.display();
  }
  
  @Override
  void drawContent() {
    
    setScale(); // update scale in case real.dzone size has changed; could be done more computationally efficient, but small cost.
    
    float xs, ys, zs, vo;
   
    xs = (int)(100*stone_position.x)/100.0; // 2 digits after decimal
    ys = (int)(100*stone_position.y)/100.0;
    zs = (int)(100*stone_position.z)/100.0;
    vo = (int)(100*game.real.dzone.exitVelocity.y)/100.0;
    
    pg_current.beginDraw(); 
    
    // text:
    float text_size = settings.standard_block_size * 0.075;
    float text_spacer = settings.standard_block_size * 0.093;
    
    pg_current.textSize(text_size);
    pg_current.fill(0);

    String rate = "frame rate: " + getDetectRate();
    String stonePos = "stone position: ";
    
    if (noStone) {
      stonePos = stonePos + "no stone"; 
    }
    else {
      stonePos = stonePos + xs + ", " + ys + ", " + zs;
    }
    
    pg_current.push();
    pg_current.fill(255);
    pg_current.noStroke();
    
    // draw the detection zone:
    pg_current.rectMode(CENTER);
    pg_current.translate(pg_current.width/2,(pg_current.height + settings.standard_topbar_height + textSpacer)/2);
    pg_current.rect(0,0,fieldSize.x,fieldSize.y);
    
    pg_current.stroke(0);
    pg_current.strokeWeight(1);
    pg_current.line(-fieldSize.x/2,0,fieldSize.x/2,0);
    pg_current.line(0,-fieldSize.y/2,0,fieldSize.y/2);
    
    // draw the stone:
    if (game.real.dzone.detectOn) {
      drawHistory();
      drawRock(stone_position,false);
      drawArrow(stone_position,false);
      drawTargetLine();
      drawDeliveryLine();
    }
    
    // draw the text:
    pg_current.pop();
    pg_current.text(stonePos,5,1.2*settings.standard_topbar_height);
    pg_current.text(rate,5,1.2*settings.standard_topbar_height + text_spacer);
    pg_current.text("exit velocity: " + vo,5,1.2*settings.standard_topbar_height + 2*text_spacer);
    
    pg_current.endDraw();
  
  }
  
  void drawFieldToExternal(PGraphics pg, float xpix, float ypix) {
    
    pg.beginDraw();
    pg.push();
    pg.fill(255);
    pg.stroke(0);
    
    // draw the detection zone:
    pg.rectMode(CENTER);
    pg.translate(xpix,ypix);
    pg.rect(0,0,fieldSize.x,fieldSize.y);
    
    pg.pop();
    pg.endDraw();
    
  }
  
  void drawRock(PVector p, Boolean shadow) {
    float px = p.x*pixels_per_inch;
    float py = -p.y*pixels_per_inch; // flip y-direction due to graphics y-axis increasing downward
    float pz = p.z;
    color c1 = game.real.stone.color1;
    color c2 = game.real.stone.color2;
    float alpha = 30;
    
    pg_current.stroke(0);
    
    if (shadow) {
      c1 = color(red(c1),green(c1),blue(c1),alpha);
      c2 = color(red(c2),green(c2),blue(c2),alpha);
      pg_current.stroke(0,0,0,alpha);
    }
    
    pg_current.fill(c1);
    pg_current.arc(px,py,stone_dia_pixels,stone_dia_pixels,pz,pz+PI,OPEN);
    pg_current.fill(c2);
    pg_current.arc(px,py,stone_dia_pixels,stone_dia_pixels,pz+PI,pz+2*PI,OPEN);
  }
  
  void drawArrow(PVector p, Boolean shadow) {
    float r = 0.75 * stone_dia_pixels;
    float px = p.x*pixels_per_inch;
    float py = -p.y*pixels_per_inch; // flip y-direction due to graphics y-axis increasing downward
    float pz = p.z;
    float alpha = 30;
    
    pg_current.fill(0);
    pg_current.stroke(0);
      
    if (shadow) {
      pg_current.fill(0,0,0,alpha);
      pg_current.stroke(0,0,0,alpha);
    }
    
    // draw line to indicate orientation (could change to arrow later if desired)
    //PVector arrowTip = new PVector(px + r*cos(pz),py + r*sin(pz));
    PVector arrowTip = new PVector(PI + px + r*cos(pz),PI + py + r*sin(pz));

    pg_current.strokeWeight(2);
    pg_current.line(px,py,arrowTip.x,arrowTip.y);
    
    // put a small black dot on both ends of orientation line:
    //pg_current.fill(0);
    pg_current.ellipse(px,py,3,3);
    pg_current.ellipse(arrowTip.x,arrowTip.y,3,3);
  }
  
  void drawHistory() {
    
    for (State s : game.real.stone.stateHistory) {
      PVector p = new PVector(s.x,s.y,s.theta);
      drawRock(p,true);
      drawArrow(p,true);
    } 
  }
  
  void drawTargetLine() {
    
    float invSlope = game.real.screen.target_x_PU / (game.real.screen.depth_offset + game.real.dzone.zoneDepth + game.real.dzone.hackDepth); 
    float x1 = game.real.screen.target_x_PU - invSlope * game.real.screen.depth_offset;
    float x2 = x1 - invSlope * game.real.dzone.zoneDepth;
    
    float x1_pix = x1 * pixels_per_inch;
    float x2_pix = x2 * pixels_per_inch;
    
    pg_current.stroke(255,0,0,120);
    pg_current.strokeWeight(1);
    pg_current.line(x1_pix,-fieldSize.y/2,x2_pix,fieldSize.y/2);
    
  }
  
  void drawDeliveryLine() {
    // this goes a round-about way to get back to the delivery line by backing out from the virtual stone values
    // could just use exit position and velocity, or even go back to the best-fit line itself.
    // in fact, plotting the line based on exit conditions may be a great check.
    
    float invSlope = game.virtual.stone.v0_PU.x / game.virtual.stone.v0_PU.y;  
    float x1 = game.virtual.stone.p0_PU.x - invSlope * game.real.screen.depth_offset;
    
    float x2 = x1 - invSlope * game.real.dzone.zoneDepth;
    float x1_pix = x1 * pixels_per_inch;
    float x2_pix = x2 * pixels_per_inch;
    
    pg_current.stroke(0,255,0,120);
    pg_current.strokeWeight(1);
    pg_current.line(x1_pix,-fieldSize.y/2,x2_pix,fieldSize.y/2);
  }
  
}
