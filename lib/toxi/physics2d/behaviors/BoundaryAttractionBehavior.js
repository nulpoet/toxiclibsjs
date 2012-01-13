define(["require", "exports", "module"], function(require, exports, module) {
	
var Vec2D = require('../../geom/Vec2D');
	
var	BoundaryAttractionBehavior = function(height, width, radius, strength, jitter){
	if(arguments.length < 4){
		throw { name: "IncorrectParameters", message: "Constructor received incorrect Parameters"};
	}
	this.jitter = jitter || 0;
	this.height = height;
	this.width = width;
	this.strength = strength;
	this.setRadius(radius);
};

BoundaryAttractionBehavior.prototype = {
	applyBehavior: function(p){ //apply() is reserved, so this is now applyBehavior
		var delta;
		var foo = function() {
			var dist = delta.magSquared();
			if(dist < this.radiusSquared){
				//var f = delta.normalizeTo((1.0 - dist / this.radiusSquared)).jitter(this.jitter).scaleSelf(this.attrStrength);
				//var factor = 1 / (Math.sqrt(0.1) * this.radius);
				var factor = 1;
				var f = delta.normalizeTo((1.0 / (factor*factor*dist))).jitter(this.jitter).scaleSelf(this.attrStrength);
				p.addForce(f);
			}
		}
		
		delta = new Vec2D(p.x-0, 0);
		foo();
		delta = new Vec2D(p.x-this.width, 0);
		foo();
		delta = new Vec2D(0, p.y-0);
		foo();
		delta = new Vec2D(0, p.y-this.height);
		foo();
	},
	
	configure: function(timeStep){
		this.timeStep = timeStep;
		this.setStrength(this.strength);
	},
	
	getAttractor: function(){
		return [this.height, this.width];
	},
	
	getJitter: function(){
		return this.jitter;
	},
	
	getRadius: function(){
		return this.radius;
	},
	
	getStrength: function(){
		return this.strength;
	},
	
	setAttractor: function(height, width){
		this.height = height;
		this.width = width;
	},
	
	setJitter: function(jitter){
		this.jitter = jitter;
	},
	
	setRadius: function(r){
		this.radius = r;
		this.radiusSquared = r * r;
	},
	
	setStrength: function(strength){
		this.strength = strength;
		this.attrStrength = strength * this.timeStep;
	}
};

module.exports = BoundaryAttractionBehavior;

});
