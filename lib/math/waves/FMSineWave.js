
var extend = require('../../libUtils').extend,
	AbstractWave = require('./AbstractWave');

/**
 * @class
 * member toxi
 * @augments AbstractWave
 */
var	FMSineWave = function(a,b,c,d,e){
	if(typeof(c) == "number"){
		AbstractWave.apply(this,[a,b,c,d]);
		this.fmod = e;
	}else{
		AbstractWave.apply(this,[a,b]);
		this.fmod = c;
	}
};

extend(FMSineWave,AbstractWave);

FMSineWave.prototype.getClass = function(){
	return "FMSineWave";
};

FMSineWave.prototype.pop = function(){
	this.parent.pop.call(this);
	this.fmod.pop();
};

FMSineWave.prototype.push = function(){
	this.parent.push.call(this);
	this.fmod.push();
};

FMSineWave.prototype.reset = function(){
	this.parent.reset.call(this);
	this.fmod.reset();
};

FMSineWave.prototype.update = function(){
	this.value = (Math.sin(this.phase)*this.amp) + this.offset;
	this.cyclePhase(this.frequency + this.fmod.update());
	return this.value;
};

module.exports = FMSineWave;