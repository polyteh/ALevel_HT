using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HT_LINQ
{

    class Program
    {
        static void Main(string[] args)
        {
            //First, FirstOrDefault, last, LastOrDefault, Single
            //Набор целых чисел(List). Показать первый положительный и последний отрицательный
            //Расширим предыдущую задачу.Вернуть null в случае отсутствия одного из искомых элементов.
            List<int?> myIntList = new List<int?>() { -2, 3, 4, -1, 12, -15, 14, -6, 9 };
            PrintList("Initial int list", myIntList);
            // набор для проверки если числа нет
            //List<int?> myIntList = new List<int?>() { -2, -3, -4, -1, -12, -15, -14, -6, -9 };
            var firstPositive = myIntList.Where(x => x > 0).FirstOrDefault();
            var lastNegative = myIntList.Where(x => x < 0).LastOrDefault();
            Console.WriteLine($"First positive {firstPositive}, last negative {lastNegative}");


            //Есть некоторый символ и есть набор строк.Если в наборе есть один элемент начинающийся с С, то показать его.
            //Пустая строка -если таких элементов нет.Если таких строк несколько, то вернуть строку из них.
            //Усложняем задание
            //обработать ситуацию с ошибкой в предыдущем примере(когда она будет и почему)
            //Реестр символа должен быть не важен.
            List<string> myStringList = new List<string>() { "Make", "America", "great", "again", "or", "let", "mexicans", "jump", "through", "the", "wall" };
            char beginWith = 'm';
            var wordWithCharacter = myStringList.Where(x =>
            {
                return x.StartsWith(beginWith.ToString(), StringComparison.CurrentCultureIgnoreCase);
            }
            ).DefaultIfEmpty(string.Empty);
            var sumWordWithCharacter = wordWithCharacter.Aggregate((result, item) => result + item);
            // а вот так не работает: для t выбирает through, the и wall
            // var wordWithCtaracter = myStringList.SkipWhile(x=>!x.StartsWith("t"));
            PrintList($"Initial string List", myStringList);
            PrintList($"With character {beginWith} the following words", wordWithCharacter);

            //Where, Distinct
            //Есть набор чисел. Вернем все четные, удалим повторы
            // Reverse
            //Есть число D и лист целых чисел. Найти первый элемент, больший чем D.Вернуть все четные и положительные числа, поменяв их порядок следования
            List<int> myIntList2 = new List<int>() { -2, 2, 1, 3, 4, -1, 3, 5, 8, -4, 2, 6, 5, -8, 7 };
            //уникальный лист четных чисел
            var myEvenList = myIntList2.Where(x => x % 2 == 0).Distinct();
            // первое число больше, чем D и все четные, положительные в обратном порядке
            int treshold = 5;
            var firstGreater = myIntList2.Where(x => x > treshold).First();
            var evenPositiveReverse = myIntList2.Where(x => ((x > 0) && (x % 2 == 0) && (x > treshold))).Reverse();
            PrintList("Initial int list", myIntList2);
            PrintList("Unique even list", myEvenList);
            Console.WriteLine($"First element greater than {treshold} is {firstGreater}");
            PrintList($"Reverse positive elements, greatre than {treshold}", evenPositiveReverse);

            // Concat, DefaultIfEmpty
            //Есть число.Есть два листа чисел. Сделать новый лист из элементов больших чем число(из первой последовательности) и элементов меньших числа(из второй). 
            //Если таких элементов нет -подставить некоторую константу.
            List<int> myIntList3 = new List<int>() { 1,3,5,7,9,11 };
            List<int> myIntList4 = new List<int>() {-10,-8,-6,-4,-2,0,2,4,6,8,10 };
            int treshold2 = 5;
            int defaultValue = 100;
            var jointTreshold = myIntList3.Where(x => x > treshold2).Concat(myIntList4.Where(x=>x<treshold2)).DefaultIfEmpty(defaultValue);


            Console.ReadKey();

        }
        static void PrintList<T>(string comment, IEnumerable<T> listToPrint)
        {
            Console.WriteLine(comment);
            if (listToPrint != null)
            {
                foreach (var item in listToPrint)
                {
                    Console.Write($"{item}\t");
                }
            }
            else
            {
                Console.WriteLine("Query returned no data");
            }

            Console.WriteLine();
        }
    }
}
