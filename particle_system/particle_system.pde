
ParticleSystem ps;

void setup() {
  size(640,360);
  ps = new ParticleSystem(new PVector(width/2,50));
}

void draw() {
  background(255);
  ps.addParticle();
  ps.run();
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
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



// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color strokeColor;

  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-5,5),random(-3,0));
    location = l.get();
    lifespan = 555.0;
    strokeColor = color(255,255,255);
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
    
    // Apply boundaries
    // Bottom
    if (location.y > height || location.y < 0) {
       velocity.y = -velocity.y;
    }
    else if (location.x < 0 || location.x > width) {
       velocity.x = -velocity.x;      
    }
        
    // Water
    float waterHeight = 0.2 * height;
    if (location.y > (height - waterHeight) ) {
      // In Water
      strokeColor = color(0,0,255);
    
      // Apply damping
      float dampingFactor = 0.05;
      velocity.add(PVector.mult(velocity, -dampingFactor));
      
      // Apply boyancy
      velocity.add(new PVector(0.0,-0.1));
    
    } else {
      strokeColor = color(0,0,0);

      // Apply damping
      float dampingFactor = 0.001;
      velocity.add(PVector.mult(velocity, -dampingFactor));

    }
    
    // Attractors
    
    // Repellors
    
    
  }

  // Method to display
  void display() {
    stroke(strokeColor,lifespan);
    fill(strokeColor,lifespan);
    ellipse(location.x,location.y,8,8);
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
