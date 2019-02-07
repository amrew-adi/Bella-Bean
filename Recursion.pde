// Both Amrew and Faheem

class Recursion
{
  float diam, angle, x1, y1, x2, y2, x3, y3;

  /* Default constructor
   pre: none
   post: none */
  Recursion()
  {
    diam = 0; 
    angle = 0;
    x1 = 400;
    y1 = 400;
    x2 = 15;
    y2 = 60;
    x3 = 30;
    y3 = 10;
  }

  /*Draw
   pre: none
   post: none */
  void showRecursion(char person)
  {
    background(0);//BG colour (black)
    noFill();//removes coloiur from arc
    if (person == 'f') {
      fractal(diam, angle);//fractal recursion
    } else {
      drawRecursion(x1, y1, x2, y2, x3, y3);
    }
  }


  /*fractal - recursion
   pre: none
   post: keeps drawing arcs until a full circle arc is made.*/
  void fractal(float diam, float angle)
  {
    float x = width/2;
    float y = height/2;
    stroke(random(255), random(255), random(255));
    arc(x, y, diam, diam, 0, angle, PIE);//draws an arc
    if (x > width || angle > TWO_PI || diam > 3000)//Terminating condition diameter is greater than 3000 or the angle of the arc is 2Pi (circle)
      arc(x, y, diam, diam, 0, angle, PIE);//draw the original arc if terminating condition met
    else
    {
      fractal(diam+10, angle+PI/100); //Otherwise add PI/100 to the angle and 10pixels to the diameter
    }
  }

  /*draw recursion
   pre: none
   post: none */
  void drawRecursion(float x1, float y1, float x2, float y2, float x3, float y3) {
    stroke(random(70, 255), random(100, 255), random(200, 255));
    noFill();
    triangle(x1, y1, x2, y2, x3, y3);
    if (x1 < 800) {
      drawRecursion(x1 + 30 / 5, y1 * 1.3, x2 + 30 / 2, y2, x3 + 30 / 2, y3);
    }
    if (y1 < 800) {
      drawRecursion(x1 * 1.3, y1 + 30 / 5, x2, y2 + 30 / 2, x3, y3 + 30 / 2);
    }
  }
}
