import processing.serial.*;
Serial port1;
Serial port2;

String up1 = "UP1";
String down1 = "DOWN1";
String left1 = "LEFT1";
String right1 = "RIGHT1";
String chess1 = "Button1 pressed";
String up2 = "UP2";
String down2 = "DOWN2";
String left2 = "LEFT2";
String right2 = "RIGHT2";
String chess2 = "Button2 pressed";
String shake1 = "SHAKE1";
String shake2 = "SHAKE2";
String inData;
String inData2;

String[][] board = {
  {"", "", ""},
  {"", "", ""},
  {"", "", ""}
};

PImage bg, cursor, cursor1, O, X, refresh;
int cursorX = 100;
int cursorY = 100;
int cursorX1 = 100;
int cursorY1 = 100;
int w, h;
PFont Din;

String[] player = {"X", "O"};
int currentPlayer;
ArrayList<PVector> available = new ArrayList<PVector>();

boolean scoreO = true;
boolean scoreX = true;
int Oscore = 0;
int Xscore = 0;



void setup() {
  size(600, 800);
  bg = loadImage("bg.png");
  cursor = loadImage("cursor.png");
  cursor1 = loadImage("cursor1.png");
  O = loadImage("O.png");
  X = loadImage("X.png");
  refresh = loadImage("refresh.png");
  imageMode(CENTER);
  textAlign(CENTER);
  printArray(Serial.list());
  port1 = new Serial(this, Serial.list()[2], 115200);
  port2 = new Serial(this, Serial.list()[3], 115200);
  port1.bufferUntil(10);
  port2.bufferUntil(10);

  Din = createFont("DIN-Medium", 40);
  textFont(Din);

  w = width/3;
  h = (height-200)/3;

  currentPlayer = floor(random(player.length));
  for (int j = 0; j < 3; j++) {
    for (int i = 0; i < 3; i++) {
      available.add(new PVector(i, j));
    }
  }
}


boolean equals3(String a, String b, String c) {
  return (a == b && b == c && a != "");
}

String checkWinner() {
  String winner = null;

  // horizontal
  for (int i = 0; i < 3; i++) {
    if (equals3(board[i][0], board[i][1], board[i][2])) {
      winner = board[i][0];
    }
  }

  // Vertical
  for (int i = 0; i < 3; i++) {
    if (equals3(board[0][i], board[1][i], board[2][i])) {
      winner = board[0][i];
    }
  }

  // Diagonal
  if (equals3(board[0][0], board[1][1], board[2][2])) {
    winner = board[0][0];
  }
  if (equals3(board[2][0], board[1][1], board[0][2])) {
    winner = board[2][0];
  }

  if (winner == null && available.size() == 0) {
    return "tie";
  } else {
    return winner;
  }
}


void playerMove() {
  if (currentPlayer == 0) {
    int i = cursorY / h;
    int j = cursorX / w;
    board[i][j] = player[currentPlayer];
    currentPlayer = (currentPlayer + 1) % player.length;
  } else if (currentPlayer == 1) {
    int i = cursorY1 / h;
    int j = cursorX1 / w;
    board[i][j] = player[currentPlayer];
    currentPlayer = (currentPlayer + 1) % player.length;
  }
}

void draw() {
  background(255);
  image(bg, width/2, height/2);
  image(O, width/6, height-120, 50, 50);
  image(X, width/6*5, height-120, 50, 50);
  image(refresh, width/2, height-110);
  image(cursor, cursorX, cursorY);
  image(cursor1, cursorX1, cursorY1);

  String a = nf(Oscore, 2);
  String b = nf(Xscore, 2);



  //pointer
  if (currentPlayer==0) {
    noStroke();
    fill(#32A7EB);
    ellipse(width/6*5, height-95, 5, 5);
  } else if (currentPlayer==1) {
    noStroke();
    fill(#02D485);
    ellipse(width/6, height-95, 5, 5);
  }

  //read mircrobit
  if (port1.available()>0) {
    inData = port1.readString();
    if (inData.charAt(0) == '*') {
      inData = inData.substring(1);
      inData = trim(inData);
      //player play
      if (currentPlayer==0) {
        //hide another cursor
        cursorX1 = -800;

        if (inData.equals(up1) == true) {
          if (cursorY <= 100) {
            cursorY = 100;
          } else {
            cursorY-=200;
          }
        } else if (inData.equals(down1) == true) {
          if (cursorY>=500) {
            cursorY = 500;
          } else {
            cursorY+=200;
          }
        } else if (inData.equals(left1) == true) {
          if (cursorX<=100) {
            cursorX = 100;
          } else {
            cursorX-=200;
          }
        } else if (inData.equals(right1) == true) {
          if (cursorX>=500) {
            cursorX = 500;
          } else {
            cursorX+=200;
          }
        } else if (inData.equals(chess1) == true) {
          playerMove();
          cursorX1=cursorX;
          cursorY1=cursorY;
        }
      }
      if (inData.equals(shake1) == true) {
        if (checkWinner() == "O"||checkWinner() == "X"||checkWinner() == "tie")
          clearBoard();
      }
    }
  }



  //read microbit
  if (port2.available()>0) {
    inData2 = port2.readString();
    //println(inData2);
    if (inData2.charAt(0) == '*') {
      inData2 = inData2.substring(1);
      inData2 = trim(inData2);
      if (currentPlayer==1) {
        //hide another cursor
        cursorX = -800;

        if (inData2.equals(up2) == true) {
          if (cursorY1 <= 100) {
            cursorY1 = 100;
          } else {
            cursorY1-=200;
          }
        } else if (inData2.equals(down2) == true) {
          if (cursorY1>=500) {
            cursorY1 = 500;
          } else {
            cursorY1+=200;
          }
        } else if (inData2.equals(left2) == true) {
          if (cursorX1<=100) {
            cursorX1 = 100;
          } else {
            cursorX1-=200;
          }
        } else if (inData2.equals(right2) == true) {
          if (cursorX1>=500) {
            cursorX1 = 500;
          } else {
            cursorX1+=200;
          }
        } else if (inData2.equals(chess2) == true) {
          playerMove();
          cursorX = cursorX1;
          cursorY = cursorY1;
        }
      }
      if (inData2.equals(shake2) == true) {
        if (checkWinner() == "O"||checkWinner() == "X"||checkWinner() == "tie")
          clearBoard();
      }
    }
  }

  drawCell();
  addScore();
  //score
  fill(#02D485);
  text(a, width/6, height-60);
  fill(#32A7EB);
  text(b, width/6*5, height-60);
}



void drawCell() {
  strokeWeight(4);
  for (int j = 0; j<3; j++) {
    for (int i = 0; i<3; i++) {
      float x = w * j + w / 2;
      float y = h * i + h / 2;
      String spot = board[i][j];
      //player1,2 pattern
      if (spot == player[1]) {
        image(O, x, y);
      } else if (spot == player[0]) {
        image(X, x, y);
      }
    }
  }
}

void addScore() {
  if (checkWinner() == "O" && scoreO) {
    Oscore++;
    port2.write("win2");
    scoreO = false;
  } else if (checkWinner() == "X" && scoreX) {
    Xscore++;
    port1.write("win1");
    scoreX = false;
  }
}

void clearBoard() {
  for (int j=0; j<3; j++)
    for (int i=0; i<3; i++)
      board[i][j] = null;
  scoreO = true;
  scoreX = true;
  cursorX = 100;
  cursorY = 100;
  cursorX1 = 100;
  cursorY1 = 100;
}
