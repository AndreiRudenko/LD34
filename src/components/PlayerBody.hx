package components;

import luxe.Input;
import luxe.Vector;
import luxe.Component;
import physics.Body;
import luxe.utils.Maths;
import utils.Mathf;
import utils.Constants;
import utils.Bits;
import phoenix.geometry.QuadGeometry;
import phoenix.Texture;

class PlayerBody extends Component{
    var _options:PlayerBodyOptions;
    var segments:Array<BodySegment>;
    var radius:Float;
    var group:Int;
    var mask:Int;
    var step:Float;
    var zero(default, null):Vector;
    var offset:Vector;
    var force:Vector;

    var headposY:Float;


    var texture:QuadGeometry;

    public var stiffness:Float = 10;
    public var damping:Float = 0.5;

    public var head:BodySegment;

    public var size:Float;


    public function new(_opt:PlayerBodyOptions){
        _options = _opt;
        super(_options);
    }

    override function init(){
        headposY = 600;
        size = 1;
        radius = _options.radius;
        step = _options.step;
        zero = new Vector();
        offset = new Vector();
        force = null;

        group = Constants.GROUP_PLAYER1;
        mask = Bits.clrBits(Constants.GROUP_ALL, group);

        segments = [];

        for (i in 0..._options.segments) {
            // var bd:BodySegment = new BodySegment(_texture, _pos, radius, group, mask);
            var _pos:Vector = new Vector(pos.x, pos.y + step * i);
            segments.push(new BodySegment(_options.texture, _pos, radius, group, mask));
        }

        head = segments[0];
    }

    function createBody(_pos:Vector, _texture:Texture) {
        return new BodySegment(_texture, _pos, radius, group, mask);
    }
    
    override public function onremoved() {
    }

    override public function ondestroy() {
    }

    override function update(dt:Float) {
        for (i in 0...segments.length) {
            var s:BodySegment = segments[i];
            var prevS:BodySegment = segments[i - 1];

            // clamp to screen
            if(s.body.position.x > Luxe.screen.w - s.body.radius){
                s.body.position.x = Luxe.screen.w - s.body.radius;
                if(s.body.velocity.x > 0) s.body.velocity.x = 0; 
            }
            if(s.body.position.x < s.body.radius){
                s.body.position.x = s.body.radius;
                if(s.body.velocity.x < 0) s.body.velocity.x = 0; 
            } 

            // caclulate springs
            if(prevS == null){
                // offset.set_xy(pos.x, headposY);

                var forceY = Mathf.calculateSpringForce1D(
                    s.body.position.y, // posA
                    s.body.velocity.y, // velA
                    headposY, // posB
                    0, // velB
                    0, // length
                    stiffness, // stiffness
                    damping  // damping
                );

                if(forceY != 0){
                    s.body.velocity.y = forceY;
                }

            } else {
                offset.set_xy(prevS.body.position.x, prevS.body.position.y + step);
                force = Mathf.calculateSpringForce(
                    s.body.position, // posA
                    s.body.velocity, // velA
                    offset, // posB
                    prevS.body.velocity, // velB
                    0, // length
                    stiffness, // stiffness
                    damping  // damping
                );

                if(force != null){
                    s.body.velocity.copy_from(force);
                }
            }

            // update texture position
            s.update();
        }

        pos.copy_from(head.body.position).int();
    }

}

typedef PlayerBodyOptions = {
    > luxe.options.ComponentOptions,

    var segments : Int;
    var radius : Float;
    var step : Float;
    // var stiffness : Float;
    // var damping : Float;
    var texture : Texture;

}

class BodySegment {
    public var body(default, null):Body;
    public var texture:QuadGeometry;

    public function new(_texture:Texture, _pos:Vector, radius:Float, group:Int, mask:Int){
        body = new Body({
            space : Physics.space,
            position : _pos.clone(),
            tag : 'segment', 
            radius : radius,
            collisionGroup : group,
            collisionMask : mask,
            isSensor : false,
            isStatic : false,
            gravityScale : 0
        });

        texture = new QuadGeometry({
            id : 'BodySegment.visual',
            x : _pos.x,
            y : _pos.y,
            w : radius * 2,
            h : radius * 2,
            origin : new Vector(radius,radius),
            scale : new Vector(1,1,1),
            texture : _texture,
            depth : 11,
            batcher : Luxe.renderer.batcher
        });
    }

    public function update(){
        texture.transform.pos.copy_from(body.position);
    }

    public function destroy(){
        body.destroy();
        texture.drop(true);

        body = null;
        texture = null;
    }
}

