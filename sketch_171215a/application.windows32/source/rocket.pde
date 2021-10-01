PVector gravity = new PVector(0,0.01);

class Rocket
{
  int w, h, finishCounter;
  float x, y, fitness;
  PVector v, a;
  boolean alive, finished;
  Brain b = new Brain(lifetime);
  Rocket(float x_, float y_, int w_, int h_)
  {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    v = new PVector(0,0);
    a = new PVector(0,0);
    alive = true;
    finished = false;
  }
  
  void show()
  {
    pushMatrix();
    translate(x,y);
    fill(255,0,255);
    if(text)text(fitness(),0,0);
    rotate(v.heading());
    fill(0);
    rect(0,0,-h, -w);
    popMatrix();
  }
  
  void update()
  {
    //v.mult(0);
    applyForce(gravity);
    v.add(a);
    x += v.x;
    y += v.y;
    a.mult(0);
  }
  
  void applyForce(PVector f)
  {
    a.add(f);
  }
  
  void run()
  {
    applyForce(b.neurons[counter]);
    update();
    if(checkCollision(o, new PVector(x,y)))
    {
      alive = false;
    }
    if(checkFinished(t, new PVector(x,y)) && !finished)
    {
      finishCounter = counter;
      finished = true;
    }
    fitness = fitness();
  }
  
  float fitness()
  {
    float mult = 1;
    float df = PVector.dist(new PVector(x,y),new PVector(t.x,t.y));
    if(!alive) mult *= 0.01;
    if(finished) return lifetime - finishCounter;
    if(checkCanSeeTarget(t,new PVector(x,y))) mult*=10;
    return mult*10/pow((df+y)/2,1.1);
  }
  
  boolean checkCollision(Obstacle[] o, PVector d)
  {
    for(int i = 0; i < o.length; i++)
    {
      if(d.x > o[i].x && d.x < o[i].x + o[i].w)
      {
        if(d.y > o[i].y && d.y < o[i].y + o[i].h)
        {       
          return true;
        }
      }
    }
    return false;
  }
  
  boolean checkFinished(Target t, PVector d)
  {
    return (pow(d.x-t.x,2) + pow(d.y-t.y,2) <= pow(t.s/2,2));
  }
  
  boolean checkCanSeeTarget(Target t, PVector d)
  {
    int resolution = 150;
    float xDist = t.x - d.x;
    float yDist = d.y - t.y;
    float xInc = xDist / resolution;
    float yInc = yDist / resolution;
    for(int i = 5; i < resolution; i++)
    {
      noStroke();
      fill(0,0,255);
      if(showVision)ellipse(d.x + i*xInc,d.y - i*yInc,1,1);
      stroke(1);
      fill(255,0,255);
      if(checkCollision(o,new PVector(d.x + i*xInc,d.y - i*yInc)))
      {
        return false;
      }
    }
    return true;
  }
  
  void reset()
  {
    v = new PVector(0,0);
    a = new PVector(0,0);
    x = width/2;
    y = 4*height/5;
    alive = true;
    finished = false;
  }
}