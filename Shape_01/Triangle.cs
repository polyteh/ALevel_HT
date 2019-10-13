using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shape_01
{
    public class Triangle : Shape
    {
        private double _triangleSide1, _triangleSide2, _triangleSide3;
        public Triangle(double triangleSide1, double triangleSide2, double triangleSide3)
        {
            this._triangleSide1 = triangleSide1;
            this._triangleSide2 = triangleSide2;
            this._triangleSide3 = triangleSide3;
            this.CalculateResults();
        }
        public (double, double, double) Sides
        {
            get
            {
                var sidesToReturn = (this._triangleSide1, this._triangleSide2, this._triangleSide3);
                return sidesToReturn;
            }
        }
    }
}
