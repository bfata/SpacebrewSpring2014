/*
  AnalogReadSerial
 Reads an analog input on pin 0, prints the result to the serial monitor.
 Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.
 
 This example code is in the public domain.
 */
// Read 3 pots for RGB Color Mixin

void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int sensor1Value = analogRead(A0);
  int sensor2Value = analogRead(A1);
  int sensor3Value = analogRead(A3);

  // print out the value you read:
  Serial.println(sensor1Value);
  delay(100);        // delay in between reads for stability
}

