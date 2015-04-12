int num = 3; 
Mesh mesh;
Spring[] springs = new Spring[num]; 


void setup() {
  size(640, 360);
  noStroke(); 
  mesh = new Mesh();
  //  mesh.physicsEnabled  = false;
  //  frameRate(1);

  // Step 1 and 2)
  //  Particle p1 = new Particle(new PVector(240, 260), 20);
  //  Particle p2 = new Particle(new PVector(320, 210), 20);
  //  Particle p3 = new Particle(new PVector(180, 170), 20);
  //  mesh.springs.add(new Spring(p1, p2, 0.98, 8.0, 0.1));
  //  mesh.springs.add(new Spring(p2, p3, 0.98, 8.0, 0.1));
  //  mesh.springs.add(new Spring(p3, p1, 0.98, 8.0, 0.1));
  //  mesh.springs.add(new Spring(320, 210, 120, 0.95, 9.0, 0.1, springs, 1); 
  //  mesh.springs.add(new Spring(180, 170, 200, 0.90, 9.9, 0.1, springs, 2);

  // Step 3)
  //    Particle[] pX = new Particle[3];
  //  for (int x = 0; x < 2; x++) {
  //    Particle[] pY = new Particle[3];
  //    for (int y = 0; y < 3; y++) {
  //      PVector loc = new PVector(width/2, height/2);
  //      float radius = 20.0;
  //      Particle p = new Particle(loc, radius);
  //      pY;
  ////  mesh.springs.add(new Spring(p1, p2, 0.98, 8.0, 0.1));
  //    }

  setup3x2();
  //  setupWheel();
}

void setup3x2() {

  float dx = 40.0;
  float dy = 40.0;
  float x = 200;
  float y = 200;

  Particle p1 = new Particle(new PVector(x+0*dx, y+0*dy), 20);
  Particle p2 = new Particle(new PVector(x+0*dx, y+1*dy), 20);
  Particle p3 = new Particle(new PVector(x+0*dx, y+2*dy), 20);
  Particle p4 = new Particle(new PVector(x+1*dx, y+0*dy), 20);
  Particle p5 = new Particle(new PVector(x+1*dx, y+1*dy), 20);
  Particle p6 = new Particle(new PVector(x+1*dx, y+2*dy), 20);
  // Column 1    
  mesh.springs.add(new Spring(p1, p2, 0.98, 0.1));
  mesh.springs.add(new Spring(p2, p3, 0.98, 0.1));
  mesh.springs.add(new Spring(p1, p3, 0.98, 0.1, 60));
  // Column 2
  mesh.springs.add(new Spring(p6, p5, 0.98, 0.1));
  mesh.springs.add(new Spring(p5, p4, 0.98, 0.1));
  mesh.springs.add(new Spring(p4, p6, 0.98, 0.1, 60));
  // Horizontals
  mesh.springs.add(new Spring(p1, p4, 0.98, 0.1));
  mesh.springs.add(new Spring(p2, p5, 0.98, 0.1));
  mesh.springs.add(new Spring(p3, p6, 0.98, 0.1));
  // Diagonal
  mesh.springs.add(new Spring(p1, p5, 0.98, 0.09, 37));
  mesh.springs.add(new Spring(p4, p2, 0.98, 0.09, 37));
  mesh.springs.add(new Spring(p3, p5, 0.98, 0.09, 37));
  mesh.springs.add(new Spring(p6, p2, 0.98, 0.09, 37));
}


