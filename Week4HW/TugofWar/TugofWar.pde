/*
 * Button Example
 *
 *   Spacebrew library button example that send and receives boolean messages.  
 * 
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

  // draw button
  fill(255, 0, 0);
  stroke(200, 0, 0);
  rectMode(CENTER);
  rect(width*.25, height/2, 150, 150);
  fill(0, 0, 255);
  rect(width*.75, height/2, 150, 150);

  // add text to button
  fill(230);
  textAlign(CENTER);
  textSize(24);

  if (mousePressed == true && mouseX < width/2 ) {
    text("Clicked", width/4, height/2 + 12);
    //     sb.send( "button1_pressed", true);
  }
  if (mousePressed ==true && mouseX > width/2 ) {
    text("Clicked", width * .75, height/2 + 12);
  }
  else {
    text("Red", width/4, height/2);
    text("Blue", width * .75, height/2);
  }
}

void mousePressed() {
  // send message to spacebrew
  if (mouseX < width/2) {
    sb.send( "button1_pressed", true);
  } 
  else {
    sb.send( "button2_pressed", true);
  }
}

void mouseReleased() {
  // send message to spacebrew
  //  sb.send( "button1_pressed", false);
  //  sb.send( "button2_pressed", false);
}

void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value); 

  // update background color
  //  if (value == true) {
  //    currentColor = color_on;
  //  } 
  //  else {
  //    currentColor = color_off;
  //  }
}

