/*
 *************************************************************
 * *************************************************************
 * ****** PROJECT NAME: GRASS CUTTER ROBOT *********************
 * ****** PROJECT YEAR: 2023 / 2024 ****************************
 * ****** PROJECT PROGRAMMED BY: COMET LABS ********************
 * *************************************************************
 * *************************************************************
*/

//*********************** START INCLUDE ***********************
#include <Servo.h>
#include <Wire.h>
#include <MPU6050.h>
//************************ END INCLUDE ************************


//*********************** START DEFINE ************************
// CLI
#define LINE_BUF_SIZE 64  //Maximum input string length
#define ARG_BUF_SIZE 32   //Maximum argument string length
#define MAX_NUM_ARGS 8    //Maximum number of arguments

// MOTOR PINS
#define leftM 50
#define rightM 48
#define leftPWM 45
#define rightPWM 46

// DIRECTION STATE
#define forwardSign LOW
#define backwardSign HIGH

// Multi Function
#define PIN_LIGHTPIN 8
#define PIN_BUZZERPIN 53
#define PIN_GRASS_MOTOR 12

// ULTRA SONIC
#define trigPin A12
#define echoPin A14

// SERVO
#define ultraServoPin 32
#define servoBasePin 44
#define servoL1Pin 42
#define servoL2Pin 40
#define servoL3Pin 38
#define servoGripRotPin 36
#define servoGripPin 34
//************************* END DEFINE ************************

//************************ START OBJECT ***********************
// Servo
Servo ultraServo;
Servo servoBase;
Servo servoL1;
Servo servoL2;
Servo servoL3;
Servo servoGripRot;
Servo servoGrip;
// Accelerometer
MPU6050 mpu;
//************************* END OBJECT ************************

//******************* START CLI VARIABLES *********************
bool error_flag = false;

char line[LINE_BUF_SIZE];
char args[MAX_NUM_ARGS][ARG_BUF_SIZE];

int MOTOR();
int SERVO();
int MULTIFUNCTION();
int AUTOMATION();

int (*commands_func[])() {
  &MOTOR,
  &SERVO,
  &MULTIFUNCTION,
  &AUTOMATION
};

const char *commands_str[] = {
  "MO",  //Motor
  "SR",  //Servo
  "MF",  //Multi Function
  "AT"  //Automation
};

const char *sevo_args[] = {
  "US",  //Ultrasonic
  "BS",  //Base
  "L1",  //Link 1
  "L2",  //Link 2
  "L3",  //Link 3
  "GR",
  "GC"
};
const char *multiFunction_args[] = {
  "LD",  // LED
  "BZ",  // BUZZER
  "MT"   // Grass Motor
};
const char *automation_args[] = {
  "HM",  // Home
  "GC",  //Gripper Close
  "GO",  //Gripper Open
  "C1",  // Catch1
  "C2",   // Catch2
  "LI"   // Load Item
};

int num_commands = sizeof(commands_str) / sizeof(char *);
//********************* END CLI VARIABLES *********************

//********** START MOVEMENT VARIABLES & CONSTANTS *************
//Motor Parameters
#define sameThreshold 80  //angle of forward
#define oppositeThreshold 20  //angle of rotation
#define stopThreshold 20
#define motorStartThreshold 0
#define motionAcceleration 500   //Was 500
#define RefreshRate 50  // in Hz

//Sensors and Actuators
#define AltRefreshRate 50
#define UltrasonicServoOrigin 84
#define UltrasonicServoRange 30
#define servoBaseOrigin 90
#define servoL1Origin 10
#define servoL2Origin 70
#define servoL3Origin 160
#define servoGripRotOrigin 90
#define servoGripOrigin 45
#define servoRefreshRate 10
#define servoSpeed 2
#define servoSpeedThreshold 10
#define automaticStageDelay 1000

#define bluetoothUpdateDelay 500
//Variables and Timers
int servoUltraPos = UltrasonicServoOrigin;
int servoBasePos = servoBaseOrigin;
int servoL1Pos = servoL1Origin;
int servoL2Pos = servoL2Origin;
int servoL3Pos = servoL3Origin;
int servoGripRotPos = servoGripRotOrigin;
int servoGripPos = servoGripOrigin;

int servoUltraTarget = UltrasonicServoOrigin;
int servoBaseTarget = servoBaseOrigin;
int servoL1Target = servoL1Origin;
int servoL2Target = servoL2Origin;
int servoL3Target = servoL3Origin;
int servoGripRotTarget = servoGripRotOrigin;
int servoGripTarget = servoGripOrigin;


