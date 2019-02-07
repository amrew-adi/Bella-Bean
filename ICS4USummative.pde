/**
 * Authors: Amrew Adi and Faheem Warsalee
 * Course: ICS4U
 * Date: December 11, 2018
 * File Name: ICS4USummative
 * Description: ICS4U Summative with content encompassing the ICS4U curriculum.
 **/

//Fields in Memory 
import processing.sound.*;
PImage map, chr, menuBG, menuLogo, gridImg, treeImg, instructions, options, transparent, bossImg, enemyImg, boosterImg, healthBoosterImg, scoreboardBG, statsImg, gameOverImg, endImg;
SoundFile menuTheme, overworldTheme, changeOptionSound, goBackSound, acceptSound, boosterSound, gameOverTheme, hurtSound, swordSound, bossHurtSound;

//All arrays
Rectangle[][][] grid = new Rectangle[9][20][20];
Obstacle[] obstacles = new Obstacle[100];
Booster[] boosters = new Booster[10];
Enemy[] enemies = new Enemy[250];
Score[] scores = null;
String[] choices;

//All objects (not as arrays)
Char player;
Stats stats;
Rectangle pAtck = new Rectangle();
Recursion faheem = new Recursion();
Recursion amrew = new Recursion();
Timer timer = new Timer();

//Variables in memory
float frameX = -1000;
float frameY = -1000;
int choice = 0, opChoice = 0, randomX, randomY, score;
int counter = 1;
String playerName;
boolean playingGame, isUp, isRight, isDown, inMenu, inOptions, inInstruc, inScoreboard, inRecursion, sfxOff, musicOff, gameOver, beatGame, inRecursionA, inRecursionF;

/*Setup method
 pre: none
 post: none */
void setup()
{
  // Loading font
  PFont font = createFont("Minecraft.ttf", 30);//Changes the base font to a custom font
  textFont(font);
  playingGame = false;
  // Creating canvas of 1000 x 1000 pixels
  size(1000, 1000);

  //Imports all sounds and music
  menuTheme = new SoundFile(this, dataPath("menuTheme.wav"));
  changeOptionSound = new SoundFile(this, dataPath("changeOptionSound.wav"));
  overworldTheme = new SoundFile(this, dataPath("overworldTheme.wav"));
  goBackSound = new SoundFile(this, dataPath("goBackSound.wav"));
  acceptSound = new SoundFile(this, dataPath("acceptSound.wav"));
  boosterSound = new SoundFile(this, dataPath("boosterGetSound.wav"));
  gameOverTheme = new SoundFile(this, dataPath("gameOverTheme.wav"));
  hurtSound = new SoundFile(this, dataPath("hurtSound.wav"));
  swordSound = new SoundFile(this, dataPath("swordSound.wav"));
  bossHurtSound = new SoundFile(this, dataPath("bossHurtSound.wav"));

  playerName = "";
  score = 0;
  // Initially reading from scoreboard
  readScoreboard();
}

/*Draw method
 pre: none
 post: none */
void draw() {
  println("");
  // Check to see if game is being played
  if (playingGame) {
    if (player.isAlive())//Checks to see if player is alive
    {
      inMenu = false;
      menuTheme.stop();
      // Displays necessary visuals for playing the game
      image(map, frameX, frameY);
      showCell();
      player.show();
      timer.show();
      stats.show();
    } else { // Else means the game is being played and player is dead, in which case there is a game over
      gameOver = true;
      frameX = -1000;//reset frameX to 4th grid
      frameY = -1000;//reset frameY to 4th grid
      playingGame = false;
      overworldTheme.stop();
      image(gameOverImg, 0, 0);//Game over screen
    }
  } else if (inOptions) { //Options menu is open
    inMenu = false;
    toOptions();
  } else if (inInstruc) { //Instructions menu is open
    inMenu = false;
    toInstructions();
  } else if (inScoreboard) { //ScoreBoard menu is open
    inMenu = false;
    toScoreboard();
  } else if (inRecursion) { //Recursion menu is open
    inMenu = false;
    background(0);
    fill(255);
    textSize(30);
    text("PRESS 'F' FOR FAHEEM OR PRESS 'A' FOR AMREW", 120, 500);
    textSize(25);
    text("Psst! You can press the BACKSPACE key to go back!", 220, 25);
    if (inRecursionA) { // In Amrew's recursion
      toRecursionA();
    } else if (inRecursionF) { // In Faheem's recursion
      toRecursionF();
    }
  } else if (inRecursionA) {
    toRecursionA();//Plays amrews recursion
  } else if (inRecursionF) {
    toRecursionF();//Plays faheems recursion
  } else if (gameOver) { // On game over screen
    inMenu = false;
    if (!musicOff && !gameOverTheme.isPlaying()) {
      gameOverTheme.play(); // To ensure themes do not overlap
    }
    image(gameOverImg, 0, 0);
  } else if (beatGame) {// Game has been beat
    beatGame();
  } else {// Default condition means the player is in the main menu
    inMenu = true;
    mainMenu();
  }
}

/*Key Pressed
 pre: none
 post: none */
