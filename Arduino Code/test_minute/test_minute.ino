#include <Servo.h>

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position
int val = 0; 
int state = 0; 
int secondIn = 2;
int secondTurn = 0;


void setup() {
  myservo.attach(7);  // attaches the servo on pin 9 to the servo object
  pinMode(secondIn, INPUT);
  myservo.write(0); 
  delay(1000);
  Serial.begin(9600); 
}

void loop() {
//  secondTurn = digitalRead(secondIn);
//  Serial.println(secondTurn); 
//  myservo.write(0); 
   val = analogRead(A1); 
   Serial.print("Measurement: "); 
   Serial.println(val); 
  if (val > 300){
    pos += 1;
    myservo.write(pos * 10); 
    Serial.println("TURNED"); 
    Serial.print("Measurement: "); 
   Serial.println(val); 
    Serial.println(pos); 
  }
}
