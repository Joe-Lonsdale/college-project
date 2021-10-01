class Target
{
  int x, y, s;
  Target(int x_, int y_, int s_)
  {
    x = x_;
    y = y_;
    s = s_;
  }
  
  void show()
  {
    fill(200,0,200);
    ellipse(x,y,s,s);
  }
}