class Board
{
  int left = 50;
  int right = 950;
  int top = 50;
  int bottom = 550;
  
  void draw()
  {
    stroke(0, 0, 0);
    fill(52, 156, 0);
    rectMode(CORNERS);
    rect(left, top, right, bottom);
  }
  
  void clamp()
  {
    // Pass
  
  }


}
