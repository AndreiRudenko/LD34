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

class Circle extends Actor {
	var _options:CircleOptions;

	public function new(_opt:CircleOptions ) {
		_options = _opt;
		super(_options);
	}

	override function init() {
        // trace(name + ' init Player');
		super.init();

		// this.visible = false;
		// this.color = Color.random();

        size.x = Log.def(_options.radius, 16) * 2;
        size.y = Log.def(_options.radius, 16) * 2;

		add(new EnemyCollider({
			tag : 'circle',
			radius : _options.radius,
			isStatic : _options.isStatic
		}));
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

typedef CircleOptions = {
	> SpriteOptions,

    @:optional var isStatic : Bool;
    @:optional var radius : Float;
} //CircleOptions
