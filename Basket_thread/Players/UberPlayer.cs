using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Basket_thread.Players
{
    public class UberPlayer:Player
    {
        public override event Action TurnCompleted;
        public override event Action GetRightAnswer;
        public UberPlayer(string PlayerName):base (PlayerName)
        {
            Console.WriteLine($"uber array size {this._curPlayerAnswers.Length}");
        }
        public override Task<bool> PlayGame(Game curGame, Object locker, CancellationToken cancelToken)
        {
            Console.WriteLine("uber player");
            Thread countThread = Thread.CurrentThread;
            int i = 0;
            while (!cancelToken.IsCancellationRequested)
            {
                lock (locker)
                {
                    if (curGame.Counter < curGame.MaxTurnNumber)
                    {
                        Console.ForegroundColor = ConsoleColor.Blue;
                        Console.WriteLine($"Uber counter {curGame.Counter} on the tread {countThread.ManagedThreadId} value is {i}");
                        if (curGame.Answer == i)
                        {
                            if (GetRightAnswer != null)
                            {
                                this.MakeRightAnswer = true;
                                GetRightAnswer();
                            };
                        };
                        if (TurnCompleted != null)
                        {
                            TurnCompleted();
                        };
                        i++;
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
