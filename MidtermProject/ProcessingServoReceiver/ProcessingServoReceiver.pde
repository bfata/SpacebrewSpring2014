import processing.serial.*;
import cc.arduino.*;
import spacebrew.*;

Arduino arduino;

String server="54.201.24.223";
String name="Tug of War Prototype";
String description ="This app controls the servo";


Spacebrew sb;

int servoPos = 90;

void setup() {
  frameRate(60);
  size(640, 480);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew( this );

  // declare your subscribers
  sb.addSubscribe( "red_click", "boolean" );
  sb.addSubscribe( "blue_click", "boolean" );

  //connect to Spacebrew
  sb.connect(server, name, description );

  // Prints out the available serial ports.
  println(Arduino.list());

  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);

  // Configure digital pin 7 to control servo motor.
  arduino.pinMode(9, Arduino.SERVO);
}

void draw() {
  background(constrain(mouseX / 2, 0, 180));

  // Write an value to the servos, telling them to go to the corresponding
  // angle (for standard servos) or move at a particular speed (continuous
  // rotation servos).
  arduino.servoWrite(9, constrain(servoPos, 0, 180));
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

