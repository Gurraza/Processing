Point[] points = new Point[10];
Stick[] sticks = new Stick[9];
final float gravity = 0.2;
final int numIterations = 5;

void setup(){
  size(400, 400);
  background(45);
  stroke(255);
  
  for(int i = 0; i < 10; i++){
    points[i] = new Point(50 + i * 25, 100, i); 
  }
  points[0].locked = true;
  
  for(int i = 0; i < sticks.length; i++){
    sticks[i] = new Stick(points[i], points[i+1]);
  }  
}

void draw(){
  background(45);
  for(Point p : points){
    if(!p.locked){
      PVector positionBeforeUpdate = p.position;
      
      
      p.position.x += p.position.x - p.prevPosition.x;
      p.position.y += p.position.y - p.prevPosition.y;
      
      
      p.position.y += gravity;
      p.prevPosition = positionBeforeUpdate;
      fill(255);
    }
    else{
      fill(255, 100, 100);
    }
    noStroke();
    circle(p.position.x, p.position.y, 15);
    
  }
  for(int i = 0; i < numIterations; i++){
    for(Stick stick : sticks){
      PVector stickCentre = new PVector((stick.pointA.position.x + stick.pointB.position.x) / 2, (stick.pointA.position.y + stick.pointB.position.y) / 2);
      PVector stickDir = new PVector(stick.pointA.position.x - stick.pointB.position.x, stick.pointA.position.y - stick.pointB.position.y).normalize();
      float len = new PVector(stick.pointA.position.x - stick.pointB.position.x, stick.pointA.position.y - stick.pointB.position.y).mag();
      
      if(len > stick.len){
        if(!stick.pointA.locked){
          stick.pointA.position = new PVector(stickCentre.x + stickDir.x * stick.len / 2, stickCentre.y + stickDir.y * stick.len / 2);
        }
        if(!stick.pointB.locked){
          stick.pointB.position = new PVector(stickCentre.x - stickDir.x * stick.len / 2, stickCentre.y - stickDir.y * stick.len / 2);
        }
      }
    }
  }
  for(Stick stick : sticks){
    stroke(255);
    strokeWeight(1);
    line(stick.pointA.position.x, stick.pointA.position.y, stick.pointB.position.x, stick.pointB.position.y);
  }
}


class Point {
  int index;
  PVector position, prevPosition;
  boolean locked;
  Point(int x, int y, int index){
    position = new PVector(x, y); 
    prevPosition = position;
    this.index = index;
  }
}

class Stick {
   Point pointA, pointB;
   float len;
   Stick(Point p1, Point p2){
     this.pointA = p1;
     this.pointB = p2;
   }
}
