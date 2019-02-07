// Faheem

class Char extends Rectangle
{
  protected int hp, atk;
  protected PImage img;

  /*Constructor 1
   pre: none
   post: none*/
  Char()
  {
    super();
    this.hp = 100;
    this.atk = 100;
  }

  /*intersects method
   pre: 2 rectangles
   post: retuns wether or not 2 rectangles are intersecting */
  Char(Rectangle r, int hp, int atk, PImage img)
  {
    super(r.getLeft(), r.getTop(), r.getWidth(), r.getHeight(), r.getRecName());
    this.hp = hp;
    this.atk = atk;
    this.img = img;
  }

  /*show method
   pre: none
   post: none */
  void show() {
    image(img, player.getLeft(), player.getTop(), 50, 50);
  }

  /*move method
   pre: none
   post: none */
  void move(int xDir, int yDir)
  {
    this.left += xDir;
    this.top += yDir;

    if (left<0 && frameX < 0) {
      this.left= width-50;
      frameX += width;
    } else if (top<0 && frameY < 0) {
      this.top= height-50;
      frameY += height;
    } else if (top > 950 && frameY > -2000) {
      this.top = 0;
      frameY += -height;
    } else if (left > 950 && frameX > -2000) {
      this.left = 0; 
      frameX += -width;
    }
  }

  /*changes the image of the character
   pre: the string is a valid file name of a image
   post: none */
  public void setImage(String newImg)
  {
    img = loadImage(newImg);
  }


  /*sets all house walls from the map to in-game obstacles
   pre: none
   post: none */
  public void boost(int boost, int boostType) {
    switch(boostType) {
    case 1: 
      {
        this.atk += boost;
        break;
      }
    case 2: 
      {
        this.hp += boost;
        break;
      }
    default: 
      {
        break;
      }
    }
  }

  /*checks to see if the player is alive
   pre: none
   post: retunrs flase if the hp < 0*/
  boolean isAlive()
  {
    if (this.hp > 0)//player is still alive
    {
      return true;
    } else
    {
      return false;//player is dead
    }
  }
}
