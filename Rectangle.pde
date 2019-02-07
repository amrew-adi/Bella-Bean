// Faheem

class Rectangle
{
  private int w, h, bottom, right;
  int left, top;
  private String name;

  /*Rectangle Contructor 1
   pre: none
   post: none */
  Rectangle()
  {
    this.left = 0;
    this.top = 0;
    this.w = 50;
    this.h = 50;

    this.bottom = this.h;
    this.right = this.w;

    this.name = "";
  }

  /*Rectangle Contructor 2
   pre: none
   post: none */
  Rectangle(int left, int top, int w, int h, String name)
  {
    this.left = left;
    this.top = top;
    this.w = w;
    this.h = h;

    this.bottom = this.top + this.h;
    this.right = this.left + this.w;

    this.name = name;
  }

  /*intersects method
   pre: 2 rectangles
   post: retuns wether or not 2 rectangles are intersecting */
  boolean intersects(Rectangle r)
  {
    return !(r.left > this.right || r.right < this.left || r.top > this.bottom || r.bottom < this.top);
  }

  /*accessor for left
   pre: 
   post: retuns left side's position of the calling rectangle*/
  public int getLeft()
  {
    return this.left;
  }


  /*accessor for bottom
   pre: 
   post: retuns the bottom position of the calling rectangle*/
  public int getTop()
  {
    return this.top;
  }

  /*accessor for width
   pre:
   post: retuns width of calling rectangle */
  public int getWidth()
  {
    return this.w;
  }


  /*Accessor for height
   pre: 
   post: returns the height of the calling rectangle */
  public int getHeight()
  {
    return this.h;
  }

  /*get Rectangle name
   pre: the rectangle already has a name
   post: returns the name of the rectangle */
  public String getRecName() {
    return this.name;
  }

  /*sets name
   pre: none
   post: none */
  void nameSet(String name)
  {
    this.name = name;
  }

  /*Shows the rectangle with a given colour
   pre: none
   post: none */
  void show(int r, int g, int b)
  {
    noStroke();
    noFill();
    fill(r, g, b);
    rect(left, top, w, h);
  }

  /*shows rectangle with a white outline
   pre: none
   post: none */
  void show()
  {
    noStroke();
    noFill();
    rect(left, top, w, h);
  }
}
