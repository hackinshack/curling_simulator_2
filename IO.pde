// ************************************************************
// IO_Controller: container to hold input/output parameters
// ************************************************************

class IO_Controller {
  JSONObject json;
  String loadPath = "";
  String savePath = "data/";
  String file_name = "";
  String type = "";
  
  IO_Controller(String file) {
    file_name = file;
    json = new JSONObject();
    
    loadPath += file_name;
    savePath += file_name;
  }
  
  void setDefaults() {
    
  }
  
  void pullFromJSON() {
    
  }
  
  void pushToJSON() {
    
  }
  
  void pullFromGUI() {
    
  }
  
  void pushToGUI() {
    
  }
  
  void pushToFile() {
    pullFromGUI();
    pushToJSON();
    saveJSONObject(json, savePath); 
  }
  
  void pullFromFile() {
       
     json = loadJSONObject(loadPath);
       
     if (json == null) {
       json = new JSONObject();
       setDefaults();
       pushToGUI();
       return;
     }
     
     pullFromJSON();
     pushToGUI();
  }
  
}

class Calibrations_IO extends IO_Controller {
  
  Calibrations_IO(String file) {
    super(file);
    type = "calibrations";
  }
  
  @Override
  void setDefaults() {
    
     game.real.camera.camera_name = null;
     
     // real.stone:
     game.real.stone.color1 = color(255,0,0);
     game.real.stone.color2 = color(0,0,255);
     
     game.real.stone.diameter = 1.0;
     game.real.stone.color_tolerance = 50.0;
     
     // real.dzone:
     game.real.dzone.zoneWidth = 1.0;
     game.real.dzone.zoneDepth = 1.0;
     game.real.dzone.hackDepth = 0.0;
     game.real.dzone.corner_pixels[FRONT_LEFT].set(UNASSIGNED,UNASSIGNED);
     game.real.dzone.corner_pixels[FRONT_RIGHT].set(UNASSIGNED,UNASSIGNED);
     game.real.dzone.corner_pixels[BACK_RIGHT].set(UNASSIGNED,UNASSIGNED);
     game.real.dzone.corner_pixels[BACK_LEFT].set(UNASSIGNED,UNASSIGNED);
     
     game.real.dzone.isCalibrated();
     
     // real.screen:
     game.real.screen.height_offset = 0.0;
     game.real.screen.depth_offset = 0.0;
     game.real.screen.pixels_per_PU = 100.0;
  }
  
  @Override
  void pullFromJSON() {
    try {

     // real.camera settings:
     game.real.camera.camera_name = json.getString("cam_name");
     
     // real.stone:
     float r, g, b;
     r = json.getFloat("c1_r");
     g = json.getFloat("c1_g");
     b = json.getFloat("c1_b");
     game.real.stone.color1 = color(r,g,b);
     r = json.getFloat("c2_r");
     g = json.getFloat("c2_g");
     b = json.getFloat("c2_b");
     game.real.stone.color2 = color(r,g,b);
     
     game.real.stone.diameter = json.getFloat("stoneDiameter");
     game.real.stone.color_tolerance = json.getFloat("color_tol");
     
     // real.dzone:
     game.real.dzone.zoneWidth = json.getFloat("zoneWidth");
     game.real.dzone.zoneDepth = json.getFloat("zoneDepth");
     game.real.dzone.hackDepth = json.getFloat("hackDepth");
     game.real.dzone.corner_pixels[FRONT_LEFT].set(json.getFloat("FL_x"),json.getFloat("FL_y"));
     game.real.dzone.corner_pixels[FRONT_RIGHT].set(json.getFloat("FR_x"),json.getFloat("FR_y"));
     game.real.dzone.corner_pixels[BACK_RIGHT].set(json.getFloat("BR_x"),json.getFloat("BR_y"));
     game.real.dzone.corner_pixels[BACK_LEFT].set(json.getFloat("BL_x"),json.getFloat("BL_y"));
     
     game.real.dzone.isCalibrated();
     
     // real.screen:
     game.real.screen.height_offset = json.getFloat("screenHeight");
     game.real.screen.depth_offset = json.getFloat("screenDepth");
     game.real.screen.pixels_per_PU = json.getFloat("screenPPU");

   }
   catch (NullPointerException e) {
     println(loadPath + " corrupted or does not exist; using default values.");
     setDefaults();
     return;
   }  
   
  }
  
