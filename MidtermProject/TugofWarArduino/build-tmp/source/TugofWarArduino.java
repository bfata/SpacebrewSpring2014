import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import cc.arduino.*; 
import spacebrew.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TugofWarArduino extends PApplet {

/*

 */







Arduino arduino;
//Spacebrew Setup

String server="sandbox.spacebrew.cc";
String name="Tug of War Arduino Controller";
String description ="An epic struggle between two teams.";

Spacebrew sb;

int servoPos;
int arduinoPos;
int startPos;
int scoreCount;
int servoMoveDist;
int button1Score;
int button1GlobalScore;
int button2Score;
int button2GlobalScore;
int battlePos;
int startTime;
int timerInterval;
int pointsToWin;

public void setup() {
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
  sb.addPublish( "button_1_tally", "boolean", false);
  sb.addPublish( "button_2_tally", "boolean",false);
  sb.addPublish( "game_over", "boolean", false);



  // declare your subscribers
  sb.addSubscribe( "button_1_score", "boolean");
  sb.addSubscribe( "button_2_score", "boolean");

  // connect to spacebre
  sb.connect(server, name, description );

  // what Pin is the arduino on?
  arduino.servoWrite(9, servoPos);


  servoPos = 90;

  pointsToWin = 5;

   // how far will the servo move each time a team scores?
  servoMoveDist = servoPos/pointsToWin;

  startTime = millis();
  timerInterval = 3000;

  // UI
  battlePos = width/2;

}

public void draw() {
  background(255);
  scoreCounter();

  line(50, height/2, width-50, height/2);
  fill(0);
  textSize(32);
  text( servoPos, 10, 30);
  fill(255, 0, 255);
  rect(battlePos, height/2, 20, 40);

  // Write an value to the servos, telling them to go to the corresponding
  // angle (for standard servos) or move at a particular speed (continuous
  // rotation servos).
  arduino.servoWrite(9, servoPos);
}

  // Keep track of score
public void scoreCounter(){
    int elapsed = millis() - startTime;

    if (elapsed > timerInterval) {
      if (button1Score > button2Score) {
        // add one to button1 overall score
        button1GlobalScore +=1;
        // send message to SB
        sb.send( "button_1_tally", true);
        // move UI indicator
        battlePos +=30;
        // move servo
        servoPos += servoMoveDist;
        // reset click counters
        button1Score = 0;
        button2Score = 0;
        // reset timer
        startTime = millis();
      }
      if (button2Score > button1Score) {
        // add one to button2 overall score
        button2GlobalScore +=1;
         // send message to SB
        sb.send( "button_1_tally", true);
        // move the UI indicator
        battlePos -=30;
        // move servo
        servoPos -= servoMoveDist;
        // reset click counters
        button2Score = 0;
        button1Score = 0;

        // reset timer
        startTime = millis();
      }
                // Win Conditions
    if (button1GlobalScore >= pointsToWin) {
      text("Team 1 Wins", width/2, height/8);

      if(elapsed > 6000){
        //reset servo
        servoPos = 90;
        //reset scores
        button1GlobalScore = 0;
        button1Score = 0;
        button2GlobalScore = 0;
        button2Score = 0;
        // reset UI indicator
        battlePos = width/2;
        // send sb reset message
        sb.send("game_over", true);
        //reset timer
        startTime = millis();
        }
    }

     if (button2GlobalScore >= pointsToWin) {
      text("Team 2 Wins", width/2, height/8);

      if(elapsed > 6000){
        //reset servo
        servoPos = 90;
        //reset scores
        button1GlobalScore = 0;
        button1Score = 0;
        button2GlobalScore = 0;
        button2Score = 0;
        //reset UI indicator
        battlePos = width/2;
        //send sb reset message
        sb.send("game_over", true);
        //reset timer
        startTime = millis();
        }
    }
    }
  }

public void onBooleanMessage( String name, boolean value ) {
  println("got bool message " + name + " : " + value); 

  if (name.equals("button_1_score")) {
    button1Score +=1;
    println(button1Score);
  }
  if (name.equals("button_2_score")) {
    button2Score+=1;
    println(button2Score);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TugofWarArduino" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