void keyPressed() {
  if (playingGame) {
    if ((keyCode == UP || key == 'w'|| key == 'W')) {//Moving up
      isRight = false;//direction is not right (booleans used to determine which picture for attacking is needed) (attacking picutre changes based off direction)
      isUp = true;//direction is up
      isDown = false;//direction is not down
      player.setImage("BB_UP.png");//changes image of the player to the up direction
      if (noObstacle(0)) {//determines if there is an obstacle above the player 
        player.move(0, -50);//allows player to move up
        checkForBooster();//checks to see if the player has landed on any boosters while moving up
      }
    } else if (keyCode == DOWN || key == 's'|| key == 'S') {
      isRight = false;//Player is not moving right
      isUp = false;//player is not moving up
      isDown = true;//player is moving down
      player.setImage("BB_DOWN.png");//set image of player to face down when moving down
      if (noObstacle(1))//checks for obstacles below the player
      {
        player.move(0, 50);//allows player to move down
        checkForBooster();//checks to see if the player has landed on any boosters
      }
    } else if (keyCode == RIGHT || key == 'd'|| key == 'D') {
      isUp = false;//player is not moving up
      isRight = true;//player IS moving right
      isDown = false;//player is not moving down
      player.setImage("BB_RIGHT.png");//sets players image to the right direction
      if (noObstacle(2)) {//checks to see if an obstacle is to the right of the player 
        player.move(50, 0);//allos player to move to the right when no obstacle is true
        checkForBooster();//checks to see if there is an booster at the spot the player has moved
      }
    } else if (keyCode == LEFT || key == 'a'|| key == 'A') {
      isUp = false;//player is not moving up
      isRight = false;//player is not moving to the right
      isDown = false;//player is not moving down
      player.setImage("BB_LEFT.png");//becuase all above is false the player has to be moving to left, sets image to the moving direction left
      if (noObstacle(3))//checks to see if there is an obstacle to the left of the player
      {
        player.move(-50, 0);//if not allow player to move to the left
        checkForBooster();//checks to see if the player has landed on a booster
      }
    } else if (key == 'p' || key == 'P')//checks to see if the player has pressed p
    {
      fileSave();//run file save method that will save the gridLocation and player location in a text file
    } else if (key == 'o' || key == 'O')//checks to see if the player has pressed o
    {
      loadSave();//read and use the data from the save file to change the players position on the map
    }

    //ATTACKING
    if (isUp && key == ' ')//player is facing up
    {
      player.setImage("ATCK_UP.png");//players image is set to attacking and up
      setAtckRect(0, -50);//place the attacking rectangle above the player
    } else if (!isUp && isRight && key == ' ')//player is facing to the right
    {
      player.setImage("ATCK_RIGHT.png");//set image to the player attacking to the right
      setAtckRect(50, 0);//places attacking rectangle to the right of the player
    } else if (isDown && key == ' ')//Player is facing down
    {
      player.setImage("ATCK_DOWN.png");//sets players image to an image of the player attacking down
      setAtckRect(0, +50);//Places the attacing rectange below the player
    } else if (!isRight && key == ' ')//player is facing to the left
    {
      player.setImage("ATCK_LEFT.png");//sets image to that of the player attacking to the left
      setAtckRect(-50, 0);//places the attacking rectangle to the left of the player
    }
  } else {//Player is not in the game
    if (inMenu) { // Player is in the main menu
      if (keyCode == UP || key == 'w') { // Pressing up or w will increment the choice, moving the option up
        if (choice > 0) {
          if (!sfxOff) {
            changeOptionSound.play();
          }
          choice--;
        }
      } else if (keyCode == DOWN || key == 's') { // Pressing down or s will increment the choice, moving the option down
        if (choice < choices.length - 1) {
          if (!sfxOff) {
            changeOptionSound.play();
          }
          choice++;
        }
      }
      if (keyCode == ENTER) { // Current selected choice is selected
        switch (choice) {
        case 0: // Choice = play game
          {
            if (!sfxOff) {
              acceptSound.play();
            }
            playGame();
            playingGame = true;
            break;
          }
        case 1: // Choice = options
          {
            if (!sfxOff) {
              acceptSound.play();
            }
            inOptions = true;
            toOptions();
            break;
          }
        case 2: // Choice = instructions
          {
            if (!sfxOff) {
              acceptSound.play();
            }
            inInstruc = true;
            toInstructions();
            break;
          }
        case 3: // Choice = scoreboard
          {
            if (!sfxOff) {
              acceptSound.play();
            }
            inScoreboard = true;
            toScoreboard();
            break;
          }
        case 4: // Choice = recursion
          {
            if (!sfxOff) {
              acceptSound.play();
            }
            inRecursion = true;
            break;
          }
        }
      }
    } else if (inOptions) { // Player is in options
      if (keyCode == UP || key == 'w' || keyCode == DOWN || key == 's') { // Increment choice up or down (it is the same because there are only two)
        if (opChoice == 0) {
          if (!sfxOff) {
            changeOptionSound.play();
          }
          opChoice++;
        } else if (opChoice == 1) {
          if (!sfxOff) {
            changeOptionSound.play();
          }
          opChoice--;
        }
      } else if (keyCode == ENTER) { // Current choice is selected
        // Multitude of checks for 4 possibilities with sound effects and music being on or off
        if (!sfxOff && opChoice == 0) {
          boosterSound.play();
          sfxOff = true;
        } else if (sfxOff && opChoice == 0) {
          sfxOff = false;
        } else if (!musicOff && opChoice == 1) {
          if (!sfxOff) {
            boosterSound.play();
          }
          musicOff = true;
          menuTheme.stop();
        } else if (musicOff && opChoice == 1) {
          if (!sfxOff) {
            boosterSound.play();
          }
          musicOff = false;
          if (!menuTheme.isPlaying()) {
            menuTheme.loop();
          }
        }
      }
    } else if (inRecursion) { // Player is in recursion choice
      switch (key) {
      case 'f': // Faheem's recursion
        {
          toRecursionF();
          break;
        }
      case 'a': // Amrew's recursion
        {
          toRecursionA();
          break;
        }
      }
    } else if (beatGame) { // If the game has been beaten, then accept all letters (upper or lower case) as input
      if (keyCode >= 65 && keyCode <= 90) {
        if (playerName.length() < 5) { // Letters are added to a String playerName if the String's length does not exceed 5
          playerName += key;
        }
      } else if (keyCode == BACKSPACE && playerName.length() > 0) { // If backspace is entered, delete the last letter of the String
        playerName = playerName.substring(0, playerName.length() - 1);
      } else if (keyCode == ENTER && beatGame) { // If enter is pressed, the name is confirmed and writeScoreboard writes the name and score to the file
        if (playerName.length() > 0) {
          writeScoreboard();
          beatGame = false; // Now that the beatGame screen is over, the game goes back to the main menu
          mainMenu();
        }
      }
    }
  }

  if (keyCode == BACKSPACE && !beatGame) { // If backspace is ever entered anywhere but when beatGame is true, return to the main menu
    if (!sfxOff) {
      goBackSound.play();
    }
    inOptions = false;
    inInstruc = false;
    inScoreboard = false;
    gameOver = false;
    inRecursion = false;
    inRecursionA = false;
    inRecursionF = false;
    if (gameOverTheme.isPlaying()) // Stop the gameOver theme if it is playing
      gameOverTheme.stop();
    mainMenu();
  }
}

