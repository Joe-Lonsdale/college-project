Rocket[] r;
Target t;
Obstacle[] o;
int counter = 0;
int lifetime = 600;
int population = 100;
float mutationRate = 0.005;
int rockWidth = 4;
int rockHeight = 12;
boolean text = false;
boolean showVision = false;
float avFit = 0;
float bestFit = 0;
int generation = 0;
float maxForce = 0.12;
void setup()
{
  size(720,640);
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
  //o[6] = new Obstacle(3*width/5,2*height/7+20,20,height/7);
  //o[7] = new Obstacle(2*width/5-20,2*height/7+20,20,height/7);

  for(int i = 0; i < r.length; i++)
  {
    r[i] = new Rocket(width/2, 4*height/5, rockWidth, rockHeight);
  }
  for(int i = 0; i < 1000; i++)
  {
    for(int j = 0; j < 500; j++)
    {
      println();
    }
  }
}

void draw()
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
  //rect(5,80,115,18);
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
    //fill(0,200,0);
    //text("show vision ON",15,92);
  }
  else 
  {
   // fill(200,0,0);
    //text("show vision OFF",15,92);
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

void mouseClicked()
{
  if(mouseX > 5 && mouseX < 120 && mouseY > 58 && mouseY < 76) text = !text;
  //if(mouseX > 5 && mouseX < 120 && mouseY > 80 && mouseY < 98) showVision = !showVision;
}

Rocket[] select(Rocket[] pool)
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

Rocket[] breed(Rocket[] pool)
{
  Rocket[] last = new Rocket[pool.length];
  for(int i = 0; i < pool.length; i++)
  {
    last[i] = new Rocket(width/2,4*height/5, rockWidth , rockHeight);
    int partner = (int)random(0,pool.length);
    //int split = (int)random(lifetime/20,19*lifetime/20);
    for(int j = 0; j < pool[i].b.neurons.length; j++)
    {
      if(random(0,1) > 0.5) last[i].b.neurons[j] = pool[i].b.neurons[j];
      else last[i].b.neurons[j] = pool[partner].b.neurons[j];
    }
    if(i < population/20) last[i].b.neurons = pool[i].b.neurons;
  }
  return last;
}

Rocket[] mutate(Rocket[] pool)
{
  for(int i = 0; i < pool.length; i++)
  {
    for(int j = 0; j < pool[i].b.neurons.length; j++)
    {
      if(random(-0.5*i/lifetime,1) > 1-mutationRate)
      {
        pool[i].b.neurons[j] = PVector.random2D().mult(random(0,maxForce));
      }
    }
  }
  return pool;
}

Rocket[] bubbleSort(Rocket[] r)
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