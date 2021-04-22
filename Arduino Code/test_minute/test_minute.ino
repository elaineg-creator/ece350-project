#include <Servo.h>

Servo secservo;  // create servo object to control a servo
Servo minservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int secpos = 1;    // variable to store the second servo position
int minpos = 1;    // variable to store the minute servo position

const int secondIn = 2;
const int minIn = 3;
const int resetpin = 18;

bool firstturn = true;


void setup() {
  secservo.attach(7);  // attaches the servo on pin 7 to the servo object
  minservo.attach(6);  // attaches the servo on pin 6 to the servo object
  pinMode(secondIn, INPUT_PULLUP);
  pinMode(minIn, INPUT_PULLUP);
  pinMode(resetpin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(secondIn), secondTurn, RISING);
  attachInterrupt(digitalPinToInterrupt(minIn), minTurn, RISING);
  attachInterrupt(digitalPinToInterrupt(resetpin), reset, RISING);
  secservo.write(3);
  minservo.write(3); 
//  delay(1000);
  Serial.begin(115200); 
}


void loop() {
}

void secondTurn() {
  if(secpos < 60) {
    secpos += 1;
    secservo.write(secpos * 3); 
    Serial.print("seconds TURNED: ");
    Serial.println(secpos - 1);
  } else {
    secpos = 2;
    secservo.write(secpos * 3);
  }
}

void minTurn() {
  if(minpos < 60) {
    minpos += 1;
    minservo.write(minpos * 3); 
    Serial.print("minute TURNED: ");
    Serial.println(minpos - 1);
  } else {
    minpos = 1;
    Serial.print("minute TURNED: ");
    secservo.write(minpos * 3);
  }
}

void reset() {
  secservo.write(3);
  minservo.write(3); 
  //delay(500);
  Serial.println("reset");
  secpos = 1;
  minpos = 1;
}
