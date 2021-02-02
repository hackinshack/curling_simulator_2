class ModeController {
  
   int index;
   ArrayList<Mode> mode_stack = new ArrayList<Mode>();
   
   ModeController() {
     index = 0;
   }
   
   void addMode(Mode m) {
     m.modeIndex = index;
     mode_stack.add(m);
     index++;
   }
   
   void transfer_control(Mode m) {
     
     mode.lost_control();
     m.got_control();
     mode = m;
   }
   
}

class Mode {

  int modeIndex;
  boolean tasksComplete = false;
  
  Mode() {
    
  }
  
  void got_control() {
  }
  
  void perform_tasks() {
  }
  
  void check_completion() {
  }
  
  void transfer_control() {
  }
  
  void lost_control() {
  }
  
}

// ******************************
//     calibrate mode
// ******************************

class CalibrateMode extends Mode {
  
  boolean simulate;
  PVector accel = new PVector(0,0,0);
  
  CalibrateMode() {
    
  }

  @Override 
  void got_control() {
    
    calibrate_view.reset();
    if (!camera_view.start_camera()) camera_view.createCameraSelector();
     
    game.begin_calibration();
    camera_view.maximize();
    detect_view.maximize();
    calibrate_view.maximize();
    simulate = false;
  }
  
  @Override
  void perform_tasks() {
    
    if (game.real.dzone.detectOn) {
      acquire_mode.perform_tasks();
      
      if (game.real.dzone.acquireOn) {
        if (!game.real.dzone.acquire(real_time)) {
          
          // trigger all the post-processing, for now:
          game.real.stone.performRegression();
          game.real.dzone.computeExitConditions();
          
          PVector p0 = game.real.dzone.projectPositionToScreen();
          PVector v0 = game.real.dzone.projectVelocityToScreen();
          
          game.virtual.stone.setPhysicalICs(p0,v0);
          game.virtual.stone.physicalToVirtualICs();
          
          calibrate_view.acquire_Button.buttonValue = false;
          
          simulate = true;
        }
      }
    }
    
    if (simulate) {  
      game.virtual.stone.showHeading = true;
      game.virtual.stone.move(delta_time,accel);
      if (!game.virtual.stone.isMoving) {
        simulate = false;
        game.virtual.stone.reset();
        game.delivery_scene.camera.reset();
        game.real.dzone.resetAcquire();
      }
    }
    
    game.virtual.stone.displayHeading(game.real.screen.pixels_per_PU);
  }
  
  @Override
  void check_completion() {
    
  }
  
  @Override
  void transfer_control() {

  }
  
  @Override 
  void lost_control() {
    game.virtual.stone.reset();
    game.real.dzone.resetAcquire();
    view_controller.minimizeAll();
  }
  
}

// ******************************
//     setup mode
// ******************************

class SetupMode extends Mode {
  
  SetupMode() {
    
  }
  
  // override functions:
  
  @Override 
  void got_control() {
    settings_view.maximize();
  }  
  
  @Override
  void perform_tasks() {
     
  }
  
  @Override
  void check_completion() {
    
  }
  
  @Override
  void transfer_control() {
    
  }
  
  @Override 
  void lost_control() {
    view_controller.minimizeAll();
  }
  
}

// ******************************
//     play mode: increment player, get line and weight input, 
//      then transfer control to aqcuire_mode
// ******************************

class PlayMode extends Mode {
  
  PlayMode() {
    
  }
  
  // override functions:
  
 @Override 
  void got_control() {
    tasksComplete = false;
    call_view.maximize();
    score_view.maximize();
    game.virtual.skip_broom.reset();
    call_view.reset();
    game.virtual.skip_broom.isActive = true;
    game.delivery_scene.camera.reset();
    
    if (!game.hasStarted) game.begin();
    
    // if we're just practicing, start everything over again
    // team 1 always playing
    if (game.type == PRACTICE) {
      practice_view.maximize();
      game.hammer = true;
      game.begin();
    }

    // store all the stone positions, before we throw the next that might displace some, in case we need to replay or 5-rock violation:
    game.store_stone_positions();
    
    // increment player, unless we're done:
    if (!game.nextPlayer()) game.isOver = true;
    
    call_view.set_playerUp();
 
  }
  
  @Override
  void perform_tasks() {
    
  }
  
  @Override
  void check_completion() {
    
  }
  
  @Override
  void transfer_control() {
    
    if (game.isOver) {
      call_view.player_Button.inactive_color = color(200);
      call_view.player_Button.buttonLabel = "game over";
      return;
    }
    
    if (tasksComplete) {
      
      if (game.virtual.stone.parent_team.player_mode == VIRTUAL) {
        PVector delivery = game.virtual.stone.getVirtualICs();
        
        stats_view.set_targets(delivery.z,game.virtual.skip_broom.target.x);
        stats_view.set_delivered(delivery.x,delivery.y);
    
        mode_controller.transfer_control(simulate_mode);
      }
      else mode_controller.transfer_control(acquire_mode);
    }
  }
  
