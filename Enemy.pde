// Faheem

class Enemy extends Rectangle {
  int hp, atk, gridLoc;
  PImage img;
  boolean isDead;

  /*Enemy constructor
   pre: none
   post: none */
  Enemy() {
    super();
    this.hp = 100;
    this.atk = 100;
  }

  /*Enemy constructor with parameters
   pre: none
   post: none */
  Enemy(int left, int top, int w, int h, String name, int hp, int atk, PImage foeImage, int gridLoc)
  {
    super(left, top, w, h, name);
    this.hp = hp;
    this.atk = atk;
    img = foeImage;
    this.gridLoc = gridLoc;
  }

  /*method shows the enemy
   pre: none
   post: none */
  void show() 
  {
    image(img, left, top, getWidth(), getHeight());
  }

  /*changes the image of the character
   pre: the string is a valid file name of a image
   post: none */
  public void setImage(String newImg)
  {
    img = loadImage(newImg);
  }

  /*accessor for gridLocation of the enemy
   pre: none
   post: none */
  int getGridLoc() {
    return this.gridLoc;
  }

  /*checks to see if the enemies rectangle is equal to another rectangle
   pre: none
   post: retunrs true if the rectangles are equal and false otherwise */
  boolean equals(Rectangle r) {
    if (this.left == r.left && this.top == r.top) {//rectangles are equal
      return true;
    }
    return false;
  }

  /*checkts to see if the enemies left and top is equal to a left and top parameter sent
   pre: none
   post: retunrns true if the values are equal and false otherwise */
  boolean equals(int left, int top) {//rectangles top and lefts are both equal
    if (this.left == left && this.top == top) {
      return true;
    }
    return false;
  }

  /*checks to see if the enemy is alive
   pre: none
   post: none */
  boolean isAlive()
  {
    if (this.hp > 0)
    {
      return true;
    } else {
      return false;
    }
  }

  /* turns the enemy into a transparent imge and changes its name
   pre: none
   post: none */
  void kill() {
    this.isDead = true;
    this.img = loadImage("transparent.png");
    this.nameSet("dead");
  }
}
