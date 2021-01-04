ArrayList<Ball> balls = new ArrayList<Ball>();
boolean doRestart = false;

Board board = new Board();
Ball whiteBall = new Ball(100, 300, 20, color(255, 255, 255), 0);

void setup()
{
  size(1000, 600);
  balls.add(whiteBall);
  balls.add(new Ball(800, 300, 20, color(255, 0, 0), 1));
  balls.add(new Ball(820, 311, 20, color(0, 255, 0), 1));
  balls.add(new Ball(820, 289, 20, color(0, 0, 255), 1));
  balls.add(new Ball(840, 300, 20, color(255, 255, 0), 1));
  balls.add(new Ball(840, 322, 20, color(0, 255, 255), 1));
  balls.add(new Ball(840, 278, 20, color(255, 0, 255), 1));
  balls.add(new Ball(860, 310, 20, color(100, 255, 100), 1));
  balls.add(new Ball(860, 288, 20, color(200, 100, 255), 1));
  balls.add(new Ball(860, 266, 20, color(255, 200, 255), 1));
  balls.add(new Ball(860, 334, 20, color(255, 100, 0), 1));
  balls.add(new Ball(0, 0, 40, color(0, 0, 0), 3));
  balls.add(new Ball(1000, 0, 40, color(0, 0, 0), 3));
  balls.add(new Ball(1000, 600, 40, color(0, 0, 0), 3));
  balls.add(new Ball(0, 600, 40, color(0, 0, 0), 3));
  drawBoard();
  //whiteBall.velocity = new PVector(random(10, 50), random(10, 50));
}

void draw() 
{
  int bucket = 0;
  drawBoard();
  for(Ball b : balls)
  {
    b.update();
    b.draw();
    for(Ball a : balls)
      b.checkCollision(a);
    if(b.bucket)
      bucket++;
  }
  checkWin(bucket);
  if(doRestart)
    restart();
}

void drawBoard()
{
  background(255, 255, 255);
  board.draw();
}

void mouseClicked()
{
  for(Ball b : balls)
    if(b.velocity.x != 0 || b.velocity.y != 0)
      return;
  stroke(255,0,0);
  ellipse(mouseX, mouseY, 20, 20);
  
  PVector mouse = new PVector(mouseX,mouseY);
  PVector acceleration = PVector.sub(mouse,whiteBall.position);
  acceleration.setMag(dist(whiteBall.position.x, whiteBall.position.y, mouseX, mouseY)/2);
  whiteBall.velocity.add(acceleration);
  whiteBall.velocity.limit(300);
}

void restart()
{
  balls.clear();
  whiteBall.position = new PVector(100, 300);
  whiteBall.bucket = false;
  balls.add(whiteBall);
  balls.add(new Ball(800, 300, 20, color(255, 0, 0), 1));
  balls.add(new Ball(820, 311, 20, color(0, 255, 0), 1));
  balls.add(new Ball(820, 289, 20, color(0, 0, 255), 1));
  balls.add(new Ball(840, 300, 20, color(255, 255, 0), 1));
  balls.add(new Ball(840, 322, 20, color(0, 255, 255), 1));
  balls.add(new Ball(840, 278, 20, color(255, 0, 255), 1));
  balls.add(new Ball(860, 310, 20, color(100, 255, 100), 1));
  balls.add(new Ball(860, 288, 20, color(200, 100, 255), 1));
  balls.add(new Ball(860, 266, 20, color(255, 200, 255), 1));
  balls.add(new Ball(860, 334, 20, color(255, 100, 0), 1));
  balls.add(new Ball(0, 0, 40, color(0, 0, 0), 3));
  balls.add(new Ball(1000, 0, 40, color(0, 0, 0), 3));
  balls.add(new Ball(1000, 600, 40, color(0, 0, 0), 3));
  balls.add(new Ball(0, 600, 40, color(0, 0, 0), 3));
  doRestart = false;
}

void checkWin(int bucket)
{
  if(bucket == 10 && (whiteBall.velocity.x == 0 && whiteBall.velocity.y == 0) && whiteBall.bucket == false)
    println("win");
}