float pitch = 0;
float roll = 0;
float yaw = 0;

int Joystick_X = 0;
int Joystick_Y = 0;
int targetLeftSpeed = 0;
int targetRightSpeed = 0;
int MotionType = 0;  // [Type][Left Speed][Right Speed] | Motion Type: like NumPad, <=4 6=> /\ 8 \/ 2 stop 5
unsigned long refreshTimer = 0, servoRefreshTimer = 0, altTimer = 0, bluetoothUpdateTimer = 0;
float timeStep = 0;
int ultrasonicDistance = 10;
//*********** END MOVEMENT VARIABLES & CONSTANTS **************

//**************** START AUTOMATION VARIABLES *****************
bool loadItem = false;
int loadStep = 0;
unsigned long loadTimer = 0;


//***************** END AUTOMATION VARIABLES ******************

void setup() {
  Serial.begin(115200);
  Serial1.begin(9600);
  Serial.println("Start");
  pinMode(leftM, OUTPUT);
  pinMode(rightM, OUTPUT);
  pinMode(leftPWM, OUTPUT);
  pinMode(rightPWM, OUTPUT);
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input
  pinMode (PIN_LIGHTPIN, OUTPUT);
  pinMode (PIN_BUZZERPIN, OUTPUT);
  analogWrite(leftPWM, 0);
  analogWrite(rightPWM, 0);
  delay(250);  //to charge Servo Capacitor

  if (mpu.begin(MPU6050_SCALE_2000DPS, MPU6050_RANGE_8G)) {
    Serial.println("Initialized");
    mpu.calibrateGyro();
    mpu.setThreshold(1);
  } else {
    Serial.println("Not Initialized");
  }

  ultraServo.attach(ultraServoPin);
  ultraServo.write(UltrasonicServoOrigin);

  delay(250);
  servoBase.attach(servoBasePin);
  servoBase.write(servoBaseOrigin);
  delay(250);
  servoL1.attach(servoL1Pin);
  servoL1.write(servoL1Origin);
  delay(250);
  servoL2.attach(servoL2Pin);
  servoL2.write(servoL2Origin);
  delay(250);
  servoL3.attach(servoL3Pin);
  servoL3.write(servoL3Origin);
  delay(250);
  servoGripRot.attach(servoGripRotPin);
  servoGripRot.write(servoGripRotOrigin);
  delay(250);
  servoGrip.attach(servoGripPin);
  servoGrip.write(servoGripOrigin);

  Serial.println("End Main");

}


