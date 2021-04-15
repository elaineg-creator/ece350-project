
#include <Servo.h>

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position
int val = 0; 
int state = 0; 

void setup() {
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  Serial.begin(9600); 
}

void loop() {
  if (state == 0){
   myservo.write(0); 
   Serial.print("State: "); 
   Serial.println(state); 
   val = analogRead(A1); 
   Serial.print("Measurement: "); 
   Serial.println(val); 
   if (val > 300){
      state = state + 1; 
   }
  }
  if (state == 1){
    myservo.write(50); 
    Serial.println("Done"); 
    state = state + 1; 
  }
}
