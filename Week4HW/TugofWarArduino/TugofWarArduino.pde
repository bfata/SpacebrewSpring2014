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

int arduinoPos;
int startPos;
int scoreCount;

void setup() {
  size(360, 200);

  // Prints out the available serial ports.
  println(Arduino.list());

  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);

  // Configure digital pins 4 and 7 to control servo motors.
  arduino.pinMode(4, Arduino.SERVO);
  arduino.pinMode(7, Arduino.SERVO);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your publishers
  sb.addPublish( "arduino_Pos", "range", arduinoPos );


  // declare your subscribers
  sb.addSubscribe( "button1", "boolean");
  sb.addSubscribe( "button2", "boolean");

  // connect to spacebre
  sb.connect(server, name, description );

  arduino.servoWrite(7, 180);
}

void draw() {
  background(constrain(mouseX / 2, 0, 180));
  
  line(50, height/2, width-50, height/2);

  // Write an value to the servos, telling them to go to the corresponding
  // angle (for standard servos) or move at a particular speed (continuous
  // rotation servos).
  arduino.servoWrite(7, scoreCount);
}

void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value); 
 
  if (value == true) {
    scoreCount += 1;
  }

}

