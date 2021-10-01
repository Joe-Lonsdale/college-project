color c = -1;
float targr,targg,targb;
Creature[][] population;
Creature[] pool;
int size = 10;
int creatureSize = 50;
float mutationRate = 0.07;
float mutationVariance = 100;
boolean autorun = false;
int stepCount = 0;

void setup()
{
  size(660,660);
  background(255);
  colorMode(HSB,255,255,100);
  population = new Creature[size][size];
  for(int i = 0; i < size; i++)
  {
    for(int j = 0; j < size; j++)
    {
      population[i][j] = new Creature((i+1)*(creatureSize + 10), (j+1) * (creatureSize + 10));
    }
  }
}

void draw()
{ 
  if(c == -1)
  {
    colorMode(HSB,255,255,100);
    for(int i = 0; i < width-39; i++)
    {
      for(int j = 0; j < height-39; j++)
      {  
        stroke(map(i,0,width-39,0,255),map(j,0,height-39,0,255),100);
        point(i+20,j+20);
      }
    }
  }
  else
  {
    background(255);
    fill(c);
    rect(0,0,width/7,20);
    rect(2*width/7,0,width/7,20);
    rect(4*width/7 - 10,0,width/7 + 10,20);
    rect(6*width/7,0,width/7,20);
    if(autorun) fill(0,200,0);
    else fill(200,0,0);
    ellipse(width-16,10,8,8);
    fill(0);
    text("SORT",width/20,14);
    text("SELECT",2*width/7 + width/22,14);
    text("BREED/MUTATE",4*width/7 -3,14);
    text("AUTORUN",6*width/7 + 8,14);
    stroke(0);
    for(int i = 0; i < size; i++)
    {
      for(int j = 0; j < size; j++)
      {
        if(population[i][j].alive)
        {
          population[i][j].show();
          fill(0);
          text(population[i][j].fitness(),population[i][j].x-creatureSize/3,population[i][j].y);
        }
      }
    }
    if(autorun)
    {
      switch(stepCount)
      {
        case(0):
        population = bubbleSort(population);
        delay(200);
        stepCount++;
        break;
        case(1):
        select();
        delay(200);
        stepCount++;
        break;
        case(2):
        breed();
        delay(200);
        stepCount++;
        case(3):
        mutate();
        delay(200);
        stepCount++;
        stepCount = 0;
        break;
      }
    }
  }
}

void select()
{
  int creatureCount = 0;
  for(int i = 0; i < size; i++)
  {
    for(int j = 0; j < size; j++)
    {
      if(random(i*size+j) > size*size/5) population[i][j].alive = false;
      else creatureCount++;
    }
  }
  pool = new Creature[creatureCount];
  int temp = 0;
  for(int i = 0; i < size; i++)
  {
    for(int j = 0; j < size; j++)
    {
      if(population[i][j].alive)
      {
        pool[temp] = population[i][j];
        temp++;
      }
    }
  }
}

void breed()
{
  int parent1,parent2;
  int temp = 0;
  population = new Creature[size][size];
  while(temp < size*size)
  {
    parent1 = 0;
    parent2 = 0;
    while(parent1 == parent2)
    {
      parent1 = floor(random(pool.length));
      parent2 = floor(random(pool.length));
    }
    population[floor(temp/size)][temp%size] = new Creature((floor(temp/size)+1)*(creatureSize + 10), (temp%size +1) * (creatureSize + 10),pool[parent1].r,pool[parent1].g,pool[parent2].b);      // red = parent1, green = parent1, blue = parent2
    temp++;
  }
}

void mutate()
{
  float colChange = 0;
  for(int i = 0; i < size; i++)
  {
    for(int j = 0; j < size; j++)
    {
      if(random(0,1) < mutationRate)
      {
        do
        {
          colChange = random(-mutationVariance,mutationVariance);
        } while(population[i][j].r + colChange > 255 || population[i][j].r + colChange < 0);   // mutate red
        population[i][j].r += colChange;
      }
      if(random(0,1) < mutationRate)
      {
        do
        {
          colChange = random(-mutationVariance,mutationVariance);
        } while(population[i][j].g + colChange > 255 || population[i][j].g + colChange < 0);   // mutate green
        population[i][j].g += colChange;
      }
      if(random(0,1) < mutationRate)
      {
        do
        {
          colChange = random(-mutationVariance,mutationVariance);
        } while(population[i][j].b + colChange > 255 || population[i][j].b + colChange < 0);   // mutate blue
        population[i][j].b += colChange;
      }
    }
  }
}

void mouseClicked()
{
  colorMode(RGB,255,255,255);
  if(c==-1) 
  {
    c = get(mouseX,mouseY);
    targr = red(c);
    targg = green(c);
    targb = blue(c);
  }
  if(mouseY < 20)
  {
    if(mouseX < width/7) // sort
    {
      population = bubbleSort(population);
      for(int i = 0; i < size; i++)
      {
        for(int j = 0; j < size; j++)
        {
          if(population[i][j].alive)
          {
            population[i][j].show();
            fill(0);
            text(population[i][j].fitness(),population[i][j].x,population[i][j].y);
          }
        }
      }
    }
    if(mouseX > 2*width/7 && mouseX < 3*width/7) // select
    {
      select();
      for(int i = 0; i < size; i++)
      {
        for(int j = 0; j < size; j++)
        {
          if(population[i][j].alive)
          {
            population[i][j].show();
            fill(0);
            text(population[i][j].fitness(),population[i][j].x,population[i][j].y);
          }
        }
      }
    }
    if(mouseX > 4*width/7 && mouseX < 5*width/7) // breed / mutate
    {
      breed();
      for(int i = 0; i < size; i++)
      {
        for(int j = 0; j < size; j++)
        {
          if(population[i][j].alive)
          {
            population[i][j].show();
            fill(0);
            text(population[i][j].fitness(),population[i][j].x,population[i][j].y);
          }
        }
      }
      mutate();
    }
    if(mouseX > 6*width/7)
    {
      autorun = !autorun;
    }
  }
  
}

Creature[][] bubbleSort(Creature[][] c)
{
  Creature[] c1 = new Creature[size*size];
  for(int i = 0; i < size; i++)
  {
    for(int j = 0; j < size; j++)
    {
      c1[i*size + j] = c[i][j];
    }
  }
  boolean swap = true;
  while(swap)
  {
    swap = false;
    for(int i = 0; i < size*size-1; i++)
    {
      if(c1[i].fitness() < c1[i+1].fitness())
      {
        Creature temp = c1[i+1];
        c1[i+1] = c1[i];
        c1[i] = temp;
        swap = true;
      }
    }
  }
  c = new Creature[size][size];
  for(int i = 0; i < size; i++)
  {
    for(int j = 0; j < size; j++)
    {
      c[i][j] = c1[i*size + j];
      c[i][j].setPos((j+1)*(creatureSize + 10), (i+1) * (creatureSize + 10));
    }
  }
  return c;
}