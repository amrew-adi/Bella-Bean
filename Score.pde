// Amrew

class Score {
  private String name;
  private int score;

  /* Default Score constructor
   pre: none
   post: none */
  Score() {
    name = "";
    score = 0;
  }

  /* Score constructor with parameters
   pre: none
   post: none */
  Score(String name, int score) {
    this.name = name;
    this.score = score;
  }

  /* Accessor method for name
   pre: none
   post: none */
  String getPlayerName() {
    return name;
  }

  /* Accessor for score
   pre: none
   post: none */
  int getScore() {
    return score;
  }

  /* Mutator for name
   pre: none
   post: none */
  void setPlayerName(String name) {
    this.name = name;
  }

  /* Mutator for score
   pre: none
   post: none */
  void setScore(int score) {
    this.score = score;
  }

  /* Method to print the score and name of the Score object
   pre: none
   post: none */
  String toString() {
    if (this.score == 1) {
      return this.name+"\t"+this.score+" second";
    } else {
      return this.name+"\t"+this.score+" seconds";
    }
  }
}
