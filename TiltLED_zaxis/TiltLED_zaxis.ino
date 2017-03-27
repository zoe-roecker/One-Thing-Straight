/*
  This sketch reads the acceleration from the Bean's on-board
  accelerometer and displays it on the Bean's LED.

  This example code is in the public domain.
*/

float threshold = 45;
float Z;

void setup() {
  // Optional: Use Bean.setAccelerationRange() to set the sensitivity
  // to something other than the default of ±2g.
}

void loop() {
  AccelerationReading accel = Bean.getAcceleration();
  Z = accel.zAxis;

  if (Z > threshold) {  // Incorrect posture detected
    // Turn the Bean's LED red
    Bean.setLed(255, 0, 0);
  } else { // Correct posture
    // Turn the Bean's LED green
    Bean.setLed(0, 255, 0);
  }

  Bean.sleep(50);
}