/*PlayGame method
 pre: none
 post: none */
void playGame() {
  // Loads all images
  map = loadImage("map.png");
  chr = loadImage("BB_UP.png");
  treeImg = loadImage("tree.png");
  transparent = loadImage("transparent.png");
  bossImg = loadImage("BOSS_DWN.png");
  enemyImg = loadImage("ENMY_DWN.png");
  boosterImg = loadImage("booster.png");
  healthBoosterImg = loadImage("healthbooster.png");
  statsImg = loadImage("statsBar.png");
  gameOverImg = loadImage("GAMEOVER.png");

  timer.startTimer();// Starts the timer
  overworldTheme.play();// Plays the overworld music

  Rectangle pRect = new Rectangle(width/2, height/2, 50, 50, "player");// Create the player's rectangle
  player = new Char(pRect, 1000, 1000, chr);// Create the player object
  enemies[249] = new Enemy(5*50, 7*50, 50, 50, "enemy", 5000, 3000, bossImg, 0);// Create the final boss object

  stats = new Stats(player.atk, player.hp, statsImg); // Creates a Stat object with the player's attack and health

  //Creates the objects for the grid
  for (int k = 0; k < grid.length; k ++)//traverses first dimension of array
  {
    for (int i =  0; i < grid[k].length; i++)//traverses the second dimension of array
    {
      for (int j= 0; j < grid[k][i].length; j++)//traverses the third dimension of the rray
      {
        grid[k][i][j] = new Rectangle(j*50, i*50, 50, 50, "");//sets the grid at each dimenstion to a rectangle
      }
    }
  }

  setEnemies();//creates and sets enemies throughout the map
  setBoosters();//creates and places boosters throughout the ap
  setObstacles();//sets all trees to the outside of the perimeter of the 3x3
}

/* Main Menu method (goes to the main menu screen)
 pre: none
 post: none */
void mainMenu() {
  if (!menuTheme.isPlaying()) {
    if (gameOverTheme.isPlaying()) { // Loops menu theme and stops gameOver theme
      gameOverTheme.stop();
    }
    menuTheme.loop();
  }
  fill(0, 102, 153);
  inMenu = true;
  // Creating array to contain and for displaying of possible choices
  choices = new String[5];
  choices[0] = new String("PLAY GAME");
  choices[1] = new String("OPTIONS");
  choices[2] = new String("INSTRUCTIONS");
  choices[3] = new String("SCOREBOARD");
  choices[4] = new String("RECURSION");

  // Displays menu background and logo
  menuBG = loadImage("menuBG.png");
  menuLogo = loadImage("logo.png");
  background(255);
  image(menuBG, 0, 0);
  image(menuLogo, 280, 5, 460, 230);
  textSize(30);

  switch (choice) {
  case 0: // Choice = play game
    {
      // Only highlights first choice
      fill(235);
      text(choices[0], 390, 260);
      fill(0, 102, 153);
      text(choices[1], 390, 310);
      text(choices[2], 390, 360);
      text(choices[3], 390, 410);
      text(choices[4], 390, 460);
      break;
    }
  case 1: // Choice = options
    {
      // Only highlights second choice
      text(choices[0], 390, 260);
      fill(235);
      text(choices[1], 390, 310);
      fill(0, 102, 153);
      text(choices[2], 390, 360);
      text(choices[3], 390, 410);
      text(choices[4], 390, 460);
      break;
    }
  case 2: // Choice = instructions
    {
      // Only highlights third choice
      text(choices[0], 390, 260);
      text(choices[1], 390, 310);
      fill(235);
      text(choices[2], 390, 360);
      fill(0, 102, 153);
      text(choices[3], 390, 410);
      text(choices[4], 390, 460);
      break;
    }
  case 3: // Choice = scoreboard
    {
      // Only highlights fourth choice
      text(choices[0], 390, 260);
      fill(0, 102, 153);
      text(choices[1], 390, 310);
      text(choices[2], 390, 360);
      fill(235);
      text(choices[3], 390, 410);
      fill(0, 102, 153);
      text(choices[4], 390, 460);
      break;
    }
  case 4: // Choice = recursion
    {
      // Only highlights last choice
      text(choices[0], 390, 260);
      fill(0, 102, 153);
      text(choices[1], 390, 310);
      text(choices[2], 390, 360);
      text(choices[3], 390, 410);
      fill(235);
      text(choices[4], 390, 460);
      fill(0, 102, 153);
      break;
    }
  }
}

/*to Options method (goes to the options screen)
 pre: none
 post: none */
