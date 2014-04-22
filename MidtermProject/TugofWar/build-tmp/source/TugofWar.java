import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import spacebrew.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TugofWar extends PApplet {

/*
Prototype Tug of War Game developed as part of the Spacebrew Collab
 at Parsons The New School for Design Spring 2014
 
 Thanks to Bret Renfer and Julio Terra
 
 -BFata
 */
 // import minim



// import spacebrew

float randNum = random(1000);
String server="sandbox.spacebrew.cc";
String name="Tug of War" +randNum;
String description ="An epic struggle between two teams.";

Spacebrew sb;

PImage img;

int button1X, button1Y;
int button2X, button2Y;
int button1Size = 120;
int button2Size = 120;
int team1Score;
int team2Score;
int battleUISize;
int battlePos;
int button1Color, button2Color;
int button1Highlight, button2Highlight;
boolean overButton1 = false;
boolean overButton2 = false;

Minim minim;
AudioPlayer player;

public void setup() {
  frameRate(240);
  size(800, 600);
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  player = minim.loadFile("epic300song.mp3");
  player.play();
  
  //Button Normal and Highlight Colors
  button1Color = color(255, 0, 0, 180);
  button1Highlight = color(255, 0, 0, 255);
  button2Color = color(0, 0, 255, 180);
  button2Highlight = color(0, 0, 255, 255);

  // Where to put the buttons
  button1X = width/2+button1Size/2+80;
  button1Y = height/2;
  button2X = width/2-button2Size/2-80;
  button2Y = height/2;

  // Set Position of Batte Indicator
  battleUISize = 400;
  battlePos = battleUISize/2;

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "button1_pressed", "boolean", false ); 
  sb.addPublish( "button2_pressed", "boolean", false );

  // connect to spacebrew
  sb.connect(server, name, description );

  img = loadImage("TOWBackground.png");
}

public void draw() {
  update(mouseX, mouseY);
  // set background color
  background( img );

  // draw buttons
  fill(button1Color);
  stroke(0);
  rectMode(CENTER);
  rect(button1X, button1Y, button1Size, button1Size);
  fill(button2Color);
  rect(button2X, button2Y, button2Size, button2Size);

  // draw Battle Progress Bar
  fill(255, 0, 0); //button 1 color
  rect(width/2, height*.82f, battleUISize, 25);
  fill(0, 0, 255); //button 2 color
  rect(width/2, height*.82f, battleUISize-battlePos, 25);

  // add text to buttons
  fill(230);
  textAlign(CENTER);
  textSize(24);
  text("Red", button1X, button1Y);
  text("Blue", button2X, button2Y);

  // show text when they've been clicked
  if (mousePressed == true && overButton1 ) {
    text("Clicked", button1X, height/2 + 24);
  }
  if (mousePressed ==true && overButton2 ) {
    text("Clicked", button2X, height/2 + 24);
  }
}

public void update(int x, int y) {
  // What happens when you hover over Button1
  if ( overButton1(button1X, button1Y, button1Size) ) {
    overButton1 = true;
    button1Color = button1Highlight;
    button1Size = 140;
    overButton2 = false;
  }
  // What happens when you hover over Button2
  else if ( overButton2(button2X, button2Y, button2Size) ) {
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
  // keep track of score

}

public void mousePressed() {
  if (overButton1) {
    battlePos+=10;
    // send message to spacebrew

    sb.send( "button1_pressed", true);
  } 
  if (overButton2) {
    battlePos-=10;
    // send message to spacebrew

    sb.send( "button2_pressed", true);
  }
}

public void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value);
}

public boolean overButton1(int x, int y, int button1Size) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < button1Size/2 ) {
    return true;
  } 
  else {
    return false;
  }
}

public boolean overButton2(int x, int y, int button2Size) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < button2Size/2 ) {
    return true;
  } 
  else {
    return false;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TugofWar" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
