class Creature
{
  float x,y,r,g,b;
  boolean alive;
  Creature(float x_,float y_,float r_,float g_,float b_)
  {
    alive = true;
    x = x_;
    y = y_;
    r = r_;
    g = g_;
    b = b_;
  }
  
  Creature(float x_,float y_)
  {
    x = x_;
    y = y_;
    instantiate();
  }
  
  void instantiate()
  {
    alive = true;
    r = random(0,255);
    g = random(0,255);
    b = random(0,255);
  }
  
  void show()
  {
    colorMode(RGB);
    fill(r,g,b);
    ellipse(x,y,creatureSize,creatureSize);
  }
  
  float fitness()
  {
    if(abs(targr-r)+abs(targg-g)+abs(targb-b) == 0) return 1;
    if(1/(abs(targr-r)+abs(targg-g)+abs(targb-b)) > 1) return 1;
    return 1/(abs(targr-r)+abs(targg-g)+abs(targb-b)); 
  }
  
  void setPos(float x_, float y_)
  {
    x = x_;
    y = y_;
  }
}