  @Override 
  void lost_control() {
    view_controller.minimizeAll();
  }
  
}
  

// ******************************
//     acquire mode -- get initial conditions for stone, then transfer control to simulate_mode
// ******************************

class AcquireMode extends Mode {
  
  AcquireMode() {
    
  }
  
  // override functions: 
  @Override
  void got_control() {
     
    // check if camera is defined -- if not, go to calibration mode
    // first load of pixels seems to mess up
    
    if (!game.real.camera.isRunning) {
      println("camera not running");
      return;
    }
    
    if (!game.real.camera.isWarm) game.real.camera.warm_up();

    tasksComplete = false; 
    game.real.dzone.resetAcquire();
    //detect_view.maximize(); // uncomment to check on detection system upon delivery
  }
  
  @Override
  void perform_tasks() {    
    game.real.camera.cam_image.loadPixels();
    PVector p = game.real.dzone.get_stone_state(game.real.camera.cam_image);  
    detect_view.setStonePosition(p);
  }
  
  @Override
  void check_completion() {
    tasksComplete = !game.real.dzone.acquire(real_time);
  }
  
  @Override
  void transfer_control() {
    if (!tasksComplete) return;
    
    game.real.stone.performRegression();
    game.real.dzone.computeExitConditions();
    
    PVector p0 = game.real.dzone.projectPositionToScreen();
    PVector v0 = game.real.dzone.projectVelocityToScreen();
    
    game.virtual.stone.setPhysicalICs(p0,v0);
    PVector delivery = game.virtual.stone.physicalToVirtualICs();
    
    float weight_call = game.virtual.skip_broom.target.y - IceDimensions.farTee;
    stats_view.set_targets(weight_call,game.virtual.skip_broom.target.x);
    stats_view.set_delivered(delivery.x,delivery.y);
    
    mode_controller.transfer_control(simulate_mode);
 
  }
  
  @Override 
  void lost_control() {
    view_controller.minimizeAll();
  }
 
}

// ******************************
//     simulate mode
// ******************************

class SimulateMode extends Mode {
  
  
  SimulateMode() {
    
  }
  
  // override functions:
  
  @Override 
  void got_control() {
     
    tasksComplete = false;
    //if (virtual.stone.parent_team.player_mode != VIRTUAL) detect_view.maximize(); // uncomment to see detection path
    broom_view.maximize();
    stats_view.maximize();   
    broom_view.sweep_Button.buttonValue = false;
    game.broom.isActive = false;
  }
  
  @Override
  void perform_tasks() {
    game.broom.update();
    for (int i=0; i<game.simSpeedFactor; i++) updateStonePositions();
  }
  
  @Override
  void check_completion() {
    tasksComplete = noStoneMoving();
  }
   
  @Override
  void transfer_control() {
    if (!tasksComplete) return; 
    
    // check for free guard violation:
    if (game.check_freeGuardVioliation()) { 
      for (VirtualStone s : game.team1.stones) s.unwind_position(0);
      for (VirtualStone s : game.team2.stones) s.unwind_position(0); 
      
      game.virtual.stone = game.team.stones[game.team.currentStone];
      game.virtual.stone.reset();
      
      call_view.set_playerUp();
      pop_view.show_message("Free guard zone violation");
    }
    
    game.switch_teams();
    mode_controller.transfer_control(play_mode);
    
    // implement a pause here to allow user to see what happened:
    delay(5000);
    
    game.skip_scene.camera.reset();
  }
  
  @Override 
  void lost_control() {
    view_controller.minimizeAll();
  }
  
  boolean noStoneMoving() { 
    // if any stone still moving, return false
    
    for (VirtualStone s : game.team1.stones) {
      if (s.isMoving) return false;
    } 
    
    for (VirtualStone s : game.team2.stones) {
      if (s.isMoving) return false;
    } 
    
    return true;
  }
  
  void updateStonePositions() { 
    
    VirtualStone[] stones = foldStones();
    
    for (VirtualStone s : stones) {
      if (s.isActive) {
        s.move(delta_time,game.virtual.ice.acceleration);
        s.moveUnswept(delta_time,game.virtual.ice.acceleration);
          
         // handle contact:
         for (VirtualStone r: stones) {
           if (r.isActive) {
             if (s.bounce(r, game.soundOn)) {
               impact.play();
               impact.rewind();
             }
           }
         }
       }
       s.inBounds();
    } 
  }

  VirtualStone[] foldStones() {
    VirtualStone[] s = new VirtualStone[16];
    for (int i=0; i<8; i++) {
      s[i] = game.team1.stones[i];
      s[i+8] = game.team2.stones[i];
    }
    return s;
  }
  
}
