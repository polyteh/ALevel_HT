using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Basket_thread.Players
{
    public interface IPlayer
    {
        Task<bool> PlayGame(Game curGame, Object locker, CancellationToken cancelToken);
        event Action TurnCompleted;
        event Action GetRightAnswer;
        void UpdateGameSettings(int minValue, int maxValue);
    }
}