void toOptions() {
  // Displays options background image
  options = loadImage("options.png");
  image(options, 0, 0);

  // Displays text
  textSize(20);
  fill(255);
  text("Psst! You can press the BACKSPACE key to go back!", 250, 22);
  fill(0, 102, 153);

  textSize(60);

  // Checks which option is selected
  switch(opChoice) {
  case 0: // Choice highlighted = sound effects
    {
      fill(255);
      text("Sound Effects -", 190, 300);
      fill(0, 102, 153);
      text("Music -", 460, 500);
      if (!sfxOff) { // Sfx off
        fill(0, 255, 0);
        text("ON", 685, 300);
        fill(255);
        if (!musicOff) { // Sfx off and music off
          fill(0, 255, 0);
          text("ON", 685, 500);
          fill(0, 102, 153);
        } else { // Sfx off and music on
          fill(0, 102, 153);
          text("OFF", 685, 500);
          fill(0, 102, 153);
        }
      } else { // Sfx on
        fill(0, 102, 153);
        text("OFF", 685, 300);
        if (!musicOff) { // Sfx on and music on
          fill(0, 255, 0);
          text("ON", 685, 500);
          fill(0, 102, 153);
        } else { // Sfx on and music off
          fill(0, 102, 153);
          text("OFF", 685, 500);
          fill(0, 102, 153);
        }
        fill(255);
      }
      break;
    }
  case 1: // Choice highlighted = music
    {
      fill(0, 102, 153);
      text("Sound Effects -", 190, 300);
      fill(255);
      text("Music -", 460, 500);
      if (!musicOff) { // Music on
        fill(0, 255, 0);
        text("ON", 685, 500);
        fill(0, 102, 153);
        if (!sfxOff) { // Music on and sfx on
          fill(0, 255, 0);
          text("ON", 685, 300);
          fill(0, 102, 153);
        } else { // Music on and sfx off
          fill(0, 102, 153);
          text("OFF", 685, 300);
          fill(0, 102, 153);
        }
      } else { // Music off
        fill(0, 102, 153);
        text("OFF", 685, 500);
        if (!sfxOff) { // Music off and sfx on
          fill(0, 255, 0);
          text("ON", 685, 300);
          fill(0, 102, 153);
        } else { // Music off and sfx off
          fill(0, 102, 153);
          text("OFF", 685, 300);
          fill(0, 102, 153);
        }
        fill(0, 102, 153);
      }
      break;
    }
    // Default choice
  default: 
    {
      break;
    }
  }
}

/*to Instructions method (goes to the instructions screen)
 pre: none
 post: none */
void toInstructions() {
  // Display the instructions background image
  instructions = loadImage("instructions.png");
  image(instructions, 0, 0);

  // Show a piece of text
  textSize(60);
  fill(255);
  text("BACKSPACE -", 180, 680);
  fill(152, 255, 152);
  text("Go back", 610, 680);
  fill(0, 102, 153);
}

/*Shows the scoreboard
 pre: none
 post: none */
void toScoreboard() {
  readScoreboard(); // Reading scoreboard
  scoreboardBG = loadImage("scoreboardBG.png");
  image(scoreboardBG, 0, 0);

  textSize(60);
  fill(50);
  text("SCOREBOARD", 275, 100);
  textSize(50);
  text("RANK", 150, 200);
  text("NAME", 450, 200);
  text("TIME", 750, 200);

  // Simply printing the rank numbers 1-10, with 1st, 2nd and 3rd having respective suffixes and colours
  for (int i = 1; i < 11; i++) {
    textSize(30);
    if (i == 1) {
      fill(221, 201, 44);
      text("1st", 150, i * 50 + 200);
    } else if (i == 2) {
      fill(186, 183, 161);
      text("2nd", 150, i * 50 + 200);
    } else if (i == 3) {
      fill(132, 121, 31);
      text("3rd", 150, i * 50 + 200);
    } else {
      fill(50);
      text(i + "th", 150, i * 50 + 200);
    }
  }

  if (scores != null) { // Printing scores if scores exist
    bubbleSort(scores); // Sorts scores least to greatest
    for (int i = 0; i < scores.length; i++) {
      if (i < 10) {
        text(scores[i].getPlayerName(), 450, (i + 5) * 50);
        text(scores[i].getScore() + " seconds", 750, (i + 5) * 50);
      }
    }
  }

  // Displaying text
  textSize(25);
  fill(0);
  text("Psst! You can press the BACKSPACE key to go back!", 220, 25);
  fill(0, 102, 153);
}

/* Displays Amrew's recursion
 pre: none
 post: none */
void toRecursionA() {
  inRecursion = false;
  inRecursionA = true;
  amrew.showRecursion('a');
}

/* Displays Faheem's recursion
 pre: none
 post: none */
void toRecursionF() {
  inRecursion = false;
  inRecursionF = true;
  faheem.showRecursion('f');
}

/* beatGame method displays text to ask for user input for name and ends all necessary functions
 pre: none
 post: none */
void beatGame() {
  // Ends timer when beatGame is called to save the time at which the game was beaten
  timer.stopTimer();
  // Assigns the time to score
  score = timer.endTime;
  // Stops the overworld theme from playing
  overworldTheme.stop();
  if (!musicOff && !gameOverTheme.isPlaying()) {
    gameOverTheme.loop(); // Plays the gameover theme
  }
  playingGame = false;
  beatGame = true;
  // Displays the endgame image
  endImg = loadImage("endScreen.png");
  image(endImg, -100, -100, 1300, 1300);
  // Displays text to ask for user input
  fill(255);
  textSize(50);
  text("Linseman has been defeated!", 175, 100);
  text("Thanks for playing!", 300, 150);
  if (score == 1) {
    text("Time:  " + score + " second", 100, 300);
  } else {
    text("Time:  " + score + " seconds", 100, 300);
  }
  text("Enter Your Name (1 - 5 characters):  ", 50, 400);
  text(playerName + "_", 50, 500);
}

/*showCell method
 pre: frameX and frameY < 0 && frameX and frameY > -2000
 post: none */
void showCell()
{
  switch(gridLoc())//Is the current gridLocation
  {
  case 0://Cell 0: top left
    {
      showGrid(0);//shows top left grid
      grid[0][5][7] = enemies[249];//set the boss to an grid space always in grid[0]
      break;
    } 
  case 1://cell 1: top middle
    {
      showGrid(1);//show top midll grid
      break;
    } 
  case 2://cell 2: top right
    {
      showGrid(2);//shows top right grid
      break;
    } 
  case 3://cell 3 middle left
    {
      showGrid(3);//middle left grid
      break;
    } 
  case 4://cell 4: middle middle
    {
      showGrid(4);//shows middle middle grid
      break;
    } 
  case 5://cell 5: middle right
    {
      showGrid(5);//shows middle right grid
      break;
    } 
  case 6://cell 6: bottom left
    {
      showGrid(6);//shows bottom left grid
      break;
    } 
  case 7://cell 7: bottom middle
    {
      showGrid(7);//shows bottom middle grid
      break;
    } 
  case 8://cell 8: bottom right
    {
      showGrid(8);//shows the bottom right grid
      break;
    }
  }
}



/* checks players surrounding for obstacles
 pre: none
 post: returns true if there isnt an obstacle in the way of the player and false if there is */
