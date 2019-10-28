using Basket_thread.Players;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Basket_thread
{
    class Program
    {
        public static Object _locker = new object();
        static void Main(string[] args)
        {
            Thread mainThread = Thread.CurrentThread;

            RegularPlayer myRegPlayer = new RegularPlayer("Vilgelm");
            UberPlayer myUberPlayer = new UberPlayer("Gans");

            Game newGame = new Game(0,10,7);

            

            newGame.AddPlayer(myRegPlayer);
            newGame.AddPlayer(myUberPlayer);


            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine($"game started, thread {mainThread.ManagedThreadId}");
            var gameResult=newGame.PlayGame();
           
            if (gameResult.Result)
            {
                var winner = newGame.GetWinner();
                Console.WriteLine($"winner is {winner.GetType()} ");
            }
            else
            {
                Console.WriteLine("No winner");
            }

            myRegPlayer.PrintAnswer();
            myUberPlayer.PrintAnswer();
   





            Console.ReadKey();

        }
    }
}
