// Faheem

class Obstacle extends Rectangle
{
  protected PImage img;

  /*Constructor for Interactable
   pre: none
   post: none */
  Obstacle()
  {
    super();
    img = loadImage("transparent.png");
  }

  /*2nd constructor for interactables
   pre: none
   post: none */
  Obstacle(int left, int top, int w, int h, PImage img, String name)
  {
    super(left, top, w, h, name); 
    this.img = img;
  }

  /*Shows the interactable on the grid.
   pre: none
   post: none */
  void show()
  {
    image(img, left, top, 50, 50);
  }
}
