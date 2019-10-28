using Basket_thread.Players;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Basket_thread
{
    public delegate void ActionComplete();
    public abstract class Player : IPlayer
    {
        // fileds
        protected static int _minWeight;
        protected static int _maxWeight;
        protected static int _gameAnswer;
        protected int _minimalDistanceToAnswer;
        /// <summary>
        /// all players answers store here
        /// </summary>
        protected static int[] _allPlayerAnswers ;
        /// <summary>
        /// current player answers store here
        /// </summary>
        protected int[] _curPlayerAnswers;
        /// <summary>
        /// cancelation token, if somebody guess right value
        /// </summary>
        public static CancellationTokenSource _tokenSource = new CancellationTokenSource();
        /// <summary>
        /// needs to incapsulate logic of turn counter
        /// </summary>
        public abstract event Action TurnCompleted;
        /// <summary>
        /// fire, if somebody give right answer
        /// </summary>
        public abstract event Action GetRightAnswer;

        public Player(string playerName)
        {
            this.Name = playerName;
        }
        // for the future update
        public enum PlayerType { RegPlayer, BloknotPlayer, UberPlayer, CheaterPlayer, UberCheaterPlayer };
        public string Name { get; protected set; }
        // возврат расстояния от верного ответа до ближайшего ответа текущего игрока
        public int NearestResult
        {
            get
            {
                int nearestAnswer = GetNearestAnswer();
                return nearestAnswer;
            }
        }
        // свойство, которое покажеь, что именно этот игрок дал правильный ответ
        public bool MakeRightAnswer { get; protected set; }
        // основной метод, получает ссылку на игру, локер и токен на остановку
        public abstract Task<bool> PlayGame(Game curGame, Object locker, CancellationToken cancelToken);

        // просто печать результатов для отладки
        public void PrintAnswer()
        {
            Console.WriteLine($"Player {this.Name} ({this.GetType()}) results");
            foreach (var item in this._curPlayerAnswers)
            {
                Console.Write($"{item,6}");
            }
        }
        // обновление настроек текущего игрока
        public void UpdateGameSettings(int minValue, int maxValue)
        {
            this._curPlayerAnswers = new int[maxValue - minValue + 1];
            Console.WriteLine($"{this.GetType()} player array size {this._curPlayerAnswers.Length}");
        }
        // обновление статических поелй (происходит при создании новой игры)
        public static void UpdateGame(int minValue, int maxValue, int gameAnswer)
        {
            _minWeight = minValue;
            _maxWeight = maxValue;
            _gameAnswer = gameAnswer;
            _allPlayerAnswers = new int[_maxWeight - _minWeight + 1];

        }
        // расчет и возврат расстояния от верного ответа до ближайшего ответа текущего игрока
        private int GetNearestAnswer()
        {
            // выделили левую часть
            var leftPart = this._curPlayerAnswers.Take(_gameAnswer).ToArray();
            var leftIndex = _gameAnswer - Array.FindLastIndex(leftPart, x => x > 0) - 1;

            var rightPart = this._curPlayerAnswers.Skip(_gameAnswer + 1);
            var rightIndex = Array.FindIndex(rightPart.ToArray(), x => x > 0);

            return leftIndex < rightIndex ? leftIndex : rightIndex;
        }

    }
}
