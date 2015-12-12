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

class Player extends Actor {
	var _options:PlayerOptions;
	var body:PlayerBody;

	public function new(_opt:PlayerOptions ) {
		_options = _opt;
		super(_options);
	}

	override function init() {
        // trace(name + ' init Player');
		super.init();

		this.visible = false;

		add(new PlayerInput());

		add(new PlayerBody({
			name : 'PlayerBody',
		    segments : 9,
		    radius : 16,
		    step : 16,
            texture : Luxe.resources.texture('assets/circle.png')
			}));

		add(new PlayerRun());
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

typedef PlayerOptions = {
	> SpriteOptions,

    // @:optional var isStatic : Bool;
    @:optional var radius : Float;
} //CircleOptions
