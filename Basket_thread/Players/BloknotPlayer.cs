using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Basket_thread.Players
{
    public class BloknotPlayer : Player
    {
        public override event Action TurnCompleted;
        public override event Action GetRightAnswer;
        public BloknotPlayer(string PlayerName) : base(PlayerName)
        {

        }
        public override Task<bool> PlayGame(Game curGame, Object locker, CancellationToken cancelToken)
        {
            Console.WriteLine("bloknot player");
            Thread countThread = Thread.CurrentThread;
            Random myRND = new Random();
            int playerAnswer = myRND.Next(_minWeight, _maxWeight + 1);
            while (!cancelToken.IsCancellationRequested)
            {
                lock (locker)
                {
                    if (curGame.Counter < curGame.MaxTurnNumber)
                    {
                        while (this._curPlayerAnswers[playerAnswer - _minWeight]!=0)
                        {
                            playerAnswer = myRND.Next(_minWeight, _maxWeight + 1);
                        }
                        this._curPlayerAnswers[playerAnswer - _minWeight] = 1;
                        Console.ForegroundColor = ConsoleColor.Green;
                        Console.WriteLine($"bloknot counter {curGame.Counter} on the tread {countThread.ManagedThreadId} value is {playerAnswer}");
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
