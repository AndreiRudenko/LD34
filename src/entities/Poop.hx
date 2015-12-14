package entities;

import luxe.Input;
import luxe.Entity;
import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Color;
import luxe.Log;

import utils.DebugDrawer;

import components.Collider;
import components.EnemyCollider;

class Poop extends Actor {
	var _options:PoopOptions;
	public var maxTime:Float = 0;
	public var time:Float = 0;
	public var collider:EnemyCollider;

	public function new(_opt:PoopOptions ) {
		_options = _opt;
		super(_options);
		
		this.visible = false;

        texture = Luxe.resources.texture('assets/poop.png');

		texture.generate_mipmaps();
	}

	override function init() {
        // trace(name + ' init Player');
		super.init();
		// maxTime = 2;
		// time = 0;
		
		// this.color = Color.random();

        size.x = Log.def(_options.radius, 16) * 2;
        size.y = Log.def(_options.radius, 16) * 2;

        collider = new EnemyCollider({
			tag : 'poop',
			radius : _options.radius,
			isStatic : _options.isStatic,
			collisionGroup : _options.collisionGroup,
			collisionMask : _options.collisionMask,
			damping : 5
		});

		add(collider);
	}

	override function onCollision(c:Actor.CollideEvent) {
		// trace("Player is onCollision!");
	}

	override function update(dt:Float) {
        // trace("Player update");
        // trace(get("Body").body.mass);
	}

	// override function ondestroy() {
	// }

} //Player

typedef PoopOptions = {
	> SpriteOptions,

    @:optional var isStatic : Bool;
    @:optional var radius : Float;
    @:optional var collisionGroup : Int;
    @:optional var collisionMask : Int;
} //CircleOptions
