using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shape_01
{
    public abstract class Shape : iShape
    {
        protected double _shapeSquare, _shapeLenght;
        protected ShapeCalculator shapeCalculator;
        public Shape()
        {
            shapeCalculator = new ShapeCalculator();
            shapeCalculator.SquareLenghtCalculated += this.GetCalculatedParameters;
        }
        protected virtual void CalculateResults()
        {
            shapeCalculator.CalculateSquareLenght(this);
        }
        protected virtual void GetCalculatedParameters((double, double) calculatedparameters)
        {
            this._shapeSquare = calculatedparameters.Item1;
            this._shapeLenght = calculatedparameters.Item2;
        }
        public virtual double Square
        {
            get
            {
                return this._shapeSquare;
            }
        }
        public virtual double Lenght
        {
            get
            {
                return this._shapeSquare;
            }
        }
    }
}
