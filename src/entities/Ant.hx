package entities;

import luxe.Input;
import luxe.Entity;
import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Vector;
import luxe.Color;
import luxe.Log;

import utils.DebugDrawer;

import components.AntInput;
import components.AntRun;
import components.AntAI;
import components.EnemyCollider;

class Ant extends Actor {
	var _options:AntOptions;

	public function new(_opt:AntOptions ) {
		_options = _opt;
		super(_options);


        texture = Luxe.resources.texture('assets/ant.png');

        texture.generate_mipmaps();
        
        // _options.isStatic = false;
	}

	override function init() {
        // trace(name + ' init Player');
		super.init();
		this.depth = 12;
		// this.visible = false;
		// this.color = Color.random();

        size.x = Log.def(_options.radius, 16) * 2;
        size.y = Log.def(_options.radius, 16) * 2;

        add(new AntInput());
		add(new EnemyCollider({
			tag : 'ant',
			radius : _options.radius,
			isStatic : false,
			damping : 5
		}));
        add(new AntAI());
        add(new AntRun());

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

typedef AntOptions = {
	> SpriteOptions,

    // @:optional var isStatic : Bool;
    @:optional var radius : Float;
} //CircleOptions
