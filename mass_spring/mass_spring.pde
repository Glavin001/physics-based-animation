int num = 3; 
Mesh mesh;
Spring[] springs = new Spring[num]; 


void setup() {
  size(640, 360);
  noStroke(); 
  mesh = new Mesh();
  Particle p1 = new Particle(new PVector(240, 260), 20);
  Particle p2 = new Particle(new PVector(320, 210), 20);
  Particle p3 = new Particle(new PVector(180, 170), 30);
  mesh.springs.add(new Spring(p1, p2, 0.98, 8.0, 0.1));
  //  mesh.springs.add(new Spring(320, 210, 120, 0.95, 9.0, 0.1, springs, 1); 
  //  mesh.springs.add(new Spring(180, 170, 200, 0.90, 9.9, 0.1, springs, 2);
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

  Mesh() {
    springs = new ArrayList<Spring>();
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

    // Apply Springs
    for (Spring spring : springs) { 
      spring.update();
    }
    // Step for each particle
    for (Particle p : particles) {
      p.update();
      p.checkBoundaryCollision();
    }

    // Display all particles
    for (Particle p : particles) {
      p.display();
    }
    // Display all springs
    for (Spring spring : springs) { 
      spring.display();
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

  // Constructor
  Spring(Particle p1, Particle p2, float d, float m, float k_in) { 
    a = p1;
    b = p2;
    damp = d; 
    k = k_in;
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
     PVector restpoint = midpoint; // FIXME
    
     // First Particle     
     float forceX = -k * (a.location.x - restpoint.x);  // f=-ky 
     float accelx = forceX / a.mass;                 // Set the acceleration, f=ma == a=f/m 
//     velx = damp * (velx + accel);         // Set the velocity 
//     tempxpos = tempxpos + velx;           // Updated position 
     float forceY = -k * (a.location.y - restpoint.y);  // f=-ky 
     float accely = forceY / a.mass;                 // Set the acceleration, f=ma == a=f/m 
//     vely = damp * (vely + accel);         // Set the velocity 
//     tempypos = tempypos + vely;           // Updated position 

    PVector v = new PVector(accelx, accely);
    a.velocity.add(v);

    // Second Particle
    b.velocity.sub(v);

  }

  void display() {
    stroke(springColor);
    line(a.location.x, a.location.y, b.location.x, b.location.y);
  }
} 

