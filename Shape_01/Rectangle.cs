using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shape_01
{
    public class Rectangle : Shape
    {
        private double _rectHeight, _rectWidth;
        public Rectangle(double rectHeight, double rectWidth)
        {
            this._rectHeight = rectHeight;
            this._rectWidth = rectWidth;
            this.CalculateResults();
        }
        public double Height
        {
            get
            {
                return this._rectHeight;
            }
        }
        public double Width
        {
            get
            {
                return this._rectWidth;
            }
        }
    }
}
