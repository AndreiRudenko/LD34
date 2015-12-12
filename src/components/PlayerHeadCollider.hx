package components;

import luxe.Input;
import luxe.Vector;
import luxe.Component;
import physics.Body;
import luxe.utils.Maths;
import utils.Mathf;
import phoenix.geometry.QuadGeometry;
import phoenix.Texture;

class PlayerHeadCollider extends Collider{
    var center:Float = 600;

    public function new(_opt:Collider.ColliderOptions){
        _options = _opt;
        super(_options);
    }

    override function init(){
        super.init();
    }
    
    override public function onremoved() {
        super.onremoved();
    }

    override public function ondestroy() {
        super.ondestroy();

        // body.destroy();
        // body = null;
        // _options = null;
    }

    override function update(dt:Float) {
    	// if(body == null) return;
    	// body.velocity.x += Std.random(10) - 5;
    	// body.velocity.y += Std.random(10) - 5;

    	if(body.position.x > Luxe.screen.w - body.radius && body.velocity.x > 0){
    		body.velocity.x = 0;
    		body.position.x = Luxe.screen.w - body.radius;
    	}
    	if(body.position.x < body.radius && body.velocity.x < 0){
    		body.velocity.x = 0;
    		body.position.x = body.radius;
    	}
    	// if(body.position.y > Luxe.screen.h - body.radius && body.velocity.y > 0){
    	// 	body.velocity.y = 0;
    	// 	body.position.y = Luxe.screen.h - body.radius;
    	// }
    	// if(body.position.y < body.radius && body.velocity.y < 0){
    	// 	body.velocity.y = 0;
    	// 	body.position.y = body.radius;
    	// }
        // if(body.position.y > center ){
        //     var ps:Float = body.position.y - center;
        //     body.position.y -= ps * bspeed;
        //     body.velocity.y = 0;
        // }

        // if(body.position.y < center - 1 || body.position.y > center + 1){
            var forceY:Float = Mathf.calculateSpringForce1D(
                body.position.y, // posA
                body.velocity.y, // velA
                center, // posB
                0, // velB
                0, // length
                5, // stiffness
                0.5  // damping
                );

            // body.position.y += ps * bspeed;
            body.velocity.y = forceY;
            // body.addForce(0, forceY);
        // }

        super.update(dt);
        // texture.transform.pos.copy_from(body.position);
    }

}