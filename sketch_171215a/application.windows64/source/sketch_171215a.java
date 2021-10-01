import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_171215a extends PApplet {

Rocket[] r;
Target t;
Obstacle[] o;
int counter = 0;
int lifetime = 600;
int population = 100;
float mutationRate = 0.01f;
int rockWidth = 4;
int rockHeight = 12;
boolean text = false;
boolean showVision = false;
float avFit = 0;
float bestFit = 0;
int generation = 0;
float maxForce = 0.12f;
public void setup()
{
  
  background(255);
  r = new Rocket[population];
  t = new Target(width/2,50,20);
  o = new Obstacle[6];
  
  // AREA BOUNDS //
  o[0] = new Obstacle(0,-3,width,2);
  o[1] = new Obstacle(-3,-2,2,6*height);
  o[2] = new Obstacle(width+1,-2,2,6*height);
  
  // CREATE OBSTACLES HERE //
  o[3] = new Obstacle(width/4,3*height/5,width/2,20);
  o[4] = new Obstacle(3*width/5,2*height/7,width/2,20);
  o[5] = new Obstacle(0,2*height/7,2*width/5,20);
 // o[6] = new Obstacle(3*width/5,2*height/7+20,20,height/7);
 // o[7] = new Obstacle(2*width/5-20,2*height/7+20,20,height/7);

  for(int i = 0; i < r.length; i++)
  {
    r[i] = new Rocket(width/2, 4*height/5, rockWidth, rockHeight);
  }
}

public void draw()
{
  background(255);
  t.show();
  for(int i = 0; i < o.length; i++)
  {
    o[i].show();
  }
  fill(0);
  for(int i = 0; i < r.length; i++)
  {
    if(r[i].alive && !r[i].finished)
    {
      r[i].run();
    }
    r[i].show();
  }
  text("frame: " + counter,width-70,10);
  text("generation: " + generation,10,10);
  text("best fitness: " + bestFit,10,30);
  text("average fitness: " + avFit, 10, 50);
  fill(220);
  rect(5,58,115,18);
  rect(5,80,115,18);
  fill(0);
  if(text)
  {
    fill(0,200,0);
    text("show fitness ON",15,70);
  }
  else 
  {
    fill(200,0,0);
    text("show fitness OFF",15,70);
  }
  if(showVision)
  {
    fill(0,200,0);
    text("show vision ON",15,92);
  }
  else 
  {
    fill(200,0,0);
    text("show vision OFF",15,92);
  }
  
  if(counter==lifetime-1)
  {
    bestFit = 0;
    avFit = 0;
    r = select(r);
    r = breed(r);
    r = mutate(r);
    counter = 0;
    generation++;
    for(int i = 0; i < r.length; i++)
    {
      r[i].reset();
    }
  }
  counter++;
}

public void mouseClicked()
{
  if(mouseX > 5 && mouseX < 120 && mouseY > 58 && mouseY < 76) text = !text;
  if(mouseX > 5 && mouseX < 120 && mouseY > 80 && mouseY < 98) showVision = !showVision;
}

public Rocket[] select(Rocket[] pool)
{
  pool = bubbleSort(pool);
  Rocket[] best = new Rocket[pool.length];
  for(int i = 0; i < pool.length;i++)
  {
    best[i] = new Rocket(width/2,4*height/5, rockWidth , rockHeight);
    avFit+=pool[i].fitness;
    bestFit = bestFit < pool[i].fitness ? pool[i].fitness : bestFit;
    if(pool.length / (i+1) > random(3,15))
    {
      best[i].b.neurons = pool[i].b.neurons;
    }
    else
    {
      best[i].b.neurons = pool[(int)random(0,(int)population/10)].b.neurons;
    }
  }
  avFit /= pool.length;
  return best;
}

public Rocket[] breed(Rocket[] pool)
{
  Rocket[] last = new Rocket[pool.length];
  for(int i = 0; i < pool.length; i++)
  {
    last[i] = new Rocket(width/2,4*height/5, rockWidth , rockHeight);
    int partner = (int)random(0,pool.length);
    //int split = (int)random(lifetime/20,19*lifetime/20);
    for(int j = 0; j < pool[i].b.neurons.length; j++)
    {
      if(random(0,1) > 0.5f) last[i].b.neurons[j] = pool[i].b.neurons[j];
      else last[i].b.neurons[j] = pool[partner].b.neurons[j];
    }
    if(i < population/5) last[i].b.neurons = pool[i].b.neurons;
  }
  return last;
}

public Rocket[] mutate(Rocket[] pool)
{
  for(int i = 0; i < pool.length; i++)
  {
    for(int j = 0; j < pool[i].b.neurons.length; j++)
    {
      if(random(-0.5f*i/lifetime,1) > 1-mutationRate)
      {
        pool[i].b.neurons[j] = PVector.random2D().mult(random(0,maxForce));
      }
    }
  }
  return pool;
}

public Rocket[] bubbleSort(Rocket[] r)
{
  boolean swap = true;
  while(swap)
  {
    swap = false;
    for(int i = 0; i < r.length-1; i++)
    {
      if(r[i].fitness < r[i+1].fitness)
      {
        Rocket temp = r[i+1];
        r[i+1] = r[i];
        r[i] = temp;
        swap = true;
      }
    }
  }
  return r;
}
class Brain
{
  int size;
  PVector neurons[];
  Brain(int s)
  {
    size = s;
    neurons = new PVector[s];
    initiate();
  }
  
  public void initiate()
  {
    for(int i = 0; i < size; i++)
    {
      neurons[i] = PVector.random2D();
      neurons[i].mult(random(0,maxForce));
    }
  }
}
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
  
  public void show()
  {
    fill(220,0,0);
    rect(x,y,w,h);
  }
}
PVector gravity = new PVector(0,0.01f);

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
  
  public void show()
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
  
  public void update()
  {
    //v.mult(0);
    applyForce(gravity);
    v.add(a);
    x += v.x;
    y += v.y;
    a.mult(0);
  }
  
  public void applyForce(PVector f)
  {
    a.add(f);
  }
  
  public void run()
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
  
  public float fitness()
  {
    float mult = 1;
    float df = PVector.dist(new PVector(x,y),new PVector(t.x,t.y));
    if(!alive) mult *= 0.01f;
    if(finished) return lifetime - finishCounter;
    if(checkCanSeeTarget(t,new PVector(x,y))) mult*=10;
    return mult*10/pow((df+y)/2,1.1f);
  }
  
  public boolean checkCollision(Obstacle[] o, PVector d)
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
  
  public boolean checkFinished(Target t, PVector d)
  {
    return (pow(d.x-t.x,2) + pow(d.y-t.y,2) <= pow(t.s/2,2));
  }
  
  public boolean checkCanSeeTarget(Target t, PVector d)
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
  
  public void reset()
  {
    v = new PVector(0,0);
    a = new PVector(0,0);
    x = width/2;
    y = 4*height/5;
    alive = true;
    finished = false;
  }
}
class Target
{
  int x, y, s;
  Target(int x_, int y_, int s_)
  {
    x = x_;
    y = y_;
    s = s_;
  }
  
  public void show()
  {
    fill(200,0,200);
    ellipse(x,y,s,s);
  }
}
  public void settings() {  size(720,640); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_171215a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
