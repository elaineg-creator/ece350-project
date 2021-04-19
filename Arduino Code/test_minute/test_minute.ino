#include <Servo.h>

Servo secservo;  // create servo object to control a servo
Servo minservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int secpos = 0;    // variable to store the second servo position
int minpos = 0;    // variable to store the minute servo position

const int secondIn = 2;
const int minIn = 3;
const int resetpin = 18;


void setup() {
  secservo.attach(7);  // attaches the servo on pin 7 to the servo object
  minservo.attach(6);  // attaches the servo on pin 6 to the servo object
  pinMode(secondIn, INPUT_PULLUP);
  pinMode(minIn, INPUT_PULLUP);
  pinMode(resetpin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(secondIn), secondTurn, RISING);
  attachInterrupt(digitalPinToInterrupt(minIn), minTurn, RISING);
  attachInterrupt(digitalPinToInterrupt(resetpin), reset, RISING);
  secservo.write(0);
  minservo.write(0); 
//  delay(1000);
  Serial.begin(9600); 
}


void loop() {
}

void secondTurn() {
  if(secpos < 59) {
    secpos += 1;
    secservo.write(secpos * 3); 
    Serial.print("seconds TURNED: ");
    Serial.println(secpos);
  } else {
    secpos = 0;
    secservo.write(secpos);
  }
}

void minTurn() {
  if(minpos < 59) {
    minpos += 1;
    minservo.write(minpos * 10); 
    Serial.print("minute TURNED: ");
    Serial.println(minpos);
  } else {
    minpos = 0;
    Serial.print("minute TURNED: ");
    secservo.write(minpos);
  }
}

void reset() {
  secservo.write(0);
  minservo.write(0); 
  //delay(500);
  Serial.println("reset");
  secpos = 0;
  minpos = 0;
}
