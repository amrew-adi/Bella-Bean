//Faheem

class Timer {

  int startTime;
  int currTime;
  int secElapsed;
  int endTime;
  int timeRemaining;

  /*Timer constructor
   pre: none
   post: none */
  Timer()
  {
    startTime = 0;
  }

  /*starts the timer
   pre: none
   post: none */
  void startTimer()
  {
    startTime = millis();
  }

  /*stops the timer
   pre: none
   post: none */
  void stopTimer()
  {
    endTime = timeRemaining;
  }

  /*show timer
   pre: none
   post: none */
  void show()
  {
    currTime = millis();
    secElapsed = (currTime - startTime)/1000;
    timeRemaining = secElapsed;

    if (timeRemaining > 0)
    {
      fill(255);
      textSize(30);
      if (timeRemaining > 1)
        text(toString(), 825, 950);
      else
        text(toString(), 825, 950);
    }
  }

  /*toString overides the println method
   pre: none
   post: returns information about the timer as a string */
  public String toString()//Step  #5
  {
    return timeRemaining + " sec";
  }

  /*accessor for the time
   pre: none
   post: reurns the current time when method invoked */
  public String getTime()
  {
    return Integer.toString(timeRemaining);
  }
}
