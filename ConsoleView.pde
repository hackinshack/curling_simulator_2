class ConsoleView extends View {
  
  private int text_size;
  int x_indent = 10;
  private int line_spacing;
  
  // scroll parameters:
  private int max_view_lines;
  private int start_index;
  private int end_index;
  private float delta_scroll;
  private float scroll_pixels;

  int max_buffer_size = 150;

  ArrayList<String> lines = new ArrayList<String>();
  
  ConsoleView(float percent_oX, float percent_oY, float blocks_wide, float blocks_high, boolean threeD, String viewTitle) {
    super(percent_oX, percent_oY, blocks_wide, blocks_high, threeD, viewTitle);

    setTextSize(settings.standard_console_text_height);
    max_view_lines = int((pg_current.height - settings.standard_topbar_height)/line_spacing);
    delta_scroll = 0;
    scroll_pixels = 0;
    settings.background_color = color(0); 
  }
  
  ConsoleView() {
  }
  
  @Override
  void drawContent() {
    
    update_scroll();
    
    pg_current.beginDraw();
    pg_current.textSize(text_size);
    pg_current.fill(255); // white lettering
    pg_current.textAlign(LEFT,TOP);

    float y_location = settings.standard_topbar_height;
    
    for (int i=start_index; i<=end_index; i++) {
      pg_current.text(lines.get(i), x_indent, y_location);
      y_location += line_spacing;
    }
    
    pg_current.endDraw(); 
    
  }
  
  void addLine(String l) {
    if (lines.size() >= max_buffer_size) lines.remove(0);
    lines.add(l);
    scroll_pixels = 0;
  }
  
  void clearAll() {
    lines.clear();
  }
  
  void setTextSize(int ts) {
    text_size = ts;
    line_spacing = (int)(text_size * 1.3);
  }
  
  void update_scroll() {
    int n_lines = lines.size();
    
    // view can fit all lines in buffer:
    if (max_view_lines > n_lines) {
       start_index = 0;
       end_index = n_lines-1;
       scroll_pixels = 0;
       return;
    }
    
    // end_index must be < n_lines
    // start_index must be >= 0;

    scroll_pixels += delta_scroll;
    int scroll_lines = int(scroll_pixels / line_spacing);
    
    end_index = n_lines - 1 + scroll_lines;
    if (end_index > n_lines-1 || end_index < max_view_lines-1) {
       scroll_pixels -= delta_scroll;
    }
    end_index = constrain(end_index,max_view_lines-1,n_lines-1);
    start_index = end_index - max_view_lines + 1;
    
    delta_scroll = 0;
  }
  
// ************** mouse function overrides: ********************
 
  @Override
  void mseWheel(float e) {
    if (hasFocus) {
      delta_scroll = wheel_factor*e;
    }
  }
  
 
}