  @Override
  void pushToJSON() {
      
     // real.camera settings:
     json.setString("cam_name",game.real.camera.camera_name);
     
     // real.stone:
     json.setFloat("c1_r",red(game.real.stone.color1));
     json.setFloat("c1_g",green(game.real.stone.color1));
     json.setFloat("c1_b",blue(game.real.stone.color1));
     
     json.setFloat("c2_r",red(game.real.stone.color2));
     json.setFloat("c2_g",green(game.real.stone.color2));
     json.setFloat("c2_b",blue(game.real.stone.color2));
  
     json.setFloat("stoneDiameter",game.real.stone.diameter);
     json.setFloat("color_tol",game.real.stone.color_tolerance);
     
     // real.dzone:
     json.setFloat("zoneWidth",game.real.dzone.zoneWidth);
     json.setFloat("zoneDepth",game.real.dzone.zoneDepth);
     json.setFloat("hackDepth",game.real.dzone.hackDepth);
     
     json.setFloat("FL_x",game.real.dzone.corner_pixels[FRONT_LEFT].x);
     json.setFloat("FL_y",game.real.dzone.corner_pixels[FRONT_LEFT].y);
     json.setFloat("FR_x",game.real.dzone.corner_pixels[FRONT_RIGHT].x);
     json.setFloat("FR_y",game.real.dzone.corner_pixels[FRONT_RIGHT].y);
     json.setFloat("BR_x",game.real.dzone.corner_pixels[BACK_RIGHT].x);
     json.setFloat("BR_y",game.real.dzone.corner_pixels[BACK_RIGHT].y);
     json.setFloat("BL_x",game.real.dzone.corner_pixels[BACK_LEFT].x);
     json.setFloat("BL_y",game.real.dzone.corner_pixels[BACK_LEFT].y);
     
     // real.screen:
     json.setFloat("screenHeight",game.real.screen.height_offset);
     json.setFloat("screenDepth",game.real.screen.depth_offset);
     json.setFloat("screenPPU",game.real.screen.pixels_per_PU);
  }
  
  @Override
  void pullFromGUI() {
    calibrate_view.pullFromGUI();
  }
  
  @Override
  void pushToGUI() {
    calibrate_view.pushToGUI();
  }
}

// ********************************************

class Settings_IO extends IO_Controller {
  
  Settings_IO(String file) {
    super(file);
    type = "settings";
  }
  
  @Override
  void setDefaults() {
     game.type = STANDARD;     
     game.broom_type = VIRTUAL;
     game.ice_curl = 4.0;
     game.nominal_button_velocity = 75.5;
     game.ice_velocity_range = 20.0;
     game.hammer = false;
     
     game.virtual.ice.setAcceleration(game.ice_curl);

     // team 1:
     game.team1.team_color = color(255,0,0);
     game.team1.player_mode = VIRTUAL;
     game.team1.skill_delivery = 75.0;
     game.team1.skill_sweep = 75.0;
    
     // team 2:
     game.team2.team_color = color(0,0,255);
     game.team2.player_mode = VIRTUAL;
     game.team2.skill_delivery = 75.0;
     game.team2.skill_sweep = 75.0;   
     
     // colors:
     game.virtual.ice.inner_color = color(255,0,0);
     game.virtual.ice.outer_color = color(0,0,255);
     game.virtual.skip_broom.broom_color = color(0,255,255);
     
     // virtual camera:
     game.conversions.scene.camera.fovy = PI / 60.0;
     game.conversions.scene.camera.eyeY = 12 * (-90); 
     game.conversions.get_conversion_factors(); 
     
  }
  
