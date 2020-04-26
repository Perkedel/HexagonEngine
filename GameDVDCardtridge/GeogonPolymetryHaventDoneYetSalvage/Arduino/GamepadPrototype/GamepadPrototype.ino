//Tutorial Source: https://www.youtube.com/watch?v=of_oLAvWfSI
//by JOELwindows7
//GNU GPL v3
//Arduino Unity Interactor Game Controller Prototype
//Not Confidential!
// Perkedel Technologies / Van Elektronische

const int Up = 7;
const int Left = 6;
const int Right = 5;
const int Down = 4;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  for(int i = 4; i <= 7; i++){
    pinMode(i, INPUT_PULLUP);
  }

}

void loop() {
  // put your main code here, to run repeatedly:
  if(digitalRead(Up) == LOW)
  {
    //Serial.println("Up");
    Serial.write(7);
    Serial.flush();
    delay(20);
  }
  if(digitalRead(Left) == LOW)
  {
    //Serial.println("Left");
    Serial.write(6);
    Serial.flush();
    delay(20);
  }
  if(digitalRead(Right) == LOW)
  {
    //Serial.println("Right");
    Serial.write(5);
    Serial.flush();
    delay(20);
  }
  if(digitalRead(Down) == LOW)
  {
    //Serial.println("Down");
    Serial.write(4);
    Serial.flush();
    delay(20);
  }

  
}

//FOOL YOU, MICROSOFT! DID NOT LET US IMPULSE TRIGGER EASILY ON Win32 but MOSTLY CLOSED ENVIRONMENT, Universal Windows Platform AND Xbox One .xex!!!!
//But I can Impulse trigger DIY with circle vibrator, female dog!!!
//analogWrite(impulseR, 255);!!!!