void setupWheel() {

  float radius = 50.0;
  float x = 400;
  float y = 200;
  Particle p1 = new Particle(new PVector(x+cos(radians(0*60))*radius, y+sin(radians(0*60))*radius), 20);
  Particle p2 = new Particle(new PVector(x+cos(radians(1*60))*radius, y+sin(radians(1*60))*radius), 20);
  Particle p3 = new Particle(new PVector(x+cos(radians(2*60))*radius, y+sin(radians(2*60))*radius), 20);
  Particle p4 = new Particle(new PVector(x+cos(radians(3*60))*radius, y+sin(radians(3*60))*radius), 20);
  Particle p5 = new Particle(new PVector(x+cos(radians(4*60))*radius, y+sin(radians(4*60))*radius), 20);
  Particle p6 = new Particle(new PVector(x+cos(radians(5*60))*radius, y+sin(radians(5*60))*radius), 20);
  Particle pm = new Particle(new PVector(x+0*radius, y+0*radius), 20); // middle

  // Circumference
  //  float circumference = 2 * Math.PI * radius;
  //  float arc =
  mesh.springs.add(new Spring(p1, p2, 0.98, 0.01));
  mesh.springs.add(new Spring(p2, p3, 0.98, 0.01));
  mesh.springs.add(new Spring(p3, p4, 0.98, 0.01));
  mesh.springs.add(new Spring(p4, p5, 0.98, 0.01));
  mesh.springs.add(new Spring(p5, p6, 0.98, 0.01));
  mesh.springs.add(new Spring(p6, p1, 0.98, 0.01));
  // Diagonal
  //  mesh.springs.add(new Spring(pm, p1, 0.98, 0.9, abs(tan(radians(0*60))*radius)));
  //  mesh.springs.add(new Spring(pm, p2, 0.98, 0.9, abs(tan(radians(1*60))*radius)));
  //  mesh.springs.add(new Spring(pm, p3, 0.98, 0.9, abs(tan(radians(2*60))*radius)));
  //  mesh.springs.add(new Spring(pm, p4, 0.98, 0.9, abs(tan(radians(3*60))*radius)));
  //  mesh.springs.add(new Spring(pm, p5, 0.98, 0.9, abs(tan(radians(4*60))*radius)));
  //  mesh.springs.add(new Spring(pm, p6, 0.98, 0.9, abs(tan(radians(5*60))*radius)));
  mesh.springs.add(new Spring(pm, p1, 0.98, 0.09, radius));
  mesh.springs.add(new Spring(pm, p2, 0.98, 0.09, radius));
  mesh.springs.add(new Spring(pm, p3, 0.98, 0.09, radius));
  mesh.springs.add(new Spring(pm, p4, 0.98, 0.09, radius));
  mesh.springs.add(new Spring(pm, p5, 0.98, 0.09, radius));
  mesh.springs.add(new Spring(pm, p6, 0.98, 0.09, radius));
}

void draw() {
  mesh.run();
}

