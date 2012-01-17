define(["require", "exports", "module"], function(require, exports, module) {
	
var Rect = require('../../geom/Rect'),
	Ray2D = require('../../geom/Ray2D'),
	Vec2D = require('../../geom/Vec2D');
	
var	RectConstraint = function(a,b){
	if(arguments.length == 1){
		this.rect = a.copy();
	} else if(arguments.length > 1){
		this.rect = new Rect(a,b);
	}
	this.intersectRay = new Ray2D(this.rect.getCentroid(), new Vec2D());
};

RectConstraint.prototype = {
	applyConstraint: function(p){
		if(this.rect.containsPoint(p)){
			console.log("\n hit boundary \n");
			p.set(this.rect.intersectsRay(this.intersectRay.setDirection(this.intersectRay.sub(p)),0,Number.MAX_VALUE));
		}
	},
	
	getBox: function(){
		return this.rect.copy();
	},
	
	setBox: function(rect){
		this.rect = rect.copy();
		this.intersectRay.set(this.rect.getCentroid());
	}	
};

module.exports = RectConstraint;
});
