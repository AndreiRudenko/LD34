package components;

import luxe.Input;
import luxe.Entity;
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
    var ants:Array<AntSegment>;
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
        ants = [];

        for (i in 0..._options.segments) {
            // var bd:BodySegment = new BodySegment(_texture, _pos, radius, group, mask);
            var _pos:Vector = new Vector(pos.x, pos.y + step * i);
            segments.push(new BodySegment(entity, _options.texture, _pos, radius, group, mask));
        }

        head = segments[0];
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
                var dist:Float = Mathf.distance(s.body.position, prevS.body.position);
                if(dist < radius * 0.8){
                    force = Mathf.calculateSpringForce(
                        s.body.position, // posA
                        s.body.velocity, // velA
                        offset, // posB
                        prevS.body.velocity, // velB
                        0, // length
                        stiffness, // stiffness
                        damping  // damping
                    );
                } else {
                    force = Mathf.calculateSpringForce(
                        s.body.position, // posA
                        s.body.velocity, // velA
                        offset, // posB
                        prevS.body.velocity, // velB
                        0, // length
                        15, // stiffness
                        damping  // damping
                    );
                }


                if(force != null){
                    s.body.velocity.copy_from(force);
                }
            }

            // update texture position
            s.update();
        }

        for (a in ants) {
            a.update();
        }

        pos.copy_from(head.body.position).int();
    }

    public function addAnt(_ant:Body, _segment:Body, _offset:Vector) {
        ants.push(new AntSegment(_ant, _segment, _offset));
    }

    // public function removeAnt(_ant:Body) {
    //     ants.remove(_ant);
    // }

    public function removeRandomAnt() {
        var num:Int = Std.int(Math.random()* ants.length);
        ants[num].destroy();
        ants.splice(num, 1);
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

    public function new(_entity:Entity, _texture:Texture, _pos:Vector, radius:Float, group:Int, mask:Int){
        body = new Body({
            entity : _entity,
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

class AntSegment {
    public var segment(default, null):Body;
    public var ant(default, null):Body;
    public var offset(default, null):Vector;

    public function new(_ant:Body, _segment:Body, _offset:Vector){
        ant = _ant;

        ant.entity.remove('AntAI');

        segment = _segment;
        offset = _offset;

        ant.tag = 'joinedAnt';
        ant.collisionMask = segment.collisionMask;
        Main.speed -= ant.radius * 2;
    }

    public function update(){
        if(ant.tag != 'joinedAnt') return;

        // var _offset:Vector = new Vector(segment.position.x + offset.x + ant.radius * Maths.sign(offset.x), segment.position.y + offset.y + ant.radius * Maths.sign(offset.y));
        // var _offset:Vector = new Vector(segment.position.x + ant.radius * Maths.sign(offset.x), segment.position.y + ant.radius * Maths.sign(offset.y));

        var force:Vector = Mathf.calculateSpringForce(
            ant.position, // posA
            ant.velocity, // velA
            // _offset, // posB
            segment.position, // posB
            segment.velocity, // velB
            segment.radius * 0.5, // length
            15, // stiffness
            0.5  // damping
        );

        // ant.position.copy_from(segment.position);
        // ant.position.x += 16;
        if(force != null){
            ant.velocity.copy_from(force);
        }
        // ant.velocity.x = 0;
        // ant.velocity.y = 0;
    }

    public function destroy(){
        ant.tag = '';
        // ant.isStatic = false;
        Main.speed += ant.radius * 2;
        ant = null;
        segment = null;
    }
}

