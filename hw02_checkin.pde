import peasy.*;

PeasyCam cam;


ArrayList<Thread> threads;
CrossThread ct;
int num_stiches = 10;
float gravity = 10;
float mass = 10;
float restLen = 30;

void setup() {
  size(800, 800, P3D);
  threads = new ArrayList<Thread>();
  threads.add(new Thread(100));
  threads.add(new Thread(200));
  threads.add(new Thread(300));  
  threads.add(new Thread(400));
  threads.add(new Thread(500));
  threads.add(new Thread(600));
  threads.add(new Thread(700));
  ct = new CrossThread(50);
  
  
  //cam = new PeasyCam(this, 500);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(500);
 
}

void draw() {
  background(0);
  float count = 50;
  float index = 0;
  //translate(-width/2,-height/2);
  for(int i = 0; i < threads.size()-1; i++){
    strokeWeight(2);
    Thread t1 = threads.get(i);
    Thread t2 = threads.get(i+1);
    for(int j = 0; j < num_stiches; j++){
      line(t1.stiches.get(j).location.x,t1.stiches.get(j).location.y,t2.stiches.get(j).location.x,t2.stiches.get(j).location.y);
    }
      
    line(t1.anchor.x,t1.anchor.y,t2.anchor.x,t2.anchor.y);
  }
  for(Thread t : threads){
    t.anchor.y=count;
    if(index >= threads.size()/2){
      count-=5;
    }else{
      count +=5;
    }
    index++;
    t.display();
  }
  ct.display();

}


class CrossThread{
  ArrayList<Ball> stiches;
  PVector anchor1;
  PVector anchor2;
  float amount;
  CrossThread(int yPos){
    amount = threads.size();
    stiches = new ArrayList<Ball>();
    anchor1 = new PVector(200,yPos);
    anchor2 = new PVector(600,yPos);
    int xPos = 200;
    println(amount);
    for(int i = 0; i < amount; i++){
      Ball s = new Ball(xPos, yPos, mass, gravity);
      stiches.add(s);
      xPos+=200;
    }
  }
  
  void display(){
    strokeWeight(20);
    
  
  }

  
}
class Thread{
  ArrayList<Ball> stiches;
  PVector anchor;
  
  Thread(int xPos){
    stiches = new ArrayList<Ball>();
    anchor = new PVector(xPos,50);
    int yPos = 50;
    for(int i = 0; i < num_stiches; i++){
      Ball s = new Ball(xPos,yPos,mass,gravity);
      stiches.add(s);
      yPos+=50;
    }
  }

  void display(){
    for(int i = 0; i < stiches.size(); i++){
      if(keyPressed && keyCode == 37){
        stiches.get(i).vel.x+=1;
      }
      if(keyPressed && keyCode == 39){
        stiches.get(i).vel.x-=1;
      }  
      if(keyPressed && keyCode == DOWN){
        stiches.get(i).vel.y+=1;
      }  
      if(i == 0){
        stiches.get(i).update(new Ball(anchor.x,anchor.y,mass,gravity), stiches.get(i+1).forceY,stiches.get(i+1).forceX , 0.05);
        stiches.get(i).display(anchor.x,anchor.y);
      }
      else{
        if(i+1 == stiches.size()){
          stiches.get(i).update(stiches.get(i-1), 0, 0 , 0.05);
        }else{
          
          stiches.get(i).update(stiches.get(i-1), stiches.get(i+1).forceY, stiches.get(i+1).forceX, 0.05);
        }
        stiches.get(i).display(stiches.get(i-1).location.x,stiches.get(i-1).location.y);
      }
    }   
  }
    
  
  
  
}
class Ball{
  PVector vel;
  PVector location;
  PVector acc;
  float gravity;
  float mass;
  float k = 40;

  float kv = 50;
  float forceY;
  float forceX;
  
  Ball(float xpos, float ypos, float m, float g) {
   
    location = new PVector(xpos,ypos);
    acc = new PVector(0,0);
    vel = new PVector(0,0);
    mass = m;
    gravity = g;
  }
  
  void update(Ball target, float preForceY, float preForceX , float dt) {
    forceX = -k * (location.x - target.location.x) + -kv*(vel.x - target.vel.x);
    acc.x = forceX / mass - preForceX / mass;
    vel.x += acc.x * dt;
    location.x += vel.x;
    
    forceY = -k * (location.y - target.location.y - restLen) + -kv*(vel.y - target.vel.y);
 
    acc.y = gravity + forceY / mass - preForceY / mass;
    vel.y += acc.y * dt;
    location.y += vel.y;
    
    acc.mult(0);
  }
  
  void applyForce(PVector force){
    PVector f = force;
    f.div(mass);
    acc.add(f);
  }
  void display(float nx, float ny) {
    strokeWeight(5);
    point(location.x, location.y);
    stroke(255);
    strokeWeight(1);
    line(location.x, location.y, nx, ny);
  }
}
