/*
Prototype Tug of War Game developed as part of the Spacebrew Collab
 at Parsons The New School for Design Spring 2014
 
 Thanks to Bret Renfer and Julio Terra
 
 -BFata
 */
 // import minim
import ddf.minim.*;


// import spacebrew
import spacebrew.*;
float randNum = random(1000);
String server="sandbox.spacebrew.cc";
String name="Tug of War" +randNum;
String description ="An epic struggle between two teams.";

Spacebrew sb;

PImage img;

int button1X, button1Y;
int button2X, button2Y;
int button1Size = 120;
int button1Pos;
int button2Size = 120;
int button2Pos;
int button1Score;
int button1GlobalScore;
int button2Score;
int button2GlobalScore;
int battleUISize;
int battlePos;
int startTime;
int timerInterval;
int pointsToWin;

int clicktally;

color button1Color, button2Color;
color button1Highlight, button2Highlight;

boolean overButton1 = false;
boolean overButton2 = false;

boolean  team1picked = false;
boolean  team2picked = false;

boolean startOfGame = true;


void setup() {
  frameRate(240);
  size(800, 600);
  
  //Button Normal and Highlight Colors
  button1Color = color(255, 0, 0, 180);
  button1Highlight = color(255, 0, 0, 255);
  button2Color = color(0, 0, 255, 180);
  button2Highlight = color(0, 0, 255, 255);

  // Where to put the buttons
  button1X = width/2 - (button1Size/2 + 80);
  button1Y = height/2;
  button2X = width/2 + (button2Size/2 + 80);
  button2Y = height/2;

  // Set Scores to 0
  button1Score = 0;
  button1GlobalScore = 0;
  button2Score = 0;
  button2GlobalScore = 0;

  // Set Position of Batte Indicator
  battleUISize = 40;
  battlePos = battleUISize/2;
  button1Pos = width/8;
  button2Pos = width/8;

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "button_1_score", "boolean", false ); 
  sb.addPublish( "button_2_score", "boolean", false );

  // declare subscribers
  sb.addSubscribe("team_1_global", "boolean");
  sb.addSubscribe("team_2_global", "boolean");
  sb.addSubscribe("game_over", "boolean");

  // connect to spacebrew
  sb.connect(server, name, description );

  //Background Image
  img = loadImage("TOWBackground.png");

  // Score Counter Timer
  startTime = millis();
  timerInterval = 3000;

  // How Many Points does each team need to win
  pointsToWin = 5;
}

void draw() {

  update(mouseX, mouseY);
  // set background color
  background( img );
  // scoreCounter();

    // Pick Teams
  if (mousePressed == true && overButton1 && startOfGame ) {
    team1picked = true;
    startOfGame = false;
  }
  if (mousePressed ==true && overButton2 && startOfGame ) {
    team2picked = true;
    startOfGame = false;
  }

  // draw buttons
  if (team1picked == false && team2picked ==false){
  fill(button1Color);
  stroke(0);
  rectMode(CENTER);
  rect(button1X, button1Y, button1Size, button1Size);
  fill(button2Color);
  rect(button2X, button2Y, button2Size, button2Size);

  fill(0);
  textAlign(CENTER);
  textSize(24);
  text("Pick A Team", width/2, height/6);
  }

  if(team1picked){
    fill(button1Color);
    rectMode(CENTER);
    button1X = width/2;
    rect(button1X, button1Y, button1Size, button1Size);
    text("Team 1", width/2, height/6);
    fill(255,0,0);
    rect(40, height*.8, 20,40+(button1Score*20));
    fill(0,0,255);
    rect(width-40, height*.8, 20, 40+(button2Score*20));
  }

  if (team2picked) {
    fill(button2Color);
    button2X = width/2;
    rect(button2X, button2Y, button2Size, button2Size);

    text("Team 2", width/2, height/6);
  }

  fill(255);
  rect(width/2, height*.9, 200, 40);
  fill(0);
  text("Total Clicks: "+clicktally, width/2, height*.9);

  // // draw Battle Progress Bar
  // fill(255, 0, 0); //button 1 color
  // rect(button1Pos, height*.82, battleUISize, 25);
  // fill(0, 0, 255); //button 2 color
  // rect(button2Pos, height*.82, battleUISize, 25);
}

void update(int x, int y) {
  // What happens when you hover over Button1
  if ( overButton1(button1X, button1Y, button1Size)) {
    overButton1 = true;
    button1Color = button1Highlight;
    button1Size = 140;
    overButton2 = false;
  }
  // What happens when you hover over Button2
  else if ( overButton2(button2X, button2Y, button2Size)) {
    overButton2 = true;
    button2Color = button2Highlight;
    button2Size = 140;
    overButton1 = false;
  }
  else {
    overButton2 = overButton1 = false;
    button1Size = button2Size = 120;
    button1Color = color(255, 0, 0, 180);
    button2Color = color(0, 0, 255, 180);
  }
}

  // Keep track of score
void scoreCounter(){
    // Win Condition
    if (button1Score >= pointsToWin && startOfGame == false) {
      fill(button1Color);
      text("Team 1 Wins", width/2, height/8);
    }
    if (button2Score >= pointsToWin && startOfGame == false) {
      fill(button2Color);
      text("Team 2 Wins", width/2, height/8);
    }

  }

void mousePressed() {
  if (overButton1 && team1picked) {
    clicktally +=1;
    // send message to spacebrew
    sb.send( "button_1_score", true);
  } 
  if (overButton2 && team2picked) {
     clicktally +=1;
     // send message to spacebrew
    sb.send( "button_2_score", true);
  }
}

void onBooleanMessage( String name, boolean value ) {

  println("got bool message " + name + " : " + value);

   if (name.equals("team_1_global")) {
    button1Score +=1;
  }

   if (name.equals("team_2_global")) {
    button2Score +=1;
  }
   if (name.equals("game_over")) {

    if (button1Score >= pointsToWin) {
      fill(button1Color);
      text("Team 1 Wins", width/2, height/8);
    }
    if (button2Score >= pointsToWin) {
      fill(button2Color);
      text("Team 2 Wins", width/2, height/8);
    }
    int elapsed = millis() - startTime;
    if (elapsed > 3000) {
      startOfGame = true;
    team1picked = false;
    team2picked = false;
    button1Score = 0;
    button1X = width/2 - (button1Size/2 + 80);
    button2Score = 0;
    button2X = width/2 + (button1Size/2 + 80);
    }
}
}

boolean overButton1(int x, int y, int button1Size) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < button1Size/2 ) {
    return true;
  } 
  else {
    return false;
  }
}

boolean overButton2(int x, int y, int button2Size) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < button2Size/2 ) {
    return true;
  } 
  else {
    return false;
  }
}