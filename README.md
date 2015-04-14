# Physics-Based Animation

> Physics-Based Animation assignment for CSCI 4471 Computer Graphics

---

## Author

- Glavin Wiechert

## Features

### [✓] 1. Particle Simulation

  Create a Particle class or structure that keeps track of (at least) position and velocity for each particle, as well as lifespan. Initial velocities should be easy to modify. It is recommended that you should be able to draw particles in two modes: either as circles (with a radius), or as points. Use your particle class to create simulations that demonstrate the following features:

  - [✓] Collisions with wall

  There are various ways to simulate collisions, e.g. directly modifying the velocity on one hand, and applying the appropriate forces on the other hand. Can you implement and compare these two approaches? Discuss the differences.

  - [✓] Inter-particle collisions

  As above, indicate how you are implementing the collisions. Are they elastic or in- elastic? How would you modify your approach if some of the particles were to have a different mass than others?

  - [✓] Attractor

  Create a particle which attracts other particles. Note that you can make some particles be "magnetic" (ie. attracted to it) and others unaffected by it. This can allow you to have multiple clouds, corresponding to a unique cloud for each magnet. At least one of your attractors should be moving. Indicate whether you are using a force proportional to inverse distance squared or otherwise.

  - [✓] Viscous medium

  Add a drag parameter, ie. a force for each particle that is proportional and opposite to
its velocity.

  - [✓] Repellor

  Create a particle that repels other particles, i.e. pushes them away. Place a few such particles in a scene with hundreds (or thousands) of particles which are being “blown” in some direction (eg. via a global force). The repel force should get stronger as the particles approach each other. Add some walls to the scene to create various turbulent effects. How does this look when the particles leave traces?

#### Screenshots

##### 1. Wall & Inter-particle collisions + Viscous Mediums
![viscous medium and collisions](https://cloud.githubusercontent.com/assets/1885333/6838781/e393cf3a-d33d-11e4-8ecd-f817b84bb078.gif)

##### 2. Wall & Particle Collisions + Viscous Mediums + Moving Attractor & Repellor

Top red particle is moving attactor.
Bottom red particle is moving repellor.

![particle_system](https://cloud.githubusercontent.com/assets/1885333/6839608/fa5bb758-d349-11e4-8696-7c0c32940fc0.gif)


### [✓] 2. Mass-spring Simulation

  - [✓] 2.1 Step 1: One pair (2 particles, 1 dampened spring)

  Begin with a single pair of particles joined by a spring. The system should oscillate indefinitely when undampened, and should come to rest when dampening is turned on.

  - [✓] 2.2 Step 2: One pair plus collisions plus gravity.

  Add walls and gravity to your system from Step 1. This means that it should bounce when it hits the floor, and eventually come to rest on the floor if dampened, regardless of initial position.

  - [✓] 2.3 Step 3: Mesh.

  Create several meshes of particles, with adjacent particles connected by springs. Start with a narrow mesh (e.g. 3x2). Allow the meshes to drop on the floor and get squished. Try a non-rectangular mesh (e.g. a wheel with a point in the middle).

  - [ ] 2.4 Step 4: Actively-controlled mesh.

  Create a mesh in which the rest lengths of the springs varies with time. Are you able to create a mesh that crawls? (You will need to implement a friction model to do so).

#### Screenshot

##### 3x2 Particle Spring Mesh with extra springs for support

![mesh](https://cloud.githubusercontent.com/assets/1885333/7104695/e9d93d42-e0c8-11e4-8b05-36d18ea9b4ce.gif)
