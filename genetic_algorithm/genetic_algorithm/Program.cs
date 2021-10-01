using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace genetic_algorithm
{
    class Program
    {
        public static Random rnd = new Random();
        private static string targetString = "";
        private const int maxGenerations = 5000;
        private static string bestString = "";
        private static float bestFitness = 0;
        private static float averageFitness = 0;
        private const int genomes = 2500;

        static void Main(string[] args)
        {
            float mutation = 0.06f;
            int generations = 0;
            Console.Write("Please enter your desired phrase: ");
            targetString = Console.ReadLine();
            List<DNA> population = new List<DNA>();
            for (int i = 0; i < genomes; i++)
            {
                population.Add(new DNA());
                population[i].setMutation(mutation);
            }
            do
            {
                //System.Threading.Thread.Sleep(1);
                generations++;
                runEvolution(population);
                if (generations % 100 == 0)
                {
                    Console.Clear();
                    Console.WriteLine("Generation " + generations + "\n\nTarget String: " + targetString + "\n\nBest String: " + bestString + "\n\nBest Fitness: " + bestFitness + "\n\nAverage Fitness: " + averageFitness + "\n");
                }
            } while (bestString != targetString);
            Console.Clear();
            Console.WriteLine("Generation " + generations + "\n\nTarget String: " + targetString + "\n\nBest String: " + bestString + "\n\nBest Fitness: " + bestFitness + "\n\nAverage Fitness: " + averageFitness + "\n");
            Console.ReadLine();
        }

        public static string getTargetString()
        {
            return targetString;
        }

        public static void runEvolution(List<DNA> population)
        {
            averageFitness = 0;

            List<DNA> matingPool = new List<DNA>();
            for (int i = 0; i < genomes/5; i++)
            {
                matingPool.Add(population[i]);
            }
            matingPool.Sort();
            
            for (int i = 0; i < genomes; i++)
            {
                if (i < genomes / 20) population[i] = matingPool[i];
                else
                {
                    int a = rnd.Next(matingPool.Count);
                    int b = rnd.Next(matingPool.Count);

                    DNA parentA = matingPool[a];
                    DNA parentB = matingPool[b];

                    DNA child = parentA.cross(parentB);
                    child.mutate();
                    population[i] = child;
                }
            }

            foreach (DNA d in population)
            {
                averageFitness += d.getFitness();
            }
            averageFitness = averageFitness / population.Count();

            population.Sort();

            bestString = population[0].getGenes();
            bestFitness = population[0].getFitness();
        }
    }

    class DNA : IComparable<DNA>
    {
        float mutationRate = 0.06f;
        Random rnd = Program.rnd;
        char[] genes = new char[Program.getTargetString().Length];
        float fitnessPercent = 0;
        public DNA()
        {
            for (int i = 0; i < genes.Length; i++)
            {
                genes[i] = (char)(rnd.Next(32, 127));
            }
            fitness();
        }

        private void fitness()
        {
            int score = 0;
            string target = Program.getTargetString();
            for (int i = 0; i < genes.Length; i++)
            {
                if (genes[i] == target[i]) score++;
            }
            fitnessPercent = (float)score / target.Length;
        }

        public DNA cross(DNA partner)
        {
            DNA child = new DNA();
            for (int i = 0; i < Program.getTargetString().Length; i++)
            {
                if (rnd.Next(100) % 2 == 0) child.genes[i] = genes[i];
                else child.genes[i] = partner.genes[i];
            }
            child.fitness();
            return child;
        }

        public void mutate()
        {
            for (int i = 0; i < genes.Length; i++)
            {
                if (rnd.NextDouble() < mutationRate)
                {
                    genes[i] = (char)rnd.Next(32, 127);
                }
            }
            fitness();
        }

        public float getFitness()
        {
            return fitnessPercent;
        }

        public string getGenes()
        {
            string end = new string(genes);
            return end;
        }

        public void setMutation(float m)
        {
            mutationRate = m;
        }

        public int CompareTo(DNA other)
        {
            return -fitnessPercent.CompareTo(other.fitnessPercent);
        }
    }
}
