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
  
  void initiate()
  {
    for(int i = 0; i < size; i++)
    {
      neurons[i] = PVector.random2D();
      neurons[i].mult(random(0,maxForce));
    }
  }
}