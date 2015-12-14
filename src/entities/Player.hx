package entities;

import luxe.Input;
import luxe.Log;
import luxe.Entity;
import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Color;

import utils.DebugDrawer;
import utils.Constants;
import utils.Bits;

import components.PlayerInput;
import components.PlayerBody;
import components.PlayerRun;
import physics.Body;

class Player extends Actor {
	var _options:PlayerOptions;
	public var body:PlayerBody;

	public function new(_opt:PlayerOptions ) {
		_options = _opt;
		super(_options);
	}

	override function init() {
        // trace(name + ' init Player');
		super.init();

		// this.visible = false;
		this.depth = 9;
		this.size.set_xy(_options.radius * 2, _options.radius * 2);
		this.origin.y = _options.radius * 2.2;
		// this.scale.x = 2;
		// this.scale.y = 2;
		add(new PlayerInput());

		body = new PlayerBody({
			name : 'PlayerBody',
		    segments : 9,
		    radius : _options.radius,
		    step : 16,
            texture : Luxe.resources.texture('assets/segment1.png')
			});

		add(body);

		add(new PlayerRun());
	}

	override function onCollision(c:Actor.CollideEvent) {
		// trace("Player is onCollision!");
		if(c.body.tag == 'ant'){
			var segm:Body = c.contact.bodyA == c.body ? c.contact.bodyB : c.contact.bodyA; 
			body.addAnt(c.body, segm, c.contact.overlap);
		}
	}

	override function update(dt:Float) {
        // trace("Player update");
        // trace(get("Body").body.mass);
        Main.playerPos.copy_from(pos);
        Main.playerScale = scale.x;
	}

	// override function ondestroy() {
	// 	super.ondestroy();
	// }

} //Player

typedef PlayerOptions = {
	> SpriteOptions,

    // @:optional var isStatic : Bool;
    @:optional var radius : Float;
} //CircleOptions
