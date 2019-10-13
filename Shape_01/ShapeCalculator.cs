using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shape_01
{
    public class ShapeCalculator
    {
        // we store formulas for each Type of Shape class here
        private static Dictionary<Type, Func<Shape, (double, double)>> mySquareShapeCalculator;
        // event, where calculation was performed
        public event Action<(double, double)> SquareLenghtCalculated;

        static ShapeCalculator()
        {
            // create dictionary
            mySquareShapeCalculator = new Dictionary<Type, Func<Shape, (double, double)>> {
                { typeof(Circle), SquareCalculateCircle }, 
                { typeof(Rectangle), RectangleCalculateCircle },
                { typeof(Triangle), TriangleCalculateCircle }
            };
        }
        public void CalculateSquareLenght(Shape curShape)
        {
            // try to find object parameter Type in the keys of Dictionary
            if (mySquareShapeCalculator.ContainsKey(curShape.GetType()))
            {
                var answer = mySquareShapeCalculator[curShape.GetType()](curShape);
                // if the have any subscriber - invoke event
                SquareLenghtCalculated?.Invoke(answer);
            }
            else
            {
                throw new ArgumentException($"There is not method for {curShape.GetType()} parameters calculation");
            }
        }

        // а вот не могу так определаить параметры, вопрос почему? я же пытаюсь записать в Func<Shape, (double, double)>> по наследованию Func<Circle, (double, double)>> 
        //private static double SquareCalculateCircle(Circle curCircle)
        //{
        //    double circleSquare = Math.PI * Math.Pow(curCircle.Radius, 2);
        //    return circleSquare;
        //}

        // logic for circles
        private static (double, double) SquareCalculateCircle(Shape curShape)
        {
            Circle curCircle = (Circle)curShape;
            double circleSquare = Math.PI * Math.Pow(curCircle.Radius, 2);
            double circleLenght = 2 * Math.PI * curCircle.Radius;
            return (circleSquare, circleLenght);
        }
        // logic for rectangles
        private static (double, double) RectangleCalculateCircle(Shape curShape)
        {
            Rectangle curRect = (Rectangle)curShape;
            double rectangleSquare = curRect.Height * curRect.Width;
            double rectangleLenght = 2 * (curRect.Height + curRect.Width);
            return (rectangleSquare, rectangleLenght);
        }
        // logic for triangles
        private static (double, double) TriangleCalculateCircle(Shape curShape)
        {
            var triangleSizes = ((Triangle)curShape).Sides;
            var halfSum = 0.5 * (triangleSizes.Item1 + triangleSizes.Item2 + triangleSizes.Item3);
            double triangleSquare = Math.Pow(halfSum * (halfSum - triangleSizes.Item1) * (halfSum - triangleSizes.Item2) * (halfSum - triangleSizes.Item3), 0.5);
            return (triangleSquare, (2 * halfSum));
        }
    }
}
