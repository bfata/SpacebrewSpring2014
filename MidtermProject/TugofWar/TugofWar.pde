/*
Prototype Tug of War Game developed as part of the Spacebrew Collab
 at Parsons The New School for Design Spring 2014
 
 Thanks to Bret Renfer and Julio Terra
 
 -BFata
 */

import spacebrew.*;
float randNum = random(1000);
String server="sandbox.spacebrew.cc";
String name="Tug of War" +randNum;
String description ="An epic struggle between two teams.";

Spacebrew sb;

PImage img;

int button1X, button1Y;
int button2X, button2Y;
int buttonSize = 120;
color button1Color, button2Color;
color button1Highlight, button2Highlight;
boolean overButton1 = false;
boolean overButton2 = false;

void setup() {
  frameRate(240);
  size(800, 600);
  button1Color = color(255, 0, 0, 180);
  button1Highlight = color(255, 0, 0, 255);
  button2Color = color(0, 0, 255, 180);
  button2Highlight = color(0, 0, 0, 255);

  button1X = width/2+buttonSize/2+80;
  button1Y = height/2;
  button2X = width/2-buttonSize/2-80;
  button2Y = height/2;

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "button1_pressed", "boolean", false ); 
  sb.addPublish( "button2_pressed", "boolean", false );

  // connect to spacebrew
  sb.connect(server, name, description );

  img = loadImage("TOWBackground.png");
}

void draw() {
  update(mouseX, mouseY);
  // set background color
  background( img );

  // draw buttons
  fill(button1Color);
  stroke(0);
  rectMode(CENTER);
  rect(button1X, button1Y, buttonSize, buttonSize);

  fill(button2Color);
  rect(button2X, button2Y, buttonSize, buttonSize);

  // add text to buttons
  fill(230);
  textAlign(CENTER);
  textSize(24);
  text("Red", button1X, button1Y);
  text("Blue", button2X, button2Y);

  if (mousePressed == true && mouseX < width/2 ) {
    text("Clicked", width/4, height/2 + 24);
  }
  if (mousePressed ==true && mouseX > width/2 ) {
    text("Clicked", width * .75, height/2 + 24);
  }
}
void update(int x, int y) {
  if ( overButton2(button2X, button2Y, buttonSize) ) {
    overButton2 = true;
    overButton1 = false;
  } 
  else if ( overButton1(button1X, button1Y, buttonSize) ) {
    overButton1 = true;
    overButton2 = false;
  } 
  else {
    overButton2 = overButton1 = false;
  }
}


void mousePressed() {
  // send message to spacebrew
  if (overButton1) {
    sb.send( "button1_pressed", true);
  } 
  if (overButton2) {
    sb.send( "button2_pressed", true);
  }
}

void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value);
}

boolean overButton1(int x, int y, int buttonSize) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } 
  else {
    return false;
  }
}

boolean overButton2(int x, int y, int buttonSize) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < buttonSize/2 ) {
    return true;
  } 
  else {
    return false;
  }
}

