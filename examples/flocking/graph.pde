
console.log("inside processing code");

window.graph = {};
window.graph.nodes = {
			'1' : {'particle':undefined, 'id':'1'},
			'2' : {'particle':undefined, 'id':'2'},
			'3' : {'particle':undefined, 'id':'3'},
			'4' : {'particle':undefined, 'id':'4'}
		};
window.graph.edges = {
			'1' : [{'node':'2', 'weight':2}, {'node':'3', 'weight':2}, {'node':'4', 'weight':6}]
		};
console.log(window.graph);
console.log("graph init step done");

var  VerletPhysics2D = toxi.physics2d.VerletPhysics2D,
     VerletParticle2D = toxi.physics2d.VerletParticle2D,
	 RectConstraint = toxi.physics2d.constraints.RectConstraint,
     AttractionBehavior = toxi.physics2d.behaviors.AttractionBehavior,
     BoundaryAttractionBehavior = toxi.physics2d.behaviors.BoundaryAttractionBehavior,
     GravityBehavior = toxi.physics2d.behaviors.GravityBehavior,
     Vec2D = toxi.geom.Vec2D,
     Rect = toxi.geom.Rect,
     VerletSpring2D = toxi.physics2d.VerletSpring2D;

import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

int NUM_PARTICLES = 1;

VerletPhysics2D physics;
AttractionBehavior mouseAttractor;

Vec2D mousePos;

VerletSpring2D spm;
VerletParticle2D pm;

void setup() {
  size(680, 382);
  // setup physics with 10% drag
  physics = new VerletPhysics2D();
  window.myphysics = physics;

  physics.setDrag(0.01);
  physics.setWorldBounds(new Rect(0, 0, width, height));

  // the NEW way to add gravity to the simulation, using behaviors
  //physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15)));
  
  //VerletParticle2D p = addParticle(new Vec2D(width/2, height/2));
  //window.nodes["root"] = {"particle":p, "id":"root"};
  
  for (e in window.graph.edges) {
  	console.log(e);
  }

  //p.lock();

  //addnode("one");
  //addedge(0, 1, 2);

  //myaddSprings();
  //physics.particles[0].lock();
}

void setnode(String id) {
  VerletParticle2D p = addParticle(new Vec2D(width/2+1, height/2+1));
  window.graph.nodes[id]["particle"] = p;
}

void setedge(String id1, String id1, double w){
	console.log([n1,n2,w]);
	VerletParticle2D p1 =  window.graph.nodes[id1]['particle'];
	VerletParticle2D p2 =  window.graph.nodes[id2]['particle'];
	VerletSpring2D sp = new VerletSpring2D( p1, p2, 2, 0.001*w);
	physics.addSpring(sp);
}


VerletParticle2D addParticle(Vec2D loc) { 
  VerletParticle2D p = new VerletParticle2D(loc);
  p.setWeight(1000);
  physics.addParticle(p);
  // add a negative attraction force field around the new particle
  physics.addBehavior(new AttractionBehavior(p, 1000, -1000.0, 0));
  return p;
}

void myaddSprings() {
  Vec2D v1 = new Vec2D(width/2-1, height/2);
  Vec2D v2 = new Vec2D(width/2+1, height/2);
  console.log('v1,v2 : ' + v1.toString() +' '+ v2.toString());
  VerletParticle2D p1 = addParticle(v1);  
  VerletParticle2D p2 = addParticle(v2);
  VerletSpring2D sp = new VerletSpring2D(p1, p2, 20, 0.002);
  console.log('sp : '+sp.toString());
  physics.addSpring(sp);
}

void draw() {
  background(255,0,0);
  noStroke();
  fill(255);
  
  //console.log(physics.particles.length);
  physics.update();
  //console.log(physics.particles.length);
  for (int i=0;i<physics.particles.length;i++) {
  	VerletParticle2D p = physics.particles[i];
    ellipse(p.x, p.y, 10, 10);
  }
}

void mousePressed() {
  //addParticle();
  mousePos = new Vec2D(mouseX, mouseY);
  
  pm = new VerletParticle2D(mousePos);
  pm.setWeight(1000);
  physics.addParticle(pm);
  
  pm.lock();
  
  spm = new VerletSpring2D(pm, physics.particles[1], 20, 0.2);
  console.log('spm : '+spm.toString());
  window.myspm = spm;
  physics.addSpring(spm);
}

void mouseDragged() {
  // update mouse attraction focal point
  mousePos.set(mouseX, mouseY);
}

void mouseReleased() {
  // remove the mouse attraction when button has been released
  //physics.removeBehavior(mouseAttractor);
  physics.removeSpring(spm);
  physics.removeParticle(pm);
  //physics.particles[0].unlock();
}