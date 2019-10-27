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
        protected static int _minWeight = 0;
        protected static int _maxWeight = 10;
        protected int _minimalDistanceToAnswer;
        /// <summary>
        /// all players answers store here
        /// </summary>
        protected static int[] _allPlayerAnswers=new int [_maxWeight-_minWeight+1];
        /// <summary>
        /// current player answers store here
        /// </summary>
        protected int[] _curPlayerAnswers;
        /// <summary>
        /// cancelation token, if somebody guess rigght value
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
            this._curPlayerAnswers=new int[_maxWeight - _minWeight + 1];

        }
        // for the future update
        public enum PlayerType { RegPlayer, BloknotPlayer, UberPlayer, CheaterPlayer, UberCheaterPlayer };
        public string Name { get; protected set; }
        public bool MakeRightAnswer { get; protected set; }
        public abstract Task<bool> PlayGame(Game curGame, Object locker, CancellationToken cancelToken);


    }
}
