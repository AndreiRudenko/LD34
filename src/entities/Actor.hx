package entities;

import luxe.Input;
import luxe.Entity;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import physics.Contact;
import physics.Body;


class Actor extends Sprite {

	public function new( _options:luxe.options.SpriteOptions ) {
		super(_options);
	}

	override function init() {
		events.listen('onCollision', onCollision);
	}	

	function onCollision(c:Actor.CollideEvent) {
		trace("Actor onCollision");
	}

	// override function update(dt:Float) {
	// }	

	// override function ondestroy() {
	// }

} 

typedef CollideEvent = {
    var data : Contact;
    var body : Body;
}