boolean noObstacle(int direction) {
  switch(direction) {
  case 0: // Direction "up"
    {
      if ((gridLoc() == 0 || gridLoc() == 1 || gridLoc() == 2) && player.top <= 50) //Only if not on top row
      {
        return false;//player cannot go past the top rown in grids [0][1] & [2]
      } else if (player.top != 0 && (grid[gridLoc()][(player.left/50)][player.top/50 - 1].getRecName().equals("obstacle"))) {//checks to see if the space above the player is an obstacle
        return false;//player will intersect with an obstacle that is above them
      }
      for (int i =0; i < enemies.length; i++)
      {
        if (enemies[i].isAlive() && player.top != 0 && enemies[i].getGridLoc() == gridLoc() && enemies[i].equals(player.left, player.top-50))//check to see if the spot above the player is an enemy
        {
          player.hp -= enemies[i].atk;//reduce players health if it is
          if (!sfxOff)
            hurtSound.play();//play hurt sound effect
          stats.setHp(player.hp);//change the stats bar to reflect players health change
          return false;//player cannot walk through enemies
        }
      }
      return true;
    }
  case 1: // Direction "down"
    {
      if ((gridLoc() == 6 || gridLoc() == 7 || gridLoc() == 8) && player.top >= 900) //Only if not on bottom row
      {
        return false;//player cannot go past the bottom row in grids [6][7][8]
      } else if (player.top != 950 && (grid[gridLoc()][(player.left/50)][player.top/50 + 1].getRecName().equals("obstacle"))) {//check for an obstacle below the player
        return false;//if there is dont allow player to walk through it
      } 
      for (int i =0; i < enemies.length; i++)//check the whole enemies array
      {
        if (player.top != 950 && enemies[i].getGridLoc() == gridLoc() && enemies[i].equals(player.left, player.top+50) && enemies[i].isAlive())//check if there is an enemy below the player 
        {
          player.hp -= enemies[i].atk;//player will hit the enemy so reduce health
          if (!sfxOff)
            hurtSound.play();//play hurt sound
          stats.setHp(player.hp);//change stat bar to reflect change
          return false;//player cannot walk through the enemy
        }
      }
      return true;
    }
  case 2: // Direction "right"
    {
      if ((gridLoc() == 2 || gridLoc() == 5 || gridLoc() == 8) && player.left >= 900) //Only if not on far right column
      {
        return false;//player cannot walk past the far right in grids [2][5][8]
      } else if (player.left != 950 && (grid[gridLoc()][player.left/50 + 1][player.top/50].getRecName().equals("obstacle"))) {//check for an obstacle to the right of the enemy
        return false;//dont allow player to move
      }
      for (int i =0; i < enemies.length; i++)//search enemies array
      {
        if (player.left != 950 && enemies[i].getGridLoc() == gridLoc() && enemies[i].equals(player.left+50, player.top) && enemies[i].isAlive())//did the player walk into an enemy on its right
        {
          player.hp -= enemies[i].atk;//player hit an enemy reduce health
          if (!sfxOff)
            hurtSound.play();//play sound
          stats.setHp(player.hp);//change stats to reflect changes in health
          return false;
        }
      }
      return true;
    }
  case 3: // Direction "left"
    {
      if ((gridLoc() == 0 || gridLoc() == 3 || gridLoc() == 6) && player.left <= 50) //Only if not on far left column
      {
        return false;//player cannot walk past the far left in grids[0][3][6]
      } else if (player.left != 0 && (grid[gridLoc()][player.left/50 - 1][player.top/50].getRecName().equals("obstacle"))) {//has the player intersected with an obstacle on its left
        return false;//dont allow player to walk through
      } 
      for (int i =0; i < enemies.length; i++)//search enemies array
      {
        if (player.left != 0 && enemies[i].getGridLoc() == gridLoc() && enemies[i].equals(player.left-50, player.top) && enemies[i].isAlive())//has the player has hit an enemy
        {
          player.hp -= enemies[i].atk;//reduce players health if hit
          if (!sfxOff)
            hurtSound.play();//play hur sound effect
          stats.setHp(player.hp);//change stats to reflect change in hp
          return false;
        }
      }
      return true;
    }
  default:
    {
      return true;
    }
  }
}

/*checks to see if the player's attack hits an enemy and reduces the enemies hp 
 pre: none
 post: none */
void attack()
{
  if (player.top != 0 && grid[gridLoc()][pAtck.left/50][pAtck.top/50].getRecName().equals("enemy"))//checks to see if the players attacking rectangle is at the same location of an enemy
  {
    for (int i =0; i < enemies.length; i ++)//search the enemies array
    {
      if (enemies[i].equals(pAtck) && enemies[i].getGridLoc() == gridLoc() && enemies[i].isAlive())//check to see if the enemy and the attacking rectangle are in the same spots (grid and pixel location)
      {
        if (!sfxOff)
          swordSound.play();//player has hit the enemy so play sound
        if (!sfxOff && i == 249)
          bossHurtSound.play();//if the player has hit the boss make boss cry
        enemies[i].hp -= player.atk;//reduce the health from the enemy that has been hit
        if (!enemies[i].isAlive())//if the enemy is no longer alive
        {
          enemies[i].kill();//remove him from the map
        }
      } else if (!enemies[i].isAlive())
      {
        enemies[i].kill();//remove dead enemy
      }

      if (!enemies[249].isAlive())//if the boss is dead
      {
        beatGame = true;//player has beat the game
        beatGame();//send them to the winning screen
      }
    }
  }
}

/* Checks to see if the player's location is equal to that of a booster, consumes booster if true
 pre: none
 post: none */
void checkForBooster() {
  // Sequential search that searches the booster array
  for (int i = 0; i < boosters.length; i++) {
    // Checks if the booster at i's location is equal to that of the player
    if (boosters[i].equals(player) && gridLoc() == boosters[i].getGridLoc() && !boosters[i].isUsed()) {
      // Use boost on player, either atk or hp based on the boostType of the booster at i
      player.boost(boosters[i].getBoostVal(), boosters[i].getBoostType());
      // Updates the stats's atk and hp to be displayed
      stats.setAtk(player.atk);
      stats.setHp(player.hp);
      // Consumes booster at i so that it disappears from the map and cannot be used again
      boosters[i].consumed();
      if (!sfxOff) {
        boosterSound.play();
      }
    }
  }
}

