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
        // winner, if somebody guess the value
        private Player _winner;

        // turn counter
        private int _currentTurn=0;
        // maximum number of turns
        private readonly int _maxNumberOfTurns = 80;
        // correct answer
        private readonly int _correctAnswer;
        // limits of game, maximum and minimum values
        private readonly int _minimumValue;
        private readonly int _maximumValue;

        /// <summary>
        /// cancelation token, if somebody guess right value
        /// </summary>
        private static CancellationTokenSource _tokenSource = new CancellationTokenSource();

        /// <summary>
        /// lockr to manage access to the common resourses
        /// </summary>
        protected static object _locker = new object();

        //
        public Game(int minimumValue, int maximumValue, int answer)
        {
            _playerList = new List<Player>();
            _correctAnswer = answer;
            this._minimumValue = minimumValue;
            this._maximumValue = maximumValue;
            //update staic fiels of the player
            Player.UpdateGame(_minimumValue, _maximumValue, _correctAnswer);
        }
        // add new player to the game
        public void AddPlayer(Player newPlayer)
        {
            _playerList.Add(newPlayer);
            //newPlayer.TurnCompleted += this.TurnCounter();
            // update current player settings
            newPlayer.UpdateGameSettings(_minimumValue, _maximumValue);
            // event for turn counter
            newPlayer.TurnCompleted += () => this._currentTurn++;
            //event to stop all players, if one gave right answer
            newPlayer.GetRightAnswer += () => _tokenSource.Cancel();
          
        }
        /// <summary>
        /// return true, if somebody gave right answer, overwise return false
        /// </summary>
        /// <returns></returns>
        public async Task<bool> PlayGame()
        {
            // create one Task for each player
            int numberOfPlayers = _playerList.Count();
            if (numberOfPlayers>0)
            {
                Task[] playersStartGameTasks = new Task[numberOfPlayers];

                // вот чего не понимаю: без объявления внутри цикла промежуточной переменной идет ошибка на IndexOutOfRange при заполнении массива тасков
                // откуда она, я же таски не стартую??
                // или все, что под катом new Task автоматом перекидывается в другой поток?
                //for (int q = 0; q < numberOfPlayers; q++)
                //{
                //    var localVar = q;
                //    Console.WriteLine($"Index{localVar}");
                //    playersStartGame[localVar] = new Task(() => _playerList[localVar].PlayGame(this, _locker, _tokenSource.Token));
                //}

                // при этом хардкод на два элемента, работает 
                //playersStartGame[0] = new Task(() => _playerList[0].PlayGame(this, _locker, _tokenSource.Token));
                //playersStartGame[1] = new Task(() => _playerList[1].PlayGame(this, _locker, _tokenSource.Token));
                //playersStartGame[0].Start();
                //playersStartGame[1].Start();

                // ка результат сделал так
                // типа в параллели заполнил набор тасков
                Parallel.For(0,numberOfPlayers,(i)=> { playersStartGameTasks[i] = new Task(() => _playerList[i].PlayGame(this, _locker, _tokenSource.Token)); });
                // запустили все таски
                Parallel.ForEach(playersStartGameTasks, task => task.Start());
                // ждем все таски
                await Task.WhenAll(playersStartGameTasks);
                // проверяем, есть ли победитель, если нет, то null
                _winner = _playerList.Where((k) => k.MakeRightAnswer == true).DefaultIfEmpty(null).First();//First();
                if (_winner!=null)
                {
                    return true;
                }
                return false;
            }
            return false;
        }
        public int MaxTurnNumber => _maxNumberOfTurns; 
        public int Counter => this._currentTurn;
        public int Answer => this._correctAnswer;
        public int MinimumValue => this._minimumValue;
        public int MaximumValue => this._maximumValue;

        // не смог привязать к event
        private void TurnCounter()
        {
            this._currentTurn++;
        }
        // прсто возвращаем победителя
        public Player GetWinner()
        {
            return _winner;
        }

    }
}
