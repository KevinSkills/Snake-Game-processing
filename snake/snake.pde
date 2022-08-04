int[][] gameBoard;
int gridSize;
int gridX, gridY;
int headPosX, headPosY;
int snakeLength;
int dir;


float startTickTime;
float lastTick;
float tickTime;

int lastDir;

int score;

float speedUpTickTime = 0.99f;
float speedUpDefaultSpeed = 200;

float slowDownTickTime = 1.005;
float slowDownDefaultSpeed = 30;

float currentTickTime;



void setup() {
  textSize(40);
  //size(1400, 800);
  fullScreen();
  gridSize = 30;
  gridX = width/gridSize;
  gridY = height/gridSize;
  gameBoard = new int[gridX][gridY];

  resetGame();
}

void draw() {
  drawGameBoard();
  
  tickTime *= currentTickTime;//0.99;//

  if (lastTick + tickTime < millis()) {
    tickTheGame();
    lastTick = millis();
  }
  
  if(tickTime > 300) lose();
  
  
  
  fill(255);
  text("Score: " + score, 50, 50);
}

void lose(){
  resetGame();
}

void resetGame() {

  
  score = 0;
  currentTickTime = slowDownTickTime;
  
  clearGameBoard();
  snakeLength = 5;
  dir = RIGHT;

  headPosX = gridX/2;
  headPosY = gridY/2;


  // Place the head
  gameBoard[headPosX][headPosY] = 1;

  //ticktick
  startTickTime = slowDownDefaultSpeed;
  tickTime = startTickTime;
  lastTick = millis();

  putApple();
}

void clearGameBoard() {
  for (int i = 0; i < gridX; i++) {
    for (int j = 0; j < gridY; j++) {
      gameBoard[i][j] = 0;
    }
  }
}


void putApple() {
  int x = (int)random(1, gridX-1);
  int y = (int)random(1, gridY-1);
  
  int r = (int)random(1, 3);

  //check if there is something
  if (gameBoard[x][y] != 0) {
    putApple();
  } else {
    gameBoard[x][y] = -r;
  }
}

void eatApple(int x, int y) {
  //check if there is an apple
  if (gameBoard[x][y] == -1) {
    score++;
    snakeLength++;
    putApple();
    tickTime = slowDownDefaultSpeed;;
    currentTickTime = slowDownTickTime;
    
  }
  if (gameBoard[x][y] == -2) {
    score++;
    snakeLength++;
    putApple();
    tickTime = speedUpDefaultSpeed;;
    currentTickTime = speedUpTickTime;
    
  }
}


void tickTheGame() {
  //update gameboard
  for (int i = 0; i < gridX; i++) {
    for (int j = 0; j < gridY; j++) {
      if (gameBoard[i][j] > 0) {

        if (gameBoard[i][j] >= snakeLength) {
          gameBoard[i][j] = 0;
        } else {
          gameBoard[i][j]++;
        }
      }
    }
  }

  //move head
  if (dir == LEFT) headPosX--;
  if (dir == RIGHT) headPosX++;
  if (dir == UP) headPosY--;
  if (dir == DOWN) headPosY++;




  if (legalMove(headPosX, headPosY)) {
    lastDir = dir;
    eatApple(headPosX, headPosY);
    gameBoard[headPosX][headPosY] = 1;
  } else {
    lose();
  }
}


void keyPressed() {
  if (getOppositeDir(lastDir) != keyCode) {
    if (keyCode == UP) dir = keyCode;
    if (keyCode == DOWN) dir = keyCode;
    if (keyCode == LEFT) dir = keyCode;
    if (keyCode == RIGHT) dir = keyCode;
  }
}



boolean legalMove(int x, int y) {
  if (x < 0 || x >= gridX) return false;
  if ( y < 0 || y >= gridY) return false;

  if (gameBoard[x][y] > 0) return false;
  return true;
}

int getOppositeDir(int dir) {
  if (dir == LEFT) return RIGHT;
  if (dir == RIGHT) return LEFT;
  if (dir == DOWN) return UP;
  if (dir == UP) return DOWN;
  return 0;
}


void drawGameBoard() {
  background(0);

  for (int i = 0; i < gridX; i++) {
    for (int j = 0; j < gridY; j++) {
      if (gameBoard[i][j] > 0) {
        fill(0, 255 - (gameBoard[i][j] - 1) * (255/snakeLength) + 30, 0);
        rect(gridSize*i, gridSize*j, gridSize, gridSize);
      }
      if (gameBoard[i][j] == -1) {
        fill(255, 0, 0);
        rect(gridSize*i, gridSize*j, gridSize, gridSize);
      }
      if (gameBoard[i][j] == -2) {
        fill(0, 0, 255);
        rect(gridSize*i, gridSize*j, gridSize, gridSize);
      }
    }
  }
}
