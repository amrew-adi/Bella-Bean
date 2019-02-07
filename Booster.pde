// Amrew

class Booster extends Rectangle {
  PImage img;
  private int boostType; // Identity of booster: 1 - Atk, 2 - Health
  private int boostVal;
  private boolean used;
  int gridLoc;

  /* Default Booster constructor
   pre: none
   post: none */
  Booster() {
    super();
    boostVal = 0;
    boostType = 0;
  }

  /* Booster constructor with given parameters
   pre: none
   post: none */
  Booster(int left, int top, int w, int h, int gridLoc, PImage img, int boostType) {
    super(left, top, w, h, "Booster");
    this.img = img;
    boostVal = (int)random(1, 3) * 100;
    this.boostType = boostType;
    this.gridLoc = gridLoc;
  }

  /*aCCESSOR FOR THE TYPE OF BOOSTER
   pre: none
   post: none */
  int getBoostType() {
    return this.boostType;
  }

  /*accessor for the boos amount
   pre: none
   post: none */
  int getBoostVal() {
    return this.boostVal;
  }

  /*accessor for the boosters gridlocation
   pre: none
   post: none */
  int getGridLoc() {
    return this.gridLoc;
  }


  /*isUsed checks if a booster has been used
   pre: none
   post: returns true or false depending if booster has been used */
  boolean isUsed() {
    return this.used;
  }

  /*changes used to true and removes the picture of the booster
   pre: none
   post: none */
  void consumed() {
    this.used = true;
    this.img = loadImage("transparent.png");
  }

  /*shows booster
   pre: none
   post: none */
  void show() {
    image(img, left, top, 50, 50);
  }

  /*checks to see if the boosters location is equal to the players
   pre: the Char has a top and bottom
   post: returns true if the booster and player are at the same location and flase if theyre not*/
  boolean equals(Char player) {
    if (this.left == player.left && this.top == player.top) {
      return true;
    }
    return false;
  }
}
