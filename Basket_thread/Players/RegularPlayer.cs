using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Basket_thread.Players
{
    public class RegularPlayer : Player
    {
        public override event Action TurnCompleted;
        public override event Action GetRightAnswer;
        public RegularPlayer(string PlayerName) : base(PlayerName)
        {
            Console.WriteLine($"reg array size {this._curPlayerAnswers.Length}");
        }
        public override Task<bool> PlayGame(Game curGame, Object locker, CancellationToken cancelToken)
        {
            Console.WriteLine("regular player");
            Thread countThread = Thread.CurrentThread;
            Random myRND = new Random();
            while (!cancelToken.IsCancellationRequested)
            {
                lock (locker)
                {
                    if (curGame.Counter < curGame.MaxTurnNumber)
                    {
                        int t = myRND.Next(_minWeight, _maxWeight+1);

                        Console.ForegroundColor = ConsoleColor.Cyan;
                        Console.WriteLine($"Random counter {curGame.Counter} on the tread {countThread.ManagedThreadId} value is {t}");
                        if (curGame.Answer == t)
                        {
                            if (GetRightAnswer != null)
                            {
                                this.MakeRightAnswer = true;
                                GetRightAnswer();
                            };
                        }

                        if (TurnCompleted!=null)
                        {
                            TurnCompleted();
                        };                       
                    }
                    else
                    {
                        return Task.FromResult(false);
                    }
                }
                Thread.Sleep(400);
            };
            return Task.FromResult(false);
        }
    }
}
