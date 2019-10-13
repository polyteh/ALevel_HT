using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shape_01
{
    //
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // create few instances of Shape and check their square
                Circle myCircle = new Circle(2);
                Rectangle myRect = new Rectangle(12, 12.2);
                Console.WriteLine($"Circle {myCircle.Square:##.##}");
                Console.WriteLine($"Rectangle {myRect.Square:##.##}");
                Console.WriteLine($"Once again circle {myCircle.Square:##.##}");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            Console.ReadKey();

        }
    }
}
