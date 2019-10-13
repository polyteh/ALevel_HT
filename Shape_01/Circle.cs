using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shape_01
{
    public class Circle : Shape
    {
        private static Func<double> _squareFunc;
        private double _circleRadius;

        public Circle(double radius):base()
        {
            _circleRadius = radius;
            this.CalculateResults();
        }
        public static void SetSquareFormula(Func<double> squareFunc)
        {
            _squareFunc = squareFunc;
        }
        public double Radius
        {
            get
            {
                return this._circleRadius;
            }
        }

    }
}
