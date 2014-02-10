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

//Change to this Color when you get a boolean message
color color_on = color(255, 255, 50);
color color_off = color(255, 255, 255);

int currentColor = color_off;

float posX;
float posY;

PFont font;


//Dragon Image
PImage dragon;
PImage greatwall;

PVector location;
PVector velocity;
PVector gravity;
PVector sliderForce;

//Fireworks
ParticleSystem ps;

void setup() {
  size(640, 480);
  background(0);

  ps = new ParticleSystem(new PVector(width/2, 50));

  //Load Dragon Image and Resize
  dragon = loadImage("dragon.png");
  dragon.resize(163, 216);
  greatwall = loadImage("greatwall.png");


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

  location = new PVector( width/2, height/2);
  velocity = new PVector(1.5, 2.1);
  gravity = new PVector(0, 0.2);
  sliderForce = new PVector (0.0, 0.0);

  font = loadFont("CharlemagneStd-Bold-32.vlw");
  textFont(font, 24);
}

void draw() {
  background(255, 0, 0);
  stroke(0);
  posY = 50;

  //Make posX the Value of the Remote Slider 
  posX = remote_slider_val;
  posX = map(remote_slider_val, 0, 1024, -.005, .005);
  // Draw a Circle at the X Value of the Slider
  ellipse(posX, posY, 20, 20);
  sliderForce.set(posX, 0.0);


  location.add(velocity);
  velocity.add(gravity);
  // Adding Slider Force makes it freak out  
  gravity.add(sliderForce);

  // Yo Dragon, if you get to the edges, turn around
  if ((location.x > width) || (location.x < 0)) {
    velocity.x = velocity.x * -0.98;
  }

  // Dragon, when you hit the floor, dont fall through, and lose some
  // velocity
  if (location.y > height - 70) {
    // We're reducing velocity ever so slightly when it hits the bottom
    velocity.y = velocity.y * -0.95;
  }
  // Draw the Great Wall + Dragon + Happy New Year
  image(greatwall, width/2, height/2);
  fill(255, 0, 0);
  text("Happy New Year!", 20, 30);

  imageMode(CENTER);
  image(dragon, location.x, location.y);

  // Display the current value of remote slider
  fill(255);
  textFont(font, 18);
  text("Remote Slider Value: ", 10, 460);  
  text(posX, 400, 460);

  if (currentColor == 1) {
    ps.addParticle();
    ps.run();
  }
}

void onRangeMessage( String name, int value ) {
  println("got range message " + name + " : " + value);
  remote_slider_val = value;
}

void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value); 

  // update background color
  if (value == true) {
    currentColor = 1;
    println("ayooo button");
  } 
  else {
    currentColor = 0;
  }
}