void loop() {
  CLI();

  if (millis() - altTimer >= (1000 / AltRefreshRate)) {

    //digitalWrite(PIN_LIGHTPIN, (RemoteXY.LightPin == 0) ? LOW : HIGH);
    //digitalWrite(PIN_BUZZERPIN, (RemoteXY.BuzzerPin == 0) ? LOW : HIGH);
    //ultraServo.write(map(RemoteXY.UltrasonicControl, -100, 100, (UltrasonicServoOrigin - UltrasonicServoRange), (UltrasonicServoOrigin + UltrasonicServoRange)));

    timeStep = static_cast<float>(millis() - altTimer) / 1000;


    Vector norm = mpu.readNormalizeGyro();
    pitch = pitch + norm.YAxis * timeStep;
    roll = roll + norm.XAxis * timeStep;
    yaw = yaw + norm.ZAxis * timeStep;

    Serial.print("Yaw: ");
    Serial.println(yaw);
    altTimer = millis();
  }
  if(millis() - bluetoothUpdateTimer >= bluetoothUpdateDelay){  //Send Data to App
    bluetoothUpdateTimer = millis();
    Serial1.print(yaw,0);
    Serial1.print(" ");
    Serial1.print(pitch,0);
    Serial1.print(" ");
    Serial1.print(roll,0);
    Serial1.print(" ");
    Serial1.println(ultrasonicDistance);
  }
  if (millis() - refreshTimer >= (1000 / RefreshRate)) {
    refreshTimer = millis();
    motion(Joystick_X, Joystick_Y);
    speedHandler(RefreshRate);
  }
  if (millis() - servoRefreshTimer >= (1000 / RefreshRate)) {
    servoRefreshTimer = millis();
    servoHandler();
    //ultrasonic_get_distance();
  }
  if (loadItem == true) {
    automaticLoad();
  }
}
void automaticLoad() {
  if (loadStep == 0) {
    loadStep = 1;
    loadTimer = millis();
    servoL3Target = 10;
  }
  if (millis() - loadTimer > automaticStageDelay) {
    loadTimer = millis();
    if (loadStep == 1) {
      servoL1Target = 60;
      servoBaseTarget = 90;
      loadStep = 2;
    }
    else if (loadStep == 2) {
      servoL2Target = 160;
      servoL3Target = 50;
      loadStep = 3;
    }
    else if (loadStep == 3) { //De-Activate Function
      loadStep = 0;
      loadItem = false;
    }
  }
}
void servoHandler() {
  static int servoUltraCurrent = UltrasonicServoOrigin;
  static int servoBaseCurrent = servoBaseOrigin;
  static int servoL1Current = servoL1Origin;
  static int servoL2Current = servoL2Origin;
  static int servoL3Current = servoL3Origin;
  static int servoGripRotCurrent = servoGripRotOrigin;
  static int servoGripCurrent = servoGripOrigin;
  //ULTRASONIC
  if (servoUltraTarget > (servoUltraCurrent + servoSpeedThreshold)) {
    servoUltraCurrent += servoSpeed;
    ultraServo.write(servoUltraCurrent);
  }
  else if (servoUltraTarget > servoUltraCurrent) {
    servoUltraCurrent ++;
    ultraServo.write(servoUltraCurrent);
  }
  else if (servoUltraTarget < servoUltraCurrent - servoSpeedThreshold) {
    servoUltraCurrent -= servoSpeed;
    ultraServo.write(servoUltraCurrent);
  }
  else if (servoUltraTarget < servoUltraCurrent) {
    servoUltraCurrent --;
    ultraServo.write(servoUltraCurrent);
  }

  //BASE
  if (servoBaseTarget > (servoBaseCurrent + servoSpeedThreshold)) {
    servoBaseCurrent += servoSpeed;
    servoBase.write(servoBaseCurrent);
  }
  else if (servoBaseTarget > servoBaseCurrent) {
    servoBaseCurrent ++;
    servoBase.write(servoBaseCurrent);
  }
  else if (servoBaseTarget < servoBaseCurrent - servoSpeedThreshold) {
    servoBaseCurrent -= servoSpeed;
    servoBase.write(servoBaseCurrent);
  }
  else if (servoBaseTarget < servoBaseCurrent) {
    servoBaseCurrent --;
    servoBase.write(servoBaseCurrent);
  }

  //Ll
  if (servoL1Target > (servoL1Current + servoSpeedThreshold)) {
    servoL1Current += servoSpeed;
    servoL1.write(servoL1Current);
  }
  else if (servoL1Target > servoL1Current) {
    servoL1Current ++;
    servoL1.write(servoL1Current);
  }
  else if (servoL1Target < servoL1Current - servoSpeedThreshold) {
    servoL1Current -= servoSpeed;
    servoL1.write(servoL1Current);
  }
  else if (servoL1Target < servoL1Current) {
    servoL1Current --;
    servoL1.write(servoL1Current);
  }

  //L2
  if (servoL2Target > (servoL2Current + servoSpeedThreshold)) {
    servoL2Current += servoSpeed;
    servoL2.write(servoL2Current);
  }
  else if (servoL2Target > servoL2Current) {
    servoL2Current ++;
    servoL2.write(servoL2Current);
  }
  else if (servoL2Target < servoL2Current - servoSpeedThreshold) {
    servoL2Current -= servoSpeed;
    servoL2.write(servoL2Current);
  }
  else if (servoL2Target < servoL2Current) {
    servoL2Current --;
    servoL2.write(servoL2Current);
  }

  //L3
  if (servoL3Target > (servoL3Current + servoSpeedThreshold)) {
    servoL3Current += servoSpeed;
    servoL3.write(servoL3Current);
  }
  else if (servoL3Target > servoL3Current) {
    servoL3Current ++;
    servoL3.write(servoL3Current);
  }
  else if (servoL3Target < servoL3Current - servoSpeedThreshold) {
    servoL3Current -= servoSpeed;
    servoL3.write(servoL3Current);
  }
  else if (servoL3Target < servoL3Current) {
    servoL3Current --;
    servoL3.write(servoL3Current);
  }

  //Gripper Rotation
  if (servoGripRotTarget > (servoGripRotCurrent + servoSpeedThreshold)) {
    servoGripRotCurrent += servoSpeed;
    servoGripRot.write(servoGripRotCurrent);
  }
  else if (servoGripRotTarget > servoGripRotCurrent) {
    servoGripRotCurrent ++;
    servoGripRot.write(servoGripRotCurrent);
  }
  else if (servoGripRotTarget < servoGripRotCurrent - servoSpeedThreshold) {
    servoGripRotCurrent -= servoSpeed;
    servoGripRot.write(servoGripRotCurrent);
  }
  else if (servoGripRotTarget < servoGripRotCurrent) {
    servoGripRotCurrent --;
    servoGripRot.write(servoGripRotCurrent);
  }

  //Gripper
  if (servoGripTarget > (servoGripCurrent + servoSpeedThreshold)) {
    servoGripCurrent += servoSpeed;
    servoGrip.write(servoGripCurrent);
  }
  else if (servoGripTarget > servoGripCurrent) {
    servoGripCurrent ++;
    servoGrip.write(servoGripCurrent);
  }
  else if (servoGripTarget < servoGripCurrent - servoSpeedThreshold) {
    servoGripCurrent -= servoSpeed;
    servoGrip.write(servoGripCurrent);
  }
  else if (servoGripTarget < servoGripCurrent) {
    servoGripCurrent --;
    servoGrip.write(servoGripCurrent);
  }
}

