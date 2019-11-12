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
            
        }
        public override Task<bool> PlayGame(Game curGame, Object locker, CancellationToken cancelToken)
        {
            Console.WriteLine("uber player");
            Thread countThread = Thread.CurrentThread;
            int playerAnswer = _minWeight;
            while (!cancelToken.IsCancellationRequested)
            {
                lock (locker)
                {
                    if (curGame.Counter < curGame.MaxTurnNumber)
                    {
                        Console.ForegroundColor = ConsoleColor.Blue;
                        Console.WriteLine($"Uber counter {curGame.Counter} on the tread {countThread.ManagedThreadId} value is {playerAnswer}");
                        this._curPlayerAnswers[playerAnswer-_minWeight] = 1;
                        if (curGame.Answer == playerAnswer)
                        {
                            if (GetRightAnswer != null)
                            {
                                this.MakeRightAnswer = true;
                                GetRightAnswer();
                            };
                        }
                        else
                        {
                            Player.RegisterPlayerAnswer(playerAnswer);
                        }
                        if (TurnCompleted != null)
                        {
                            TurnCompleted();
                        };
                        playerAnswer++;
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
