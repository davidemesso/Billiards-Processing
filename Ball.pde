class Ball
{
  PVector position;
  PVector velocity;
  int radius;
  float m;
  color c;
  int type;
  boolean bucket = false;

  Ball(int x, int y, int r, color c, int type)
  {
    this.position = new PVector(x, y);
    velocity = new PVector();
    this.radius = r/2;
    this.c = c;
    this.type = type;
    m = radius * .1;
  }


  void draw()
  {
    fill(c);
    ellipse(position.x, position.y, radius*2, radius*2);
  }

  void update()
  {
    slowDown();
    position.x = lerp(position.x, position.x + velocity.x, .2);
    position.y = lerp(position.y, position.y + velocity.y, .2);
    this.bounceBoard();
  }

  void slowDown()
  {
    float friction = 0.2;

    if (velocity.x > 0)
      velocity.x -= friction;
    else if (velocity.x != 0)
      velocity.x += friction;
    if (velocity.y > 0)
      velocity.y -= friction;
    else if (velocity.y != 0)
      velocity.y += friction;

    if (abs(velocity.x) < 0.5)
      velocity.x = 0;
    if (abs(velocity.y) < 0.5)
      velocity.y = 0;
  }

  void bounceBoard()
  {
    if (position.x >= 950)
    {
      position.x = 945;
      velocity.x = -velocity.x;
    }

    if (position.x <= 50)
    {
      position.x = 51;
      velocity.x = -velocity.x;
    }

    if (position.y >= 550)
    {
      position.y = 549;
      velocity.y = -velocity.y;
    }

    if (position.y <= 50)
    {
      position.y = 51;
      velocity.y = -velocity.y;
    }
  }

  void checkCollision(Ball other) {
    
    if(this == other)
      return;

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = radius + other.radius;

    if (distanceVectMag < minDistance) {
      if (other.type == 3)
      {
        this.position = new PVector(0, 0);
        this.velocity = new PVector(0, 0);
        this.bucket = true;
        if(this.type == 0)
          doRestart = true;
        return;
      }
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }
}
