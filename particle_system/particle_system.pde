
int time, time2;
int fps = 60;
int wait = 1000/fps;
float gravity = 0.35;

ParticleSystem ps;
Scene scene;

void setup() {
  size(640, 360);
  time = millis();//store the current time
  time2 = millis();
  ps = new ParticleSystem(new PVector(width/2, 50));
  scene = new Scene();
}

void draw() {

  if (millis() - time2 >= 1000) {
    ps.addParticle();
    time2 = millis();
  }

  //check the difference between now and the previously stored time is greater than the wait interval
  if (millis() - time >= wait) {
    //    println("tick");//if it is, do something
    background(255);
    ps.run();
    time = millis();//also update the stored time
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
      p.checkBoundaryCollision();
      p.handleScene(scene);
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


class Scene {
  Scene() {
  }

  void display() {
    color strokeColor = color(64, 164, 223);
    float w = width;
    float h = 0.2 * height;
    float x = 0;
    float y = height - h;
    stroke(strokeColor, 50);
    fill(strokeColor, 50);
    rectMode(CORNER);
    rect(x, y, w, h);
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
    acceleration = new PVector(0, gravity);
    velocity = new PVector(random(-5, 5), random(-3, 1));
    location = l.get();
    lifespan = 555.0;
    strokeColor = color(255, 255, 255);
    radius = r;
    mass = m;
  }

  void handleScene(Scene scene) {

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
      float dampingFactor = 0.011;
      velocity.add(PVector.mult(velocity, -dampingFactor));
    }

    // Attractors

    // Repellors
  }

  // If there is inserction then apply forces to
  // each particle.
  void checkCollision(Particle other) {

    //    if (true) {
    //      return;
    //    }

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

