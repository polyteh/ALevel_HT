using Basket_thread.Players;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Basket_thread
{
   // public delegate void SendGame (Game curGame);
    public class Game
    {
        // we will hold all our players here
        List<Player> _playerList;

        // turn counter
        private int _currentTurn=0;
        // maximum number of turns
        private readonly int _maxNumberOfTurns = 20;
        // correct answer
        private readonly int _correctAnswer;

        private readonly int _minimumValue=40;
        private readonly int _maximumValue=140;

        /// <summary>
        /// cancelation token, if somebody guess rigght value
        /// </summary>
        private static CancellationTokenSource _tokenSource = new CancellationTokenSource();


        protected static object _locker = new object();

        public Game(int minimumValue, int MaximumValue, int answer)
        {
            _playerList = new List<Player>();
            _correctAnswer = answer;

        }
        public void AddPlayer(Player newPlayer)
        {
            _playerList.Add(newPlayer);
            //newPlayer.TurnCompleted += this.TurnCounter();
            newPlayer.TurnCompleted += () => this._currentTurn++;
            newPlayer.GetRightAnswer += () => _tokenSource.Cancel();
           
        }
        public async Task<bool> PlayGame()
        {
            int numberOfPlayers = _playerList.Count();
            if (numberOfPlayers>0)
            {
                Task[] playersStartGameTasks = new Task[numberOfPlayers];

                // вот чего не понимаю: без объявления внутри цикла промежуточной переменной идет ошибка на IndexOutOfRange при заполнении массива тасков
                // откуда она, я же таски не стартую??
                // или все, что под катом new Task (автоматом перекидывается в другой поток)?
                //for (int q = 0; q < numberOfPlayers; q++)
                //{
                //    var localVar = q;
                //    Console.WriteLine($"Index{localVar}");
                //    playersStartGame[localVar] = new Task(() => _playerList[localVar].PlayGame(this, _locker, _tokenSource.Token));
                //}

                // типа в параллели заполнил набор тасков
                Parallel.For(0,numberOfPlayers,(i)=> { playersStartGameTasks[i] = new Task(() => _playerList[i].PlayGame(this, _locker, _tokenSource.Token)); });
                Parallel.ForEach(playersStartGameTasks, task => task.Start());
                await Task.WhenAll(playersStartGameTasks);
                return true;

                //хардкод на два элемента, работает 
                //playersStartGame[0] = new Task(() => _playerList[0].PlayGame(this, _locker, _tokenSource.Token));
                //playersStartGame[1] = new Task(() => _playerList[1].PlayGame(this, _locker, _tokenSource.Token));
                //playersStartGame[0].Start();
                //playersStartGame[1].Start();
            }
            return false;
        }
        public int MaxTurnNumber => _maxNumberOfTurns; 
        public int Counter => this._currentTurn;
        public int Answer => this._correctAnswer;
        public int MinimumValue => this._minimumValue;
        public int MaximumValue => this._maximumValue;

        private void TurnCounter()
        {
            this._currentTurn++;
        }
        public Player GetWinner()
        {
            Console.WriteLine("in the winner");
            Player winner = _playerList.Where((k) => k.MakeRightAnswer == true).First();
            return winner;

        }

    }
}