/*grid Location
 pre: none
 post: retunrs a value from 0-8 representing the main grid location */
int gridLoc() {
  if (frameX == 0 && frameY ==0) { //Cell 0: top left
    return 0;
  } else if (frameX == -1000 && frameY == 0) { //Cell 1: top middle
    return 1;
  } else if (frameX == -2000 && frameY == 0) { //Cell 2: top right
    return 2;
  } else if (frameX == 0 && frameY == -1000) { //Cell 3 middle left
    return 3;
  } else if (frameX == -1000 && frameY == -1000) { //Cell 4: middle middle
    return 4;
  } else if (frameX == -2000 && frameY == -1000) { //Cell 5: middle right
    return 5;
  } else if (frameX == 0 && frameY == -2000) { //Cell 6: bottom left
    return 6;
  } else if (frameX == -1000 && frameY == -2000) { //Cell 7: bottom middle
    return 7;
  } else if (frameX == -2000 && frameY == -2000) { //Cell 8: bottom right
    return 8;
  } else {
    return 4;//default assume player is in the middlegrid
  }
}

/*Shows all the rectangle/grid spaces in each main grid.
 pre: quad is a number between 0 and 8
 post: none */
void showGrid(int quad)
{
  for (int i = 0; i < grid[8].length; i ++)
  {
    for (int j = 0; j < grid[8][i].length; j ++)
    {
      grid[quad][i][j].show();//displays the entire grid of the where the player is situated
    }
  }
}

/*writes to scoreboard
 pre: none
 post: none */
void writeScoreboard() {
  String[] scores = loadStrings("scoreboard.txt"); // Loading the scoreboard into a String array
  String[] newScores = new String[scores.length+1]; // Creating a new array with the added score
  for (int i = 0; i < scores.length; i++) {
    newScores[i] = scores[i]; // Initializing previous scoreboard values
  }
  newScores[scores.length] = playerName + "\t" + score; // Adding the new player score
  saveStrings("scoreboard.txt", newScores); // Saving to the text file
  playerName = "";
  score = 0;
}

/* bubbleSort to sort the scores array from least to greatest
 pre: none
 post: none */
void bubbleSort(Score arr[])
{
  int n = arr.length;
  for (int i = 0; i < n-1; i++)
    for (int j = 0; j < n-i-1; j++)
      if (arr[j].getScore() > arr[j+1].getScore()) {
        // swap temp and arr[i]
        int temp = arr[j].getScore();
        String tempS = arr[j].getPlayerName();

        arr[j].setScore(arr[j+1].getScore());
        arr[j+1].setScore(temp);
        arr[j].setPlayerName(arr[j+1].getPlayerName());
        arr[j+1].setPlayerName(tempS);
      }
}

/*reads the scoreboard file
 pre: none
 post: none */
void readScoreboard() {
  BufferedReader reader = createReader("scoreboard.txt"); // Creating a buffered reader to read the lines from the file
  try {
    String[] scoreboardList = loadStrings(reader); // Creates an array from the scoreboard with a length of the lines in the file
    scores = new Score[scoreboardList.length]; // Initializing scores
    for (int i = 0; i < scores.length; i++) {
      scores[i] = new Score();
    }
    for (int i = 0; i < scores.length; i++) { // Setting values to the scores from the scoreboard
      String[] splitString = split(scoreboardList[i], TAB);
      scores[i].setPlayerName(splitString[0]); // Dividing the String and integer portions
      scores[i].setScore(Integer.parseInt(splitString[1]));
    }
  } 
  // Exception handling
  catch(NumberFormatException e) {
    println("An error occurred while parsing scoreboard information from String to integer.");
    e.printStackTrace();
  } 
  catch (NullPointerException e) {
    println("Writing new file.");
    PrintWriter output = createWriter("scoreboard.txt");
    output.flush();
    output.close();
  }
  catch(Exception e) {
    println("An error occurred in loading the scoreboard.");
    e.printStackTrace();
  }
}

/*creates the saveGame.txt file
 pre: none
 post: none */
void fileSave()
{

  try
  {
    //creating printwriter and buffered reader
    PrintWriter fileData = createWriter("saveGame.txt");
    BufferedReader br = createReader("saveGame.txt");

    br.readLine();//reads file to see if a file is created

    printToFile(fileData);//prints data to file
  }
  catch(Exception e)
  {
    PrintWriter  output = createWriter("saveGame.txt");//Creates file if the file is not created
    printToFile(output);//prints data to file
  }
}

/*does the printing to the saveGame.txt file
 pre: a printwriter has been made
 post: none */
void printToFile(PrintWriter output)
{
  String[] data = new String[4];
  data[0] =  Float.toString(frameX);//holds frameX data when saved as a string
  data[1] =  Float.toString(frameY);//holds frameY datat when saved as a string
  data[2] = Integer.toString(player.left);//holds players left when saved as a string
  data[3] = Integer.toString(player.top);//holds players top when saved as a string

  for (int i =0; i < data.length; i++)
  {
    output.println(data[i]);//prints all strings fro mthe array to the file
  }
  output.flush();
  output.close();//closes the printwriter
} 


/*reads saveGame.txt file and sets the saved game data to the new data
 pre: none
 post: none */
void loadSave()
{
  try {
    BufferedReader br = createReader("saveGame.txt");
    String readFile;//will be the contents of the file

    readFile = br.readLine();//readline
    frameX = Float.parseFloat(readFile);//sets frameX to the first line value as floats
    readFile = br.readLine();//readline
    frameY = Float.parseFloat(readFile);//sets frameY to the 2nd line value as floats
    readFile = br.readLine();//readline
    player.left = Integer.parseInt(readFile);//sets players left to the third line value as int
    readFile = br.readLine();//readline
    player.top = Integer.parseInt(readFile);//sets players top to the 4ht line value as int
    readFile = br.readLine();//readline

    br.close();//close buffered reader
  }
  catch(Exception e)
  {
    println("could not read from file 'saveGame.txt' ");//exception caught
  }
}

