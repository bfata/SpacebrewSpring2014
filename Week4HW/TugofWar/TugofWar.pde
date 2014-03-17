/*
Prototype Tug of War Game developed as part of the Spacebrew Collab
 at Parsons The New School for Design Spring 2014
 
 Thanks to Bret Renfer and Julio Terra
 
 -BFata
 */
import spacebrew.*;

String server="54.201.24.223";
String name="Tug of War";
String description ="An epic struggle between two teams.";

Spacebrew sb;

color color_on = color(255, 255, 50);
color color_off = color(255, 255, 255);
int currentColor = color_off;

void setup() {
  frameRate(240);
  size(500, 400);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "button1_pressed", "boolean", false ); 
  sb.addPublish( "button2_pressed", "boolean", false );


  // declare your subscribers


  // connect to spacebre
  sb.connect(server, name, description );
}

void draw() {
  // set background color
  background( currentColor );

  // draw buttons
  fill(255, 0, 0);
  stroke(200, 0, 0);
  rectMode(CENTER);
  rect(width*.25, height/2, 150, 150);
  fill(0, 0, 255);
  rect(width*.75, height/2, 150, 150);

  // add text to buttons
  fill(230);
  textAlign(CENTER);
  textSize(24);
  text("Red", width/4, height/2);
  text("Blue", width * .75, height/2);

  if (mousePressed == true && mouseX < width/2 ) {
    text("Clicked", width/4, height/2 + 24);
    //     sb.send( "button1_pressed", true);
  }
  if (mousePressed ==true && mouseX > width/2 ) {
    text("Clicked", width * .75, height/2 + 24);
  }
}

void mouseClicked() {
  // send message to spacebrew
  if (mouseX < width/2) {
    sb.send( "button1_pressed", true);
    println("button1");
  } 
  else {
    sb.send( "button2_pressed", true);
    println("button2");
  }
}

void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value);
}

