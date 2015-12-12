package components;

import luxe.Input;
import luxe.Vector;
import luxe.Component;
import physics.Body;
import luxe.utils.Maths;
import utils.Mathf;
import phoenix.geometry.QuadGeometry;
import phoenix.Texture;

class PlayerCollider extends Collider{
    var center:Float = 550;
    var bspeed:Float = 0.5;

    var texture:QuadGeometry;
    var offset:Vector;
    var _options2:PlayerColliderOptions;

    public function new(_opt:PlayerColliderOptions){
        _options2 = _opt;
        super(_options2);
    }

    override function init(){
        super.init();

        offset = _options2.offset;

        texture = new QuadGeometry({
                id:name + '.visual',
                x:entity.pos.x + offset.x,
                y:entity.pos.y + offset.y,
                w: _options2.radius * 2,
                h: _options2.radius * 2,
                origin: new Vector(_options2.radius,_options2.radius),
                scale: new Vector(1,1,1),
                // color : new Color(0.5,0.2,0,1),
                // visible : false,
                texture : _options2.texture,
                depth: 11,
                batcher : Luxe.renderer.batcher
            });
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
            // var forceY:Float = Mathf.calculateSpringForce1D(
            //     body.position.y, // posA
            //     body.velocity.y, // velA
            //     pos.y + 24, // posB
            //     0, // velB
            //     0, // length
            //     5, // stiffness
            //     0.5  // damping
            //     );

            // var forceX:Float = Mathf.calculateSpringForce1D(
            //     body.position.x, // posA
            //     body.velocity.x, // velA
            //     pos.x, // posB
            //     0, // velB
            //     0, // length
            //     5, // stiffness
            //     0.5  // damping
            //     );

            // body.position.y += ps * bspeed;
            // body.velocity.y = forceY;
            // body.velocity.x = forceX;

            var force:Vector = Mathf.calculateSpringForce(
                body.position, // posA
                body.velocity, // velA
                Vector.Add(pos,offset), // posB
                new Vector(), // velB
                0, // length
                10, // stiffness
                0.2  // damping
                );

            if(force != null){
                body.velocity.copy_from(force);
            }

            // body.addForce(0, forceY);
        // }

        // super.update(dt);
        texture.transform.pos.copy_from(body.position);
    }

}
typedef PlayerColliderOptions = {
    > Collider.ColliderOptions,

    var offset : Vector;
    var texture : Texture;

} //ColliderOptions