/* Method to set boosters around the map randomly
 pre: none
 post: none */
void setBoosters() {
  // Creating an integer to hold the random grid location
  int rngGridLoc;
  for (int i = 0; i < boosters.length; i ++) {
    int boostType = (int)random(1, 3);
    do
    {
      rngGridLoc = (int)random(0, 9); // generating a random number between 0 and 8 (9 is not inclusive)
    }
    while (rngGridLoc ==6); // Only allow the int to be created if it is not in grid location 6 to avoid being placed on water
    if (boostType == 1) { // BoostType = attack booster
      // Creates boosters at random locations throughout the map, but only in increments of 50
      boosters[i] = new Booster((int)random(1, 18) * 50, (int)random(1, 18) * 50, 50, 50, rngGridLoc, boosterImg, boostType);
    } else { // BoostType == health booster
      // Creates boosters at random locations throughout the map, but only in increments of 50
      boosters[i] = new Booster((int)random(1, 18) * 50, (int)random(1, 18) * 50, 50, 50, rngGridLoc, healthBoosterImg, boostType);
    }
    // Setting the boosters from the array into the grid at each of the random locations
    grid[boosters[i].getGridLoc()][boosters[i].getLeft()/50][boosters[i].getTop()/50] = boosters[i];
  }
}


/* Places random trees in grid[1],grid[3],grid[4],grid[5],grid[7],grid[8]
 pre: none
 post: none */
void randomTrees()
{
  do {
    randomX = (int)random(1, 18);//random values to avoid edges of the map
    randomY =(int)random(1, 18);//random values to avoid edges of the map
    obstacles[1] = new Obstacle(randomX*50, randomY*50, 50, 50, treeImg, "obstacle");//creates obstacles with tree img
    grid[4][randomX][randomY] = obstacles[1];
    counter++;//increase counter by 1
  } while (counter <= 12);//Sets 12 randoomly placed trees in the 4th grid

  for (int i =1; i <= 12; i++) {
    randomX = (int)random(1, 18);//random values to avoid edges of the map
    randomY =(int)random(1, 18);//random values to avoid edges of the map
    obstacles[1] = new Obstacle(randomX*50, randomY*50, 50, 50, treeImg, "obstacle");//creates obstacles with tree img
    grid[1][randomX][randomY] = obstacles[1];
  }//sets 12 randomly placed trees in grid 1

  for (int i =1; i <= 24; i++) {
    randomX = (int)random(1, 18);//random values to avoid edges of the map
    randomY =(int)random(1, 18);//random values to avoid edges of the map
    obstacles[1] = new Obstacle(randomX*50, randomY*50, 50, 50, treeImg, "obstacle");//creates obstacles with tree img
    grid[3][randomX][randomY] = obstacles[1];
  }//Sets 24 randomly placed trees in grid 3

  for (int i =1; i <= 10; i++) {
    randomX = (int)random(1, 18);//random values to avoid edges of the map
    randomY =(int)random(1, 18);//random values to avoid edges of the map
    if (!(grid[5][randomX][randomY].getRecName().equals("obstacle")));
    {
      obstacles[1] = new Obstacle(randomX*50, randomY*50, 50, 50, treeImg, "obstacle");//creates obstacles with tree img
      grid[5][randomX][randomY] = obstacles[1];
    }
  }//sets 10 randomly placed trees in grid 5

  for (int i =1; i <= 16; i++) {
    randomX = (int)random(1, 18);//random values to avoid edges of the map
    randomY =(int)random(1, 18);//random values to avoid edges of the map
    obstacles[1] = new Obstacle(randomX*50, randomY*50, 50, 50, treeImg, "obstacle");//creates obstacles with tree img
    grid[7][randomX][randomY] = obstacles[1];
  }//Sets 16 randomly placed trees in grid 7

  for (int i =1; i <= 10; i++) {
    randomX = (int)random(1, 18);//random values to avoid edges of the map
    randomY =(int)random(1, 18);//random values to avoid edges of the map
    obstacles[1] = new Obstacle(randomX*50, randomY*50, 50, 50, treeImg, "obstacle");//creates obstacles with tree img
    grid[8][randomX][randomY] = obstacles[1];
  }//Sets 10 ranomly placed trees in grid 8
}

/*setTrees Method
 pre: none
 post: none */
void setObstacles()
{ 
  //Horizontal top Trees
  for (int i =0; i < grid[0].length; i ++)
  { 
    obstacles[i] = new Obstacle(i*50, 0, 50, 50, treeImg, "");//creates trees at the top of the map
    grid[0][0][i] = obstacles[i];//Grid 0 Top
    grid[1][0][i] = obstacles[i];//Grid 1 Top
    grid[2][0][i] = obstacles[i];//Grid 2 Top
  } 

  //Vertical Left Trees
  for (int i =0; i < grid[0].length; i ++)
  {
    obstacles[i] = new Obstacle(0, i*50, 50, 50, treeImg, "");//creates trees at the left of the map
    grid[0][i][0] = obstacles[i];//Grid 0 Vertical
    grid[3][i][0] = obstacles[i];//Grid 3 Vertical
    grid[6][i][0] = obstacles[i];//Grid 6 Vertical
  }

  //Vertical right Tress
  for (int i =0; i < grid[2].length; i ++)
  {
    obstacles[i] = new Obstacle(950, i*50, 50, 50, treeImg, "");//creates trees at the right of the map
    grid[2][i][19] = obstacles[i];//Grid 2 Vertical
    grid[5][i][19] = obstacles[i];//Grid 5 Vertical
    grid[8][i][19] = obstacles[i];//Grid 8 Vertical
  }

  //Horizontal bottom Trees
  for (int i =0; i < grid[6].length; i ++)
  {
    obstacles[i] = new Obstacle(i*50, 950, 50, 50, treeImg, "");//creates trees at the bottom of the map
    grid[6][19][i] = obstacles[i];//Grid 6 Bottom
    grid[7][19][i] = obstacles[i];//Grid 7 Bottom
    grid[8][19][i] = obstacles[i];//Grid 8 Bottom
  }

  setHouses();//creates and places house obstacles 
  setLava();//makes lava on the map an obstacle
  setWater();//makes water on the map an obstacle
  randomTrees();//creates and places random trees throughought the map
}

