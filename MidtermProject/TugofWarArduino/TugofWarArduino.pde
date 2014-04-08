/*

 */

import processing.serial.*;

import cc.arduino.*;

import spacebrew.*;

Arduino arduino;
//Spacebrew Setup

String server="54.201.24.223";
String name="Tug of War Arduino Controller";
String description ="An epic struggle between two teams.";

Spacebrew sb;

int servoPos = 90;
int arduinoPos;
int startPos;
int scoreCount;

void setup() {
  frameRate(60);
  size(640, 480);

  // Prints out the available serial ports.
  println(Arduino.list());

  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  // Configure digital pin 7 to control servo motors.
  arduino.pinMode(9, Arduino.SERVO);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "arduino_Pos", "range", arduinoPos );


  // declare your subscribers
  sb.addSubscribe( "red_click", "boolean");
  sb.addSubscribe( "blue_click", "boolean");

  // connect to spacebre
  sb.connect(server, name, description );

  arduino.servoWrite(9, servoPos);
}

void draw() {
  background(255);

  line(50, height/2, width-50, height/2);
  fill(0);
  textSize(32);
  text( servoPos, 10, 30);

  // Write an value to the servos, telling them to go to the corresponding
  // angle (for standard servos) or move at a particular speed (continuous
  // rotation servos).
  arduino.servoWrite(7, servoPos);
}

void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value); 

  if (name.equals("red_click")) {
    servoPos += 2;
    println(servoPos);
  }
  if (name.equals("blue_click")) {
    servoPos -= 2;
    println(servoPos);
  }
}

