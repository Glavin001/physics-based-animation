
Scene scene;

void setup() {
  //size(640, 360);
  size(1280, 800, P2D);
  scene = new Scene();
}

void draw() {
  scene.draw();
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
    float radius = random(8, 20);
    particles.add(new Particle(origin, radius));
  }

  void run() {
    // Step for each particle
    for (int i = particles.size ()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.checkBoundaryCollision();
      if (p.isDead()) {
        particles.remove(i);
      }
    }

    // Inter-particle collisions
    for (int i = particles.size ()-1; i >= 0; i--) {
      Particle p1 = particles.get(i);
      // Handle collisions with other particles
      for (int j = particles.size ()-1; j >= 0; j--) {
        Particle p2 = particles.get(j);
        if (p1 == p2) {
          continue;
        } else {
          p1.checkCollision(p2);
        }
      }
    }

    // Display all particles
    for (int i = particles.size ()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.display();
    }

    // Display Scene
    scene.display();
  }
}

class Medium {

  PVector location;
  float w, h;
  color strokeColor;
  int alpha;
  float buoyancy;
  float drag;

  Medium(PVector l, float w, float h) {
    setup(l, w, h, color(0, 0, 0), 255, 0.02, 0.25);
  }

  Medium(PVector l, float w, float h, color c, int a, float d, float b) {
    setup(l, w, h, c, a, d, b);
  }

  void setup(PVector l, float w, float h, color c, int a, float d, float b) {
    location = l.get();
    this.w = w;
    this.h = h;
    this.strokeColor = c;
    this.alpha = a;

    buoyancy = b;
    drag = d;
  }

  void draw() {

    float x = location.x;
    float y = location.y;

    stroke(strokeColor, alpha);
    fill(strokeColor, alpha);
    rectMode(CORNER);
    rect(x, y, w, h);
  }

  void checkParticleCollision(Particle p) {

    if (p.location.x > location.x && p.location.x < (location.x + w) ) {

      // Water
      //    float waterHeight = 0.3 * height;

      if (p.location.y > location.y) {
        // In Water

        // Apply damping
        p.velocity.add(PVector.mult(p.velocity, -drag));

        // Apply buoyancy
        p.velocity.add(new PVector(0.0, -buoyancy));
      }
    }
    // Attractors


    // Repellors
  }
}

class Scene {

  ParticleSystem ps;
  ArrayList<Medium> mediums;
  int time, time2;
  int fps = 60;
  int wait = 1000/fps;
  int creationPeriod = 300;

  Scene() {
    setup();
  }

  void setup() {
    time = millis();//store the current time
    time2 = millis();
    ps = new ParticleSystem(new PVector(width/2, 50));
    mediums = new ArrayList<Medium>();

    // Water
    color waterColor = color(64, 164, 223);
    int alpha = 150;
    float w = 0.6*width;
    float h = 0.3 * height;
    float x = 0.4*width;
    float y = height - h;
    PVector loc1 = new PVector(x, y);
    Medium m1 = new Medium(loc1, w, h, waterColor, alpha, 0.12, 0.45);
    mediums.add(m1);

    // Land
    PVector loc2 = new PVector(0, y);
    Medium m2 = new Medium(loc2, x, h, color(223, 164, 64), 150, 0.24, 0.3);
    mediums.add(m2);
  }

  void draw() {

    if (millis() - time2 >= creationPeriod) {
      ps.addParticle();
      time2 = millis();
    }

    //check the difference between now and the previously stored time is greater than the wait interval
    if (millis() - time >= wait) {
      background(255);
      ps.run();

      // Particle-Medium collisions
      for (int i = mediums.size ()-1; i >= 0; i--) {
        Medium m = mediums.get(i);
        // Handle collisions with other particles
        for (int j = ps.particles.size ()-1; j >= 0; j--) {
          Particle p = ps.particles.get(j);
          m.checkParticleCollision(p);
        }
      }

      time = millis();//also update the stored time
    }
  }


  void display() {

    for (int i = mediums.size ()-1; i >= 0; i--) {
      Medium m = mediums.get(i);
      m.draw();
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
    float gravity = 0.35;
    acceleration = new PVector(0, gravity);
    velocity = new PVector(random(-10, 10), random(-3, 1));
    location = l.get();
    lifespan = 555.0;
    strokeColor = color(0, 0, 0);
    radius = r;
    mass = m;
  }

  // If there is inserction then apply forces to
  // each particle.
  void checkCollision(Particle other) {

    // get distances between the balls components
    PVector bVect = PVector.sub(other.location, location);

    // calculate magnitude of the vector separating the balls
    float bVectMag = bVect.mag();

    if (bVectMag < radius + other.radius) {
      // get angle of bVect
      float theta  = bVect.heading();
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
        bTemp[1].x  = cosine * bVect.x + sine * bVect.y;
      bTemp[1].y  = cosine * bVect.y - sine * bVect.x;

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
        vFinal[0].x = ((mass - other.mass) * vTemp[0].x + 2 * other.mass * vTemp[1].x) / (mass + other.mass);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.mass - mass) * vTemp[1].x + 2 * mass * vTemp[0].x) / (mass + other.mass);
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
      other.location.x = location.x + bFinal[1].x;
      other.location.y = location.y + bFinal[1].y;

      location.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
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
    lifespan -= 1.0;

    // Apply drag
    float drag = 0.010;
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

class Magnet extends Particle {
  float magnetism;

  Magnet(PVector l, float m) {
    super(l);
    magnetism = m;
  }

  void applyForce(Particle p) {

    // Get distance from particle
    PVector v = PVector.sub(p.location, location);

    p.velocity.add(v);
  }
}

