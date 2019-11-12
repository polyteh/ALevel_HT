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
                    // вся логика должна быть завернута в lock, так как другой игрок может завершить ход в это время 
                    if (curGame.Counter < curGame.MaxTurnNumber)
                    {
                        int playerAnswer = myRND.Next(_minWeight, _maxWeight+1);
                        this._curPlayerAnswers[playerAnswer-_minWeight] = 1;
                        Console.ForegroundColor = ConsoleColor.Cyan;
                        Console.WriteLine($"Random counter {curGame.Counter} on the tread {countThread.ManagedThreadId} value is {playerAnswer}");
                        // сравнили результат
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
                        // увеличили счетчик ходов в игре
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
