class Obstacle
{
  int x,y,w,h;
  Obstacle(int x_, int y_, int w_, int h_)
  {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }
  
  void show()
  {
    fill(220,0,0);
    rect(x,y,w,h);
  }
}