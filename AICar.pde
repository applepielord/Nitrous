class AICar extends Vehicle {
  PVector displaypos;
  AICar(float x, float y, PShape iCarShape) {
    super(x, y, iCarShape);
    displaypos = new PVector(x, y);
  }

  void update(PVector tracked) {

    float turningSpeed = 0.1;

    //to make sure that dir is always inbetween +1 Pi and -1 Pi
    dir %= TWO_PI;
    if (dir > PI) dir = dir - TWO_PI;
    if (dir < -PI) dir = TWO_PI + dir;

    //left and right turns
    float slopeBetweenCars = (pos.y-playerCar.pos.y)/(pos.x-playerCar.pos.x);
    
    float angleToPlayer = atan(slopeBetweenCars);
    
    float deltaTheta = angleToPlayer - dir;
    
    PVector toPlayer = playerCar.pos.copy().sub(pos);
    
    if (toPlayer.heading() > dir) dir += turningSpeed;
    else dir -= turningSpeed;
    
    //gas and break
    acc += 0.01;

    //acceleration linear decay
    acc -= 0.01;
    //constraints on acceleration
    acc = constrain(acc, 0, 0.85);
    //velocity exponetial decay
    vel *= 0.9;

    vel += acc;
    if (vel < 0.01) vel = 0;

    pos.add(PVector.fromAngle(dir).mult(vel));

    displaypos.x = -tracked.x + pos.x;
    displaypos.y = -tracked.y + pos.y;
  }

  void display() {
    pushMatrix();
    {
      translate(displaypos.x, displaypos.y);
      scale(carScale);
      rotate(HALF_PI + dir);
      rotateX(HALF_PI);
      rectMode(CENTER);
      fill(225, 128, 0);
      stroke(10);
      strokeWeight(1);
      shape(carShape);
    }
    popMatrix();
  }
}
