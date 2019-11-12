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
            BloknotPlayer myBloknotPlayer = new BloknotPlayer("Valentin");

            Game newGame = new Game(0, 10, 7);


            newGame.AddPlayer(myRegPlayer);
            newGame.AddPlayer(myUberPlayer);
            newGame.AddPlayer(myBloknotPlayer);


            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine($"game started, thread {mainThread.ManagedThreadId}");
            var gameResult = newGame.PlayGame();

            if (gameResult.Result)
            {
                var winner = newGame.GetWinner();
                Console.WriteLine($"winner is {winner.Name} ");
            }
            else
            {
                Console.WriteLine("No winner");
            }

            Player.PrintAllPlayerResults();

            myRegPlayer.PrintAnswer();
            myUberPlayer.PrintAnswer();
            myBloknotPlayer.PrintAnswer();







            Console.ReadKey();

        }
    }
}
