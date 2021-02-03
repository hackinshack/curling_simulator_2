// curling_simulator
// Copyright (c) 2021 Christopher Begley
// MIT License

import curling.*;
import processing.video.*;
import ddf.minim.*;

static final int FRONT_LEFT = 0;
static final int FRONT_RIGHT = 1;
static final int BACK_RIGHT = 2;
static final int BACK_LEFT = 3;
static final int UNASSIGNED = -1;
static final int NO_STONE = -9999;

static final int STANDARD = 0;
static final int DOUBLES = 1;
static final int CRAZY = 2;
static final int PRACTICE = 3;

static final int PHYSICAL = 0;
static final int VIRTUAL = 1;
static final int AI = 2;
static final int BROOM_OFF = 2;

static final int SETTINGS = 0;
static final int PLAY = 1;
static final int CALIBRATE = 2;

// **********game object: ************************
Game game;

// *********** modes:  ************************************************
Mode mode;
CalibrateMode calibrate_mode;
SetupMode setup_mode;
PlayMode play_mode;
AcquireMode acquire_mode;
SimulateMode simulate_mode;

// ******** controllers: **********************************************
ModeController mode_controller;
ViewController view_controller;
Calibrations_IO calibrationsIO;
Settings_IO settingsIO;

// global message board, accessible to all views:
ConsoleView messages;

// ******** views: ****************************************************
ControlPanel control_panel;
CalibrateView calibrate_view;
CameraView camera_view;
DetectView detect_view;
CallView call_view;
SettingsView settings_view;
StatsView stats_view; 
ScoreView score_view;
PracticeView practice_view;
ColorView color_view;
BroomView broom_view;
PopView pop_view;
SkipView skip_view;

// *********** audio ****************:
Minim minim;
AudioPlayer impact;

PImage sketch;
float real_time, delta_time;

void setup() {  
  size(1280,800,P3D);
  // fullScreen(P3D);
  smooth(8);
  
  // prepare audio objects:
  initializeAudio();
    
  // create the console so other objects can post messages at start-up:
  messages = new ConsoleView(0.8,0.0,3,1,false,"messages");

  // initialize game:
  game = new Game(this);
  
  // controllers:  
  mode_controller = new ModeController();
  view_controller = new ViewController(); 
  calibrationsIO = new Calibrations_IO("calibrations.json");
  settingsIO = new Settings_IO("settings.json");
  
  // initialize modes and views:
  createModes();
  createViews();
  
  // load json data:
  calibrationsIO.pullFromFile();
  settingsIO.pullFromFile();
  
  // set initial mode:
  view_controller.minimizeAll();
  control_panel.maximize();
  mode_controller.transfer_control(setup_mode);
  
}

void draw() {
  
  real_time = game.real.time.elapsed();
  delta_time = game.real.time.interval();

  boolean simMode=false;
  if (mode==simulate_mode) simMode = true;
  game.delivery_scene.display(0,0, simMode);
  view_controller.display_views();
  
  mode.perform_tasks();
  mode.check_completion();
  mode.transfer_control();
  
}

// *************** initialization modes and views ************

void createModes() {
  mode = new Mode(); // pointer to current mode
  calibrate_mode = new CalibrateMode();
  setup_mode = new SetupMode();
  play_mode = new PlayMode();
  acquire_mode = new AcquireMode();
  simulate_mode = new SimulateMode();
  
  mode_controller.addMode(calibrate_mode);
  mode_controller.addMode(setup_mode);
  mode_controller.addMode(play_mode);
  mode_controller.addMode(acquire_mode);
  mode_controller.addMode(simulate_mode);
}