  @Override
  void pullFromJSON() {
      try {
       game.type = json.getInt("game_toggle");     
       game.broom_type = json.getInt("broom_toggle");
       game.ice_curl = json.getFloat("ice_curl");
       game.nominal_button_velocity = json.getFloat("ice_speed");
       game.ice_velocity_range = json.getFloat("ice_range");
       game.hammer = json.getBoolean("hammer");
       
       game.virtual.ice.setAcceleration(game.ice_curl);
  
       float r, g, b;
       
       // team 1:
       r = json.getFloat("c1_r");
       g = json.getFloat("c1_g");
       b = json.getFloat("c1_b");
       game.team1.team_color = color(r,g,b);
  
       game.team1.player_mode = json.getInt("player1_toggle");
       game.team1.skill_delivery = json.getFloat("t1_delivery");
       game.team1.skill_sweep = json.getFloat("t1_sweep");
      
       // team 2:
       r = json.getFloat("c2_r");
       g = json.getFloat("c2_g");
       b = json.getFloat("c2_b");
       game.team2.team_color = color(r,g,b);
       
       game.team2.player_mode = json.getInt("player2_toggle");
       game.team2.skill_delivery = json.getFloat("t2_delivery");
       game.team2.skill_sweep = json.getFloat("t2_sweep");   
       
       // colors:
       r = json.getFloat("in_r");
       g = json.getFloat("in_g");
       b = json.getFloat("in_b");
       game.virtual.ice.inner_color = color(r,g,b);
       
       r = json.getFloat("out_r");
       g = json.getFloat("out_g");
       b = json.getFloat("out_b");
       game.virtual.ice.outer_color = color(r,g,b);
       
       r = json.getFloat("skip_r");
       g = json.getFloat("skip_g");
       b = json.getFloat("skip_b");
       game.virtual.skip_broom.broom_color = color(r,g,b);
       
       // virtual camera:
       game.conversions.scene.camera.fovy = PI / json.getFloat("vcam_fov");
       game.conversions.scene.camera.eyeY = 12 * json.getFloat("vcam_depth"); 
       game.conversions.get_conversion_factors();  

     }
     
     catch (Exception e) {
       println(loadPath + " corrupted or does not exist; using default values.");
       setDefaults();
       return;       
     }
  }
  
  @Override
  void pushToJSON() {
    json.setInt("game_toggle",game.type);
    json.setInt("broom_toggle",game.broom_type);
    json.setFloat("ice_curl",game.ice_curl);
    json.setFloat("ice_speed",game.nominal_button_velocity);
    json.setFloat("ice_range",game.ice_velocity_range);
    json.setBoolean("hammer",game.hammer);

    // team 1:
    json.setFloat("c1_r",red(game.team1.team_color));
    json.setFloat("c1_g",green(game.team1.team_color));
    json.setFloat("c1_b",blue(game.team1.team_color));
    
    json.setInt("player1_toggle",game.team1.player_mode);
    json.setFloat("t1_delivery",game.team1.skill_delivery);
    json.setFloat("t1_sweep",game.team1.skill_sweep);
    
    // team 2:
    json.setFloat("c2_r",red(game.team2.team_color));
    json.setFloat("c2_g",green(game.team2.team_color));
    json.setFloat("c2_b",blue(game.team2.team_color));
    
    json.setInt("player2_toggle",game.team2.player_mode);
    json.setFloat("t2_delivery",game.team2.skill_delivery);
    json.setFloat("t2_sweep",game.team2.skill_sweep);
    
    // colors:
    json.setFloat("in_r", red(game.virtual.ice.inner_color));
    json.setFloat("in_g", green(game.virtual.ice.inner_color));
    json.setFloat("in_b", blue(game.virtual.ice.inner_color));

    json.setFloat("out_r", red(game.virtual.ice.outer_color));
    json.setFloat("out_g", green(game.virtual.ice.outer_color));
    json.setFloat("out_b", blue(game.virtual.ice.outer_color));
    
    json.setFloat("skip_r", red(game.virtual.skip_broom.broom_color));
    json.setFloat("skip_g", green(game.virtual.skip_broom.broom_color));
    json.setFloat("skip_b", blue(game.virtual.skip_broom.broom_color));
    
    // virtual camera:
    json.setFloat("vcam_fov", PI / game.conversions.scene.camera.fovy);
    json.setFloat("vcam_depth", game.conversions.scene.camera.eyeY / 12);
  }
  
  @Override
  void pullFromGUI() {
    settings_view.pullFromGUI();
  }
  
  @Override
  void pushToGUI() {
    settings_view.pushToGUI();
  }
}