int MOTOR() {
  Joystick_X = atoi(args[1]);
  Joystick_Y = atoi(args[2]);
  return 1;
}

int SERVO() {
  if (strcmp(args[1], sevo_args[0]) == 0) {  //Ultrasonic Servo
    servoUltraTarget = atoi(args[2]);
    return 1;
  }
  else if (strcmp(args[1], sevo_args[1]) == 0) { //Base Servo
    servoBaseTarget = map(atoi(args[2]), 10, 180, 180, 10);
    return 1;
  }
  else if (strcmp(args[1], sevo_args[2]) == 0) {  //L1 Servo
    servoL1Target = atoi(args[2]);
    return 1;
  }
  else if (strcmp(args[1], sevo_args[3]) == 0) {  //L2 Servo
    servoL2Target = atoi(args[2]);
    return 1;
  }
  else if (strcmp(args[1], sevo_args[4]) == 0) {  //L3 Servo
    servoL3Target = atoi(args[2]);
    return 1;
  }
  else if (strcmp(args[1], sevo_args[5]) == 0) {  //Gripper Rotation
    servoGripRotTarget = atoi(args[2]);
    return 1;
  }
  else if (strcmp(args[1], sevo_args[6]) == 0) {  //Gripper Catch
    servoGripTarget = atoi(args[2]);
    return 1;
  }


}
int MULTIFUNCTION() {
  int state = 0;
  if (strcmp(args[1], multiFunction_args[0]) == 0) {  // LED
    state = atoi(args[2]);
    digitalWrite(PIN_LIGHTPIN, state);
    return 1;
  }
  else if (strcmp(args[1], multiFunction_args[1]) == 0) { // BUZZER
    state = atoi(args[2]);
    digitalWrite(PIN_BUZZERPIN, state);
    return 1;
  }
  else if (strcmp(args[1], multiFunction_args[2]) == 0) {  // Grass Motor
    state = atoi(args[2]);
    digitalWrite(PIN_GRASS_MOTOR, state);
    return 1;
  }
}
int AUTOMATION() {
  if (strcmp(args[1], automation_args[0]) == 0) {  // Home
    servoL1Target = 10;
    servoL2Target = 70;
    servoL3Target = 160;
    servoGripRotTarget = 90;
    return 1;
  }
  else if (strcmp(args[1], automation_args[1]) == 0) {  // Gripper Close
    servoGripTarget = 95;
    return 1;
  }
  else if (strcmp(args[1], automation_args[2]) == 0) {  // Gripper Open
    servoGripTarget = 40;
    return 1;
  }
  else if (strcmp(args[1], automation_args[3]) == 0) {  // Catch1
    servoL1Target = 150;
    servoL2Target = 40;
    servoL3Target = 10;
    servoGripRotTarget = 90;
    return 1;

  }
  else if (strcmp(args[1], automation_args[4]) == 0) {  // Catch2
    servoL1Target = 170;
    servoL2Target = 90;
    servoL3Target = 50;
    servoGripRotTarget = 90;
    return 1;

  }
  else if (strcmp(args[1], automation_args[5]) == 0) {  // Load Item
    loadItem = true;
    loadStep = 0;
    return 1;
    /*
       L1 L2 L3
      Catch 1: 150 40 10
      Catch 2: 170 90 50
      Home: L1= 10 70 160
      to Dump
      Step 1: L3= 10
      Step 2: L1= 60
      Step 3: L2= 160 L3= 50

      Catch Open: 40
      Catch Close: 95
    */
  }
}
//********************* START MOTION ************************
void motion(int x, int y) {
  float A, M, rightS = 0, leftS = 0, ratio = 100;
  M = sqrt(pow(x, 2) + pow(y, 2));
  if (M > 100) M = 100;
  A = atan(y / x) * (180 / 3.141);
  if (abs(A) > sameThreshold) { //same direction
    rightS = map(M, 0, 100, motorStartThreshold, 255);
    leftS = map(M, 0, 100, motorStartThreshold, 255);
    if (y > 0 && M > stopThreshold) {  //Forward
      //Serial.print("Forward Booth | ");
      setMotionType(leftS, rightS);
    } else if ( y < 0  && M > stopThreshold) {  //Backward
      //Serial.print("Backward Booth | ");
      setMotionType(-leftS, -rightS);
    } else {
      //Serial.print("STOP | ");
      //moveStop();
      setMotionType(0, 0);
    }
  } else if (abs(A) >= oppositeThreshold) {  //same direction but with different wheel speed
    if (x > 0 && M > stopThreshold) { //Right
      ratio = map(abs(A), oppositeThreshold, sameThreshold, 0, 100);
      rightS = map(((M * ratio) / 100), 0, 100, motorStartThreshold, 255);
      leftS = map(M, 0, 100, motorStartThreshold, 255);
      if (y > 0) { //Forward
        //Serial.print("F Right Diff | ");
        //moveForward(leftS, rightS);
        setMotionType(leftS, rightS);
      } else { //Backward
        //Serial.print("B Right Diff | ");
        //moveBackward(leftS, rightS);
        setMotionType(-leftS, -rightS);
      }
    } else if (x < 0 && M > stopThreshold) { //Left
      ratio = map(abs(A), oppositeThreshold, sameThreshold, 0, 100);
      rightS = map(M, 0, 100, motorStartThreshold, 255);
      leftS = map(((M * ratio) / 100), 0, 100, motorStartThreshold, 255);
      if (y > 0) { //Forward
        //Serial.print("F Left Diff | ");
        //moveForward(leftS, rightS);
        setMotionType(leftS, rightS);
      } else { //Backward
        //Serial.print("B Left Diff | ");
        // moveBackward(leftS, rightS);
        setMotionType(-leftS, -rightS);
      }
    } else {
      //Serial.print("STOP | ");
      //moveStop();
      setMotionType(0, 0);
    }
  } else {
    ratio = map(abs(A), oppositeThreshold, 0 , 0, 100);
    if (x > 0 && M > stopThreshold) { //Right
      //Serial.print("Right Rot | ");
      rightS = map(((M * ratio) / 100), 0, 100, motorStartThreshold, 255);
      leftS = map(M, 0, 100, motorStartThreshold, 255);
      //moveRight(leftS, rightS);
      setMotionType(leftS, -rightS);
    } else if (x < 0 && M > stopThreshold) { //Left
      //Serial.print("Left Rot | ");
      rightS = map(M, 0, 100, motorStartThreshold, 255);
      leftS = map(((M * ratio) / 100), 0, 100, motorStartThreshold, 255);
      //moveLeft(leftS, rightS);
      setMotionType(-leftS, rightS);
    } else {
      //Serial.print("STOP | ");
      //moveStop();
      setMotionType(0, 0);
    }
  }
  /*
    Serial.print("A: ");
    Serial.print(A);
    Serial.print(" | M: ");
    Serial.print(M);
    Serial.print(" | L: ");
    Serial.print(leftS);
    Serial.print(" | R: ");
    Serial.println(rightS);
  */
}
void speedHandler(int Refresh) {
  //Motion Type like NumPad, <=4 6=> /\ 8 \/ 2 stop 5
  //Refresh Rate in Hz
  static float currentLeftSpeed = 0, currentRightSpeed = 0;
  if (targetLeftSpeed >= (currentLeftSpeed + (float)motionAcceleration / Refresh)) { //Left Wheel
    currentLeftSpeed += ((float)motionAcceleration / Refresh);
    if (currentLeftSpeed > 255) {
      currentLeftSpeed = 255;
    }
  }
  else if (targetLeftSpeed <= (currentLeftSpeed - (float)motionAcceleration / Refresh)) { //Left Wheel
    currentLeftSpeed -= ((float)motionAcceleration / Refresh);
    if (currentLeftSpeed < -255) {
      currentLeftSpeed = -255;
    }
  }
  else if (abs(currentLeftSpeed) < (float)motionAcceleration / Refresh) {
    currentLeftSpeed = 0;
  }
  if (targetRightSpeed >= (currentRightSpeed + (float)motionAcceleration / Refresh)) { //Right Wheel
    currentRightSpeed += ((float)motionAcceleration / Refresh);
    if (currentRightSpeed > 255) {
      currentRightSpeed = 255;
    }
  }
  else if (targetRightSpeed <= (currentRightSpeed - (float)motionAcceleration / Refresh)) { //Right Wheel
    currentRightSpeed -= ((float)motionAcceleration / Refresh);
    if (currentRightSpeed < -255) {
      currentRightSpeed = -255;
    }
  }
  else if (abs(currentRightSpeed) < (float)motionAcceleration / Refresh) {
    currentRightSpeed = 0;
  }
  /*
    Serial.print("LS: ");
    Serial.print(currentLeftSpeed);
    Serial.print(" | RS: ");
    Serial.print(currentRightSpeed);
    Serial.println(" | R: ");
  */
  if (currentRightSpeed > 0) {  //Right Wheel
    wheelForward(rightM, rightPWM, abs(currentRightSpeed));
  } else {
    wheelBackward(rightM, rightPWM, abs(currentRightSpeed));
  }
  if (currentLeftSpeed > 0) {  //Left Wheel
    wheelForward(leftM, leftPWM, abs(currentLeftSpeed));
  } else {
    wheelBackward(leftM, leftPWM, abs(currentLeftSpeed));
  }
}

