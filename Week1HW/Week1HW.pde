/*
 * Slider Example
 *
 *   This example is of a slider that sends a value in the range of 0 to 1023.  
 *   Click and drag the mouse to move the slider.
 * 
 */

import spacebrew.*;

String server="54.201.24.223";
String name="BFata";
String description ="Client that sends and receives range messages. Range values go from 0 to 1023.";

Spacebrew sb;

// Keep track of our current place in the range
int remote_slider_val = 512;

int posX;
int posY;

//Dragon Image
PImage dragon;

//Change to this Color when you get a boolean message
color color_on = color(255, 255, 50);
color color_off = color(255, 255, 255);

int currentColor = color_off;

void setup() {
  size(640, 480);
  background(0);

  //Load Dragon Image and Resize
  dragon = loadImage("dragon.png");
  dragon.resize(163, 216);


  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  // Don't Need. Just listening this time.

  //  sb.addPublish( "local_slider", "range", local_slider_val ); 
  //  sb.addPublish( "local_button1", "boolean", true);


  // declare your subscribers
  sb.addSubscribe( "slider1", "range" );
  sb.addSubscribe( "button1", "boolean" );

  // connect!
  sb.connect(server, name, description );
}

void draw() {
  background( currentColor );
  stroke(0);
  posY = 50;

  //Make posX the Value of the Remote Slider
  posX = remote_slider_val;
  // Draw a Circle at the X Value of the Slider
  ellipse(posX, posY, 20, 20);


  // White box containing slider
  fill(255, 0, 0);
  rect(0, height/2, width, height/2);

  // Line the slider moves on
  fill(150);
  line(0, height * 3/4, width, height * 3/4);

  // Remote Controlled Slider
  fill(255, 255, 100, 100);
  stroke(200, 200, 50);
  rect(remote_slider_val, (height/2) + 5, 20, (height/2) - 10);

  // Display the current value of remote slider
  fill(0);
  text("Remote Slider Value: ", 30, 460);  
  text(remote_slider_val, 180, 460);  

  image(dragon, 0, 0);
}

void onRangeMessage( String name, int value ) {
  println("got range message " + name + " : " + value);
  remote_slider_val = value;
}

void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value); 

  // update background color
  if (value == true) {
    currentColor = color_on;
  } 
  else {
    currentColor = color_off;
  }
}

