//Parametrar
final float gravity = 100;
final int numIterations = 5;
final int pointSize = 25;
final int strokeWidth = 5;


boolean simulate = false;
ArrayList<Point> points;
ArrayList<Stick> sticks;
long lastFrameTime = 0;
float deltaTime;
int mode = 1;

void setup(){
  size(800, 600);
  background(45);
  stroke(255);
  strokeWeight(strokeWidth);
  frameRate(60);
  
  points = new ArrayList<Point>();
  sticks = new ArrayList<Stick>();
  
  /*// CAPE
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      Point p = new Point(25 + i * 25, 100 + j * 25,);
      points.add(p);
    }
  }
  for(int i = 0; i < 9; i++){
    for(int j = 0; j < 10; j++){
      Stick s = new Stick(points.get(i + j * 10), points.get(i + j * 10+1));
      if(j != 10 && !(i == 5 && j == 5)){
        Stick f = new Stick(points.get(i * 10 + j), points.get(i * 10 + j + 10));
        sticks.add(f);
      }
      sticks.add(s);
    }
  }
  points.get(0).locked = true;
  points.get(90).locked = true;
  */

  background(#30106B);
}

void draw(){
  long currentTime = millis();
  deltaTime = (currentTime - lastFrameTime) * 0.001; // Convert to seconds
  lastFrameTime = currentTime;
  background(#30106B);
  
  if(mousePressed){
    if(chosenPoint != null){
      stroke(175);
      line(chosenPoint.position.x, chosenPoint.position.y, mouseX, mouseY);
      noStroke();
      fill(255);
      circle(mouseX, mouseY, pointSize);
    }
  }
  
  if(simulate){
    simulate();
  }
  show();
}

void keyPressed() {
  if(keyCode == 32){
    simulate = true;
  }
  if(key == '1'){
    mode = 1; 
  }
  if(key == '2'){
    mode = 2; 
  }
  if(key == '3'){
    mode = 3; 
  }
  if(key == '4'){
    if(points.size() <= 0)return;
    Point p = points.get(points.size()-1);
    Stick s = null;
    for(Stick stick : sticks){
      if(stick.pointA == p || stick.pointB == p){
        points.remove(p); 
        s = stick;
      }
    }
    if(s != null)sticks.remove(s);
  }
}
Point chosenPoint;

void mouseClicked(){

  if(mode == 2){
    if(mouseOverPoint() != null)return;
    Point p = new Point(mouseX, mouseY);
    points.add(p);
  }
  else if (mode == 3){
    Point p = mouseOverPoint();
    if(p != null){
      p.locked = !p.locked;
    }
  }
}

void mousePressed(){
  if(mode == 1){
    chosenPoint = mouseOverPoint();
  }
}

void mouseReleased(){
  if(chosenPoint == null)return;
  
  if(mouseOverPoint() != null){
    Stick s = new Stick(chosenPoint, mouseOverPoint());
    for(Stick stick : sticks){
      if(stick.pointA == s.pointA && stick.pointB == s.pointB){
        return;
      }
    }
    if(chosenPoint != mouseOverPoint()){
      sticks.add(s);
    }
    
  }
  else{
    Point p = new Point(mouseX, mouseY);
    points.add(p);
    Stick s = new Stick(chosenPoint, p);
    sticks.add(s);
  }
  chosenPoint = null;
}

Point mouseOverPoint(){
  for(Point p : points){
    float x = p.position.x - mouseX;
    float y = p.position.y - mouseY;
    if(sqrt(sq(x) + sq(y)) < pointSize){
      return p;
    }
  } 
  return null;
}

void simulate (){
  for(Point p : points){
    if(!p.locked){
      PVector positionBeforeUpdate = p.position.copy();
      p.position.add(PVector.sub(p.position, p.prevPosition));
      //p.position.add(0, gravity * pow((float)millis() / 1000, 2));
      p.position.add(0, gravity * deltaTime * deltaTime);
      p.prevPosition = positionBeforeUpdate;
    }
  }
  
  for(int i = 0; i < numIterations; i++){
    for(Stick stick : sticks){
      PVector stickCentre = PVector.div(PVector.add(stick.pointA.position, stick.pointB.position), 2);
      PVector stickDir = PVector.sub(stick.pointA.position, stick.pointB.position).normalize();
      float len = PVector.sub(stick.pointA.position, stick.pointB.position).mag();

      if(len > stick.len){
        if(!stick.pointA.locked){
          stick.pointA.position = PVector.add(stickCentre, PVector.mult(stickDir, stick.len / 2));
        }
        if(!stick.pointB.locked){
          stick.pointB.position = PVector.sub(stickCentre, PVector.mult(stickDir, stick.len / 2));
        }
      }
    }
  }
}

void show(){
  for(Stick stick : sticks){
    stroke(175);
    line(stick.pointA.position.x, stick.pointA.position.y, stick.pointB.position.x, stick.pointB.position.y);
  }
  for(Point p : points){
    if(p.locked)fill(255, 100, 100);
    else fill(255);
    noStroke();
    circle(p.position.x, p.position.y, pointSize); 
  }
}

class Point {
  PVector position, prevPosition;
  boolean locked;
  Point(int x, int y){
    position = new PVector(x, y); 
    prevPosition = position;
  }
}

class Stick {
   Point pointA, pointB;
   float len;
   
   Stick(Point p1, Point p2){
     this.pointA = p1;
     this.pointB = p2;
     len = PVector.dist(pointA.position, pointB.position);
   }
}