void createViews() {
  // color view must be created first so that other views can be listed as listeners:
  color_view = new ColorView(1.0,1.0,2,1.6,false,"color selector");
  
  control_panel = new ControlPanel(0.0,0.0,1.0,1.9,false,"options");
  calibrate_view = new CalibrateView(0.0,0.0,3,3.7,false,"calibration");
  detect_view = new DetectView(1.0,1.0,2,2,false,"detection");
  camera_view = new CameraView(1.0,0.0,3,3,false,"camera");
  settings_view = new SettingsView(0.5,0.0,5.0,2.7,false,"settings");
  call_view = new CallView(0.5,0.0,4,1.3,false,"call");
  score_view = new ScoreView(1.0,0.0,2,2,false,"house");
  stats_view = new StatsView(0.5,0.0,2,1.0,false,"stats");
  practice_view = new PracticeView(0.0,1.0,3.2,4,false,"practice");
  broom_view = new BroomView(1.0,0.0,1.5,2.0,false,"broom");
  skip_view = new SkipView(0.0,1.0,4,3,false,"skip view");
  pop_view = new PopView(1.0,1.0,3,1,false,"");
  
  view_controller.addView(call_view);
  view_controller.addView(score_view);
  view_controller.addView(stats_view);
  view_controller.addView(detect_view);
  view_controller.addView(messages);
  view_controller.addView(calibrate_view);
  view_controller.addView(camera_view);
  view_controller.addView(settings_view);
  view_controller.addView(practice_view);
  view_controller.addView(broom_view);
  view_controller.addView(pop_view);
  view_controller.addView(skip_view);
  
  view_controller.addView(control_panel);
  view_controller.addView(color_view);
  
  messages.isResizable = false;
  calibrate_view.isResizable = false;
  camera_view.isResizable = false;
  detect_view.isResizable = false;
  pop_view.isResizable = false;
  practice_view.isResizable = false;
  broom_view.isResizable = false;
  call_view.isResizable = false;
  score_view.isResizable = false;
  stats_view.isResizable = false;
  settings_view.isResizable = false;
  skip_view.isResizable = false;

  control_panel.isAlwaysOpen = true;
  
  // add things that need to listen to the color changer:
  color_view.addListener(settings_view);
  color_view.addListener(calibrate_view);
  
}
 
// *************** mouse functions **********************

void mouseMoved() {
  for (View v : view_controller.view_stack) {
    v.mseMoved();
  } 
}

void mousePressed() {
  for (View v : view_controller.view_stack) {
    v.msePressed();
  }   
}

void mouseDragged() {
  for (View v : view_controller.view_stack) {
    v.mseDragged();
  }   
}

void mouseReleased() {
  for (View v : view_controller.view_stack) {
    v.mseReleased();
  }    
}

void mouseClicked() {
  for (View v : view_controller.view_stack) {
    v.mseClicked();
  }    
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  for (View v : view_controller.view_stack) {
    v.mseWheel(e);
  }    
}

// ************************ key functions ***************************

void keyPressed() {
  if (view_controller.allFrozen) {
    pop_view.closePopup();
    return;
  }
  
  for (View v : view_controller.view_stack) {
    for (Input i: v.inputs) {
      i.key_pressed(); 
    }
  }  
}

void keyTyped() {
  // toggle skip view:
  if (key == 's') {
    skip_view.isVisible = !skip_view.isVisible;
    if (skip_view.isVisible) skip_view.open();
    else skip_view.shut();
  }
  
  for (View v : view_controller.view_stack) {
    for (Input i: v.inputs) {
      i.key_typed(); 
    }
  }  
}

// ************* audio **********************************************

void initializeAudio() {
  minim = new Minim(this);
  impact = minim.loadFile("impact.mp3"); 
}

// ********************** capture camera events **********************

 void captureEvent(Capture video) { 
   // every time any of the Capture items triggers an event, this happens:
    video.read();
 }
 
 // ***************** listener interfaces *****************************
 
 interface ButtonListener {
   void onClick(Button b);
 }
 
 interface InputListener {
   void onUpdate(Input i);
 }
 
 interface SliderListener {
   void onSlide(Slider s);
 }
 
 interface DraggableListener {
   void onDrag(Draggable d);
 }
 
 interface ColorChangeListener {
   void onColorChange(Button b);
 }
 
 // *************************************************
// color functions
// *************************************************

color random_color() {
  return color((int)random(255),(int)random(255),(int)random(255));
}

color random_color_light() {
  return color((int)random(50,255),(int)random(50,255),(int)random(50,255));
}