/*creates and places enemies at random in the world
 pre: none
 post: none */
void setEnemies()
{
  int rngGridLoc;//random grid location for each enemy

  for (int i = 0; i < enemies.length -1; i++) {
    randomX = (int)random(1, 18);//random x for each enemy
    randomY =(int)random(1, 18);//random y for each enemy
    do
    {
      rngGridLoc = (int)random(0, 9);
    }
    while (rngGridLoc == 6);//do not place any enemies in grid 6 (water)
    enemies[i] = new Enemy(randomX*50, randomY*50, 50, 50, "enemy", 1000, 100, enemyImg, rngGridLoc);//create the random enemy
    grid[enemies[i].getGridLoc()][enemies[i].left/50][enemies[i].top/50] = enemies[i];//set the enemy to a grid location
  }
}

/*sets all house walls from the map to in-game obstacles
 pre: none
 post: none */
void setHouses()
{
  //Main Boss House all hard-coded values for creating obstacles 
  obstacles[0] = new Obstacle(50, 50, 50, 50, transparent, "obstacle");//create the obstacle
  for (int i = 3; i < 15; i++)
  {
    grid[0][i][5] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 6; i < 13; i++)
  {
    grid[0][3][i] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 3; i < 8; i++)
  {
    grid[0][i][12] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 13; i < 16; i ++)
  {
    grid[0][7][i] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 7; i < 12; i++)
  {
    grid[0][i][15] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 12; i < 16; i ++)
  {
    grid[0][11][i] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 12; i< 15; i ++)
  {
    grid[0][i][12] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 5; i < 8; i++)
  {
    grid[0][14][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 10; i < 12; i++)
  {
    grid[0][14][i] = obstacles[0];//setting grid location to an obstacle
  }

  //Grid 5 broken house
  grid[5][9][6] = obstacles[0];//setting grid location to an obstacle
  grid[5][9][8] = obstacles[0];//setting grid location to an obstacle
  grid[5][9][9] = obstacles[0];//setting grid location to an obstacle
  grid[5][10][11] = obstacles[0];//setting grid location to an obstacle
  grid[5][10][12] = obstacles[0];//setting grid location to an obstacle
  grid[5][15][11] = obstacles[0];//setting grid location to an obstacle
  grid[5][17][12] = obstacles[0];//setting grid location to an obstacle
  grid[5][17][13] = obstacles[0];//setting grid location to an obstacle
  grid[5][18][8] = obstacles[0];//setting grid location to an obstacle
  grid[5][18][9] = obstacles[0];//setting grid location to an obstacle
  grid[5][17][6] = obstacles[0];//setting grid location to an obstacle
  grid[5][10][5]= obstacles[0];//setting grid location to an obstacle
  grid[5][11][5] = obstacles[0];//setting grid location to an obstacle
  for (int i = 14; i < 17; i++)
  {
    grid[5][i][5] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 12; i < 15; i++)
  {
    grid[5][i][4] = obstacles[0];//setting grid location to an obstacle
  }
  for (int i = 8; i < 11; i ++)
  {
    grid[5][16][i] = obstacles[0];//setting grid location to an obstacle
  }
}

/*sets the map picture lava to in-game obstacles
 pre: none
 post: none */
void setLava() {
  //all hard coded values for placement of lava obstacles
  obstacles[0] = new Obstacle(50, 50, 50, 50, transparent, "obstacle");///creates the obstacle object
  for (int i = 5; i < 14; i++)
  {
    grid[2][i][7] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 7; i < 9; i++)
  {
    grid[2][13][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i  = 7; i < 11; i++)
  {
    grid[2][5][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 11; i < 13; i++)
  {
    grid[2][6][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 7; i < 12; i++)
  {
    grid[2][i][13] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 10; i < 13; i ++)
  {
    grid[2][12][i] = obstacles[0];//setting grid location to an obstacle
  }
}

/*sets map picture of water to in-game obstacles
 pre: none
 post: none */
void setWater()
{
  //all hardcoded values for water to become an obstacle
  obstacles[0] = new Obstacle(50, 50, 50, 50, transparent, "obstacle");//creates obstacle object 
  grid[6][1][3] = obstacles[0];//setting grid location to an obstacle
  grid[6][2][2] = obstacles[0];//setting grid location to an obstacle
  grid[6][16][2] = obstacles[0];//setting grid location to an obstacle

  for (int i = 3; i < 6; i ++)
  {
    grid[6][17][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 6; i < 19; i++)
  {
    grid[6][18][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 3; i < 9; i++)
  {
    grid[6][i][1] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 2; i < 8; i++)
  {
    grid[6][8][i] = obstacles[0]; //setting grid location to an obstacle
    grid[6][10][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 5; i < 8; i++)
  {
    grid[6][i][7] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 8; i < 15; i++)
  {
    grid[6][5][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 6; i < 14; i++)
  {
    grid[6][i][14] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 8; i < 14; i++)
  {
    grid[6][13][i] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 10; i < 16; i++)
  {
    grid[6][i][1] = obstacles[0];//setting grid location to an obstacle
  }

  for (int i = 11; i < 14; i++)
  {
    grid[6][i][7] = obstacles[0];//setting grid location to an obstacle
  }
}

/*sets the x and y location of the players attacking rectangle
 pre: posx and posY are always either -50, 0 or 50
 post: none */
void setAtckRect(int posX, int posY)
{
  pAtck.left = player.left + posX;//changes the left of the players attack box
  pAtck.top = player.top + posY;//changes the top of the players attack boss
  pAtck.show(255, 0, 0);//make attack box red
  attack();//check to see if the player has attacked anything
}
