// uwnd stores the 'u' component of the wind.
// The 'u' component is the east-west component of the wind.
// Positive values indicate eastward wind, and negative
// values indicate westward wind.  This is measured
// in meters per second.
Table uwnd;

// vwnd stores the 'v' component of the wind, which measures the
// north-south component of the wind.  Positive values indicate
// northward wind, and negative values indicate southward wind.
Table vwnd;

// An image to use for the background.  The image I provide is a
// modified version of this wikipedia image:
//https://commons.wikimedia.org/wiki/File:Equirectangular_projection_SW.jpg
// If you want to use your own image, you should take an equirectangular
// map and pick out the subset that corresponds to the range from
// 135W to 65W, and from 55N to 25N
PImage img;
ParticleSystem ps;


void setup() {
  // If this doesn't work on your computer, you can remove the 'P3D'
  // parameter.  On many computers, having P3D should make it run faster
  size(700, 400, P3D);
  pixelDensity(displayDensity());
  ps = new ParticleSystem(new PVector(random(0,width), random(0,height)));
  
  img = loadImage("background.png");
  uwnd = loadTable("uwnd.csv");
  vwnd = loadTable("vwnd.csv");
  
}

void draw() {
  background(255);
  image(img, 0, 0, width, height);
  //drawpoints();
  
  ps.addParticle();
  ps.run();
  drawMouseLine();

}



void drawpoints() {
  strokeWeight(10);
    beginShape(POINTS);
vertex(30, 20);
vertex(85, 20);
vertex(85, 75);
vertex(30, 75);
endShape();
}

void drawMouseLine() {
  // Convert from pixel coordinates into coordinates
  // corresponding to the data.
  float a = mouseX * uwnd.getColumnCount() / width;
  float b = mouseY * uwnd.getRowCount() / height;
  
  // Since a positive 'v' value indicates north, we need to
  // negate it so that it works in the same coordinates as Processing
  // does.
  float dx = readInterp(uwnd, a, b) * 10;
  float dy = -readInterp(vwnd, a, b) * 10;
  fill(0);
  line(mouseX, mouseY, mouseX + dx, mouseY + dy);
}



// Reads a bilinearly-interpolated value at the given a and b
// coordinates.  Both a and b should be in data coordinates.
float readInterp(Table tab, float a, float b) {
  //println("a " + a + " b " + b);
  int x1 = floor(a);
  int y1 = floor(b);
  int x2 = x1+1;
  int y2 = x2+1;
  //println("a " + a + " b " + b);
  float Q11 = readRaw(tab, x1, y1);
  //println("Q11 " + Q11);
  float Q12 = readRaw(tab, x1, y2);
  //println("Q12 " + Q12);
  float Q21 = readRaw(tab, x2, y1);
  //println("Q21 " + Q21);
  float Q22 = readRaw(tab, x2, y2);
  //println("Q22 " + Q22);
  float f_x_y1 = (((x2 - a) / (x2 - x1)) * Q11) + (((a - x1) / (x2 - x1)) * Q21);
  float f_x_y2 = (((x2 - a) / (x2 - x1)) * Q12) + (((a - x1) / (x2 - x1)) * Q22);
  float fin = (((y2 - b) / (y2 - y1)) * f_x_y1) + (((b - y1) / (y2 - y1)) * f_x_y2);
  //println("fin " + fin);
  // TODO: do bilinear interpolation
  return fin;
}

// Reads a raw value 
float readRaw(Table tab, int x, int y) {
  if (x < 0) {
    x = 0;
  }
  if (x >= tab.getColumnCount()) {
    x = tab.getColumnCount() - 1;
  }
  if (y < 0) {
    y = 0;
  }
  if (y >= tab.getRowCount()) {
    y = tab.getRowCount() - 1;
  }
  return tab.getFloat(y,x);
}


class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

  
  
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    position = l.copy();
    
  
  float a = position.x * uwnd.getColumnCount() / width;
  float b = position.y * uwnd.getRowCount() / height;
  
  float dx = readInterp(uwnd, a, b) * 10;
  float dy = -readInterp(vwnd, a, b) * 10;
    
    //acceleration = new PVector(0, 0.05);
    //velocity = new PVector(random(1, -1), random(-2, 1));
    acceleration = new PVector(dx/10, dy/10);
    velocity = getVelocity();
    lifespan = 250.0;
  }
  
PVector getVelocity(){
   velocity = new PVector(random(1, -1), random(-2, 1));
   return velocity;

}
  
  // A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

void run() {
    update();
    display();
  }
  
    // Method to update position
  void update() {

   position.add(velocity);
   velocity.add(acceleration);
   lifespan -= 1.0;
  }

  // Method to display
  void display() {
    //stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }


  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}