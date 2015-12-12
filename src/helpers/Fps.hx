package helpers;

import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.Entity;

import phoenix.Batcher;

class Fps extends Entity {
	var fps_text : Text;

	public function new(?_batcher:Batcher) {
		super({name : "Fps"});

		var batcher = _batcher != null ? _batcher : Luxe.renderer.batcher;

		fps_text = new luxe.Text({
            color : new Color(1,1,1,1),
            pos : new Vector(Luxe.screen.w-90,5),
            font : Luxe.renderer.font,
            depth : 100,
            point_size : 16,
            batcher : batcher
        });
	}


	public override function update(dt:Float) {
		// fps_text.text = 'fps : ' + Math.round(1.0/dt);
		fps_text.text = 'fps : ' + Math.round(1.0/Luxe.debug.dt_average);
	}
}