// A simple Particle class
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float mass;
  float radius;
  color strokeColor;
  float gravity = 0.35;
  float drag = 0.010;

  Particle() {
    setup(new PVector(0, 0), 8, 8);
  }

  Particle(PVector l) {
    setup(l, 8, 8);
  }

  Particle(PVector l, float r) {
    setup(l, r, r*0.1);
  }

  Particle(PVector l, float r, float m) {
    setup(l, r, m);
  }

  void setup(PVector l, float r, float m) {
    acceleration = new PVector(0, gravity);
    velocity = new PVector(random(-10, 10), random(-3, 3));
    location = l.get();
    lifespan = 555.0;
    strokeColor = color(0, 0, 0);
    radius = r;
    mass = m;
  }

  void checkBoundaryCollision() {

    if (location.x > width-radius) {
      location.x = width-radius;
      velocity.x *= -1;
    } else if (location.x <radius) {
      location.x =radius;
      velocity.x *= -1;
    } else if (location.y > height-radius) {
      location.y = height-radius;
      velocity.y *= -1;
    } else if (location.y < radius) {
      location.y = radius;
      velocity.y *= -1;
    }
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    //    lifespan -= 1.0;

    // Apply drag
    velocity.add(PVector.mult(velocity, -drag));
  }

  // Method to display
  void display() {
    stroke(strokeColor, lifespan);
    fill(strokeColor, lifespan);
    ellipseMode(RADIUS);
    ellipse(location.x, location.y, radius, radius);
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

class Mesh {
  ArrayList<Spring> springs;
  boolean physicsEnabled;
  boolean showRestPoints;

  Mesh() {
    springs = new ArrayList<Spring>();
    physicsEnabled = true;
    showRestPoints = true;
  }

  ArrayList<Particle> allParticles() {
    ArrayList<Particle> particles = new ArrayList<Particle>();
    for (Spring spring : springs) {
      Particle p1 = spring.first();
      Particle p2 = spring.second();
      if (!particles.contains(p1)) {
        particles.add(p1);
      }
      if (!particles.contains(p2)) {
        particles.add(p2);
      }
    }
    return particles;
  }

  void run() {

    //    background(51);
    background(255);
    ArrayList<Particle> particles = allParticles();

    if ( physicsEnabled) {
      // Apply Springs
      for (Spring spring : springs) { 
        spring.update();
      }
      // Step for each particle
      for (Particle p : particles) {
        p.update();
        p.checkBoundaryCollision();
      }
    }

    // Display all particles
    for (Particle p : particles) {
      p.display();
    }
    // Display all springs
    for (Spring spring : springs) { 
      spring.display(showRestPoints);
    }
  }
}

class Spring {

  Particle a;
  Particle b;  

  color springColor = color(64, 164, 223);
  // Spring simulation constants
  float k = 0.2;    // Spring constant 
  float damp;       // Damping 
  float springDistance;

  // Constructor
  Spring(Particle p1, Particle p2, float da, float k_in) { 
    setup(p1, p2, da, k_in, 30.0);
  }
  Spring(Particle p1, Particle p2, float da, float k_in, float di) { 
    setup(p1, p2, da, k_in, di);
  }

  void setup(Particle p1, Particle p2, float da, float k_in, float di) { 
    a = p1;
    b = p2;
    damp = da; 
    k = k_in;
    springDistance = di;
  }

  Particle first() {
    return a;
  }

  Particle second() {
    return b;
  }

  Particle[] particles() {
    Particle[] ps = {
      a, b
    };
    return ps;
  } 



  void update() { 

    // Calculate Rest position
    PVector displacement = PVector.sub(a.location, b.location);
    PVector midpoint = PVector.add(b.location, PVector.div(displacement, 2.0));
    displacement.normalize();
    PVector slope = displacement;

    // First Particle
    PVector restpointA = PVector.add(midpoint, PVector.mult(slope, springDistance) );
    PVector forceA = PVector.mult(PVector.sub(a.location, restpointA), -k);
    a.velocity.add(PVector.mult(forceA, damp));

    // Second Particle
    PVector restpointB = PVector.sub(midpoint, PVector.mult(slope, springDistance) );    
    PVector forceB = PVector.mult(PVector.sub(b.location, restpointB), -k);
    b.velocity.add(PVector.mult(forceB, damp));
  }

  void display() {
    display(false);
  }

  void display(boolean showRestPoints) {
    stroke(springColor);
    line(a.location.x, a.location.y, b.location.x, b.location.y);

    if (showRestPoints) {
      // Calculate Rest position
      PVector displacement = PVector.sub(a.location, b.location);
      PVector midpoint = PVector.add(b.location, PVector.div(displacement, 2.0));
      displacement.normalize();
      PVector slope = displacement;

      // First Particle
      PVector restpointA = PVector.add(midpoint, PVector.mult(slope, springDistance) );
      // Second Particle
      PVector restpointB = PVector.sub(midpoint, PVector.mult(slope, springDistance) );    

      color pointColor = color(255, 0, 0);
      float radius = 5.0;
      stroke(pointColor);
      fill(pointColor);
      ellipseMode(RADIUS);
      ellipse(restpointA.x, restpointA.y, radius, radius);
      ellipse(restpointB.x, restpointB.y, radius, radius);
    }
  }
} 

