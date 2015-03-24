
int time, time2;
int fps = 60;
int wait = 1000/fps;

ParticleSystem ps;

void setup() {
  size(640, 360);
  time = millis();//store the current time
  time2 = millis();
  ps = new ParticleSystem(new PVector(width/2, 50));
}

void draw() {

  //check the difference between now and the previously stored time is greater than the wait interval
  if (millis() - time >= wait) {
    //    println("tick");//if it is, do something
    background(255);
    ps.run();
    time = millis();//also update the stored time    
  }
  
    if (millis() - time2 >= 1000) {
      ps.addParticle();
      time2 = millis();
    }

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
    //    float radius = random(5, 10);
    float radius = 8;
    particles.add(new Particle(origin, radius));
  }

  void run() {
    // Step for each particle
    for (int i = particles.size ()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }

    // Inter-particle collisions
    for (int i = particles.size ()-1; i >= 0; i--) {
      Particle p1 = particles.get(i);
      // Handle collisions with other particles
      for (int j = ps.particles.size ()-1; j >= 0; j--) {
        Particle p2 = ps.particles.get(j);
        if (p1 == p2) {
          continue;
        } else {
          p1.collide(p2);
        }
      }
    }

    // Display all particles
    for (int i = particles.size ()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.display();
    }
  }
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
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-5, 5), random(-3, 1));
    location = l.get();
    lifespan = 555.0;
    strokeColor = color(255, 255, 255);
    radius = r;
    mass = m;
  }

  // If there is inserction then apply forces to
  // each particle.
  boolean collide(Particle p) {

    // Check if distance between both particles
    // is less than the sum of their combined radius
    float d = location.dist(p.location);
    float r = radius + p.radius;

    if (d < r) {

      // Apply force of particle
      PVector old = this.velocity;
      //      this.velocity.add(PVector.mult(p.velocity, p.mass/this.mass));
      //      p.velocity.add(PVector.mult(old, this.mass/p.mass));
      this.velocity.add(PVector.mult(p.velocity, 0.1));
      p.velocity.add(PVector.mult(old, 0.1));

      // Move particles back so they no longer collide
      float v = r - d;
      PVector dv = PVector.sub(this.location, p.location);
      dv.normalize();
      dv.mult(v);

      PVector pv = PVector.sub(p.location, this.location);
      pv.normalize();
      pv.mult(v);

      this.location.add(dv);
      p.location.add(pv);

      //      float dx = x/2;
      //      float dy = ;
      //      this.location.add()


      // change color when intersected
      this.strokeColor = color(255, 0, 0);
      p.strokeColor = color(255, 0, 0);


      return true;
    } else {
      // Did not intersect
      // Continue 
      return false;
    }
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;

    // Apply boundaries
    // Top / Bottom
    if (location.y + radius > height || location.y - radius < 0) {
      velocity.y = -velocity.y;
    } else 
    // Left / Right
    if (location.x - radius < 0 || location.x + radius > width) {
      velocity.x = -velocity.x;
    }

    // Water
    float waterHeight = 0.2 * height;
    if (location.y > (height - waterHeight) ) {
      // In Water
      strokeColor = color(0, 0, 255);

      // Apply damping
      float dampingFactor = 0.05;
      velocity.add(PVector.mult(velocity, -dampingFactor));

      // Apply boyancy
      velocity.add(new PVector(0.0, -0.1));
    } else {
      strokeColor = color(0, 0, 0);

      // Apply damping
      float dampingFactor = 0.001;
      velocity.add(PVector.mult(velocity, -dampingFactor));
    }

    // Attractors

    // Repellors
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