void setMotionType(int left_speed, int right_speed) {
  targetLeftSpeed = left_speed;
  targetRightSpeed = right_speed;
}


void wheelForward(int motorDirectionPin, int motorPWMPin, int motorSpeed) {
  digitalWrite(motorDirectionPin, forwardSign);
  analogWrite(motorPWMPin, motorSpeed);
}
void wheelBackward(int motorDirectionPin, int motorPWMPin, int motorSpeed) {
  digitalWrite(motorDirectionPin, backwardSign);
  analogWrite(motorPWMPin, motorSpeed);
}
//*********************** END MOTION *************************

//*********************** Start Ultrarsonic *************************
float ultrasonic_get_distance() {
  // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Reads the echoPin, returns the sound wave travel time in microseconds
  float duration = pulseIn(echoPin, HIGH, 15000);

  // Calculating the distance
  float distance = duration * 0.034 / 2;
  if (distance == 0) {
    distance = 350;
  }
  Serial.println(distance);
  return distance;
}
//*********************** END Ultrarsonic *************************
//************************ START CLI *************************
void CLI() {
  if (Serial1.available()) {
    read_line();
    if (!error_flag) {
      parse_line();
    }
    if (!error_flag) {
      execute();
    }

    memset(line, 0, LINE_BUF_SIZE);
    memset(args, 0, sizeof(args[0][0]) * MAX_NUM_ARGS * ARG_BUF_SIZE);

    error_flag = false;
  }
}
void read_line() {
  String line_string;
  if (Serial1.available()) {
    line_string = Serial1.readStringUntil('\n');
    if (line_string.length() < LINE_BUF_SIZE) {
      line_string.toCharArray(line, LINE_BUF_SIZE);
      //Serial.println(line_string);
    } else {
      //Serial.println("Input string too long.");
      error_flag = true;
    }
  }
}

void parse_line() {
  char *argument;
  int counter = 0;

  argument = strtok(line, " ");

  while ((argument != NULL)) {
    if (counter < MAX_NUM_ARGS) {
      if (strlen(argument) < ARG_BUF_SIZE) {
        strcpy(args[counter], argument);
        argument = strtok(NULL, " ");
        counter++;
      } else {
        //Serial.println("Input string too long.");
        error_flag = true;
        break;
      }
    } else {
      break;
    }
  }
}

int execute() {
  for (int i = 0; i < num_commands; i++) {
    if (strcmp(args[0], commands_str[i]) == 0) {
      return (*commands_func[i])();
    }
  }
  return 0;
}
//************************* END CLI **************************
