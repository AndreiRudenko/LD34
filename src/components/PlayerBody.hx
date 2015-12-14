package components;

import luxe.Input;
import luxe.Sprite;
import luxe.Entity;
import luxe.Vector;
import luxe.Component;
import physics.Body;
import luxe.utils.Maths;
import utils.Mathf;
import utils.Constants;
import utils.Bits;
import utils.DebugDrawer;
import phoenix.geometry.QuadGeometry;
import phoenix.Texture;
import entities.Poop;

class PlayerBody extends Component{
    var _options:PlayerBodyOptions;
    var segments:Array<BodySegment>;
    var ants:Array<AntSegment>;
    var poops:Array<Poop>;
    var radius:Float;
    var group:Int;
    var mask:Int;
    var step:Float;
    var zero(default, null):Vector;
    var offset:Vector;
    var force:Vector;

    var headposY:Float;


    var texture:Texture;

    public var stiffness:Float = 10;
    public var damping:Float = 0.5;

    public var head:BodySegment;
    public var mouth:Body;

    public var size:Float;
    var sLen:Int;
    var sprite:Sprite;


    public function new(_opt:PlayerBodyOptions){
        _options = _opt;
        super(_options);
    }

    override function init(){

        sprite = cast entity;

        headposY = 370;
        size = 1;
        radius = _options.radius;
        step = _options.step;
        zero = new Vector();
        offset = new Vector();
        force = null;
        sLen = 0;

        group = Constants.GROUP_PLAYER1;
        mask = Bits.clrBits(Constants.GROUP_ALL, group);

        segments = [];
        ants = [];
        poops = [];

        // texture:Texture = Luxe.resources.texture('assets/segment1.png');
        texture = _options.texture;

        for (i in 0..._options.segments) {
            // var bd:BodySegment = new BodySegment(_texture, _pos, radius, group, mask);
            var _pos:Vector = new Vector(pos.x, pos.y + step * i);
            if(i == _options.segments - 1){
                var tex:Texture = Luxe.resources.texture('assets/segment2.png');
                segments.push(new BodySegment(entity, tex, _pos, radius, group, mask, 10 + i * 0.1));
            } else {
                segments.push(new BodySegment(entity, texture, _pos, radius, group, mask, 10 + i * 0.1));
            }
        }

        sLen = segments.length;

        head = segments[0];

        mouth = new Body({
            entity : entity,
            space : Physics.space,
            position : new Vector(pos.x, pos.y + radius * 2),
            tag : 'mouth', 
            radius : radius * 0.5,
            collisionGroup : group,
            collisionMask : mask,
            isSensor : true,
            // isStatic : true,
            gravityScale : 0
        });

        // DebugDrawer.draw_circle(mouth.position, mouth.radius, DebugDrawer.color_blue, false);

    }
    
    override public function onremoved() {
    }

    override public function ondestroy() {
        for (s in segments) {
            s.destroy();
        }
        for (a in ants) {
            a.destroy();
        }
        for (p in poops) {
            p.destroy();
        }

        _options = null;
        segments = null;
        ants = null;
        poops = null;
        offset = null;
        force = null;
        head = null;
        mouth = null;
        sprite = null;
    }

    override function update(dt:Float) {


        var n:Int = 0;
        var sLenHalf:Int = Std.int(sLen * 0.5);

        for (i in 0...sLen) {
            var s:BodySegment = segments[i];
            var prevS:BodySegment = segments[i - 1];


            s.sprite.scale.copy_from(entity.scale);
            s.body.radius = radius * entity.scale.x;
            s.body.mass = radius * 0.1 * entity.scale.x;

            if(i > sLenHalf){
                n++;
                var sc:Float = 1 - n * 0.2;
                sc = Math.pow(sc, 0.2);
                s.body.radius *= sc;
                s.body.mass *= sc;
                s.sprite.scale.x *= sc;
                s.sprite.scale.y *= sc;
            } else {
                var num:Int = (sLenHalf - 2 - i);
                if(num > 0){
                    var sc:Float = 1 - num * 0.2;
                    sc = Math.pow(sc, 0.3);
                    s.body.radius *= sc;
                    s.body.mass *= sc;
                    s.sprite.scale.x *= sc;
                    s.sprite.scale.y *= sc;
                }

            }

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
                if(i == 1){
                    var angle:Float = Mathf.angle(s.body.position, prevS.body.position);
                    sprite.rotation_z = Maths.degrees(angle) - 90;
                }


                offset.set_xy(prevS.body.position.x, prevS.body.position.y + step * entity.scale.x);
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
            if(a.ant == null){
                ants.remove(a);
                continue;
            }
            a.update(dt);
        }
        for (p in poops) {

            if(p.destroyed){
                poops.remove(p);
                continue;
            }

            p.collider.body.position.x = segments[sLen-1].body.position.x;
            p.collider.body.position.y = segments[sLen-1].body.position.y + p.collider.body.radius;

            p.time += dt;
            if(p.time >= p.maxTime){
                p.visible = true;
                poops.remove(p);
            }
        }


        pos.copy_from(head.body.position);

        mouth.position.x = pos.x + sprite.rotation_z * 0.4;
        mouth.position.y = pos.y - radius * 1.2 * entity.scale.x;
        mouth.velocity.copy_from(head.body.velocity);
        mouth.radius = radius * 0.5 * entity.scale.x;

        // DebugDrawer.draw_circle(mouth.position, mouth.radius, DebugDrawer.color_blue);
    }

    public function addAnt(_ant:Body, _segment:Body, _offset:Vector) {
        if(_segment.tag == 'mouth'){
            Luxe.audio.play('eat');

            entity.scale.addScalar(_ant.radius * 0.001);
            _ant.entity.destroy();
            Main.health += _ant.radius * 0.2;
            Main.score += _ant.radius;
            if(Main.health > 100){
                Main.health = 100;
            }
            // _ant.destroy();
            // var ps:Vector = segments[sLen-1].body.position.clone();
            var pp:Poop = new Poop({
                    name : 'Poop',
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    collisionGroup : group,
                    collisionMask : mask,
                    pos: segments[sLen-1].body.position.clone(),
                    radius: _ant.radius * 0.8,
                    depth:12,
                });

            pp.maxTime = _ant.radius * 0.1;
            poops.push(pp);
            return;
        }
        Luxe.audio.play('hit');

        ants.push(new AntSegment(_ant, _segment, _offset));
        entity.scale.subtractScalar(_ant.radius * 0.001);

        Main.health -= _ant.radius * 0.8;
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
    // public var sprite:QuadGeometry;
    public var sprite:Sprite;

    public function new(_entity:Entity, _texture:Texture, _pos:Vector, radius:Float, group:Int, mask:Int, depth:Float){
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

        sprite = new Sprite({
            // id : 'BodySegment.visual',
            name : 'segmentSprite',
            name_unique : true,
            pos : _pos,
            size : new Vector(radius * 2, radius * 2),
            // x : _pos.x,
            // y : _pos.y,
            // w : radius * 2,
            // h : radius * 2,
            // origin : new Vector(radius,radius),
            // scale : new Vector(1,1,1),
            texture : _texture,
            depth : depth,
            batcher : Luxe.renderer.batcher
        });
    }

    public function update(){
        sprite.transform.pos.copy_from(body.position);
    }

    public function destroy(){
        body.destroy();
        // sprite.drop(true);
        sprite.destroy();

        body = null;
        sprite = null;
    }
}

class AntSegment {
    public var segment(default, null):Body;
    public var ant(default, null):Body;
    public var offset(default, null):Vector;
    var timer:Float = 0;
    var maxTime:Float = 5;
    var massScale:Float = 2.5;

    public function new(_ant:Body, _segment:Body, _offset:Vector){
        ant = _ant;

        ant.entity.remove('AntAI');

        segment = _segment;
        offset = _offset;

        ant.tag = 'joinedAnt';
        ant.collisionMask = segment.collisionMask;
        // Main.speed -= ant.radius * massScale;
    }

    public function update(dt:Float){
        if(ant.tag != 'joinedAnt') return;
        if(ant == null || ant.entity.destroyed) {

            destroy();
            return;
        }



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
        timer += dt;

        if(timer >= maxTime * (ant.radius * 0.1)){
            destroy();
        }
    }

    public function destroy(){
        if(ant != null){
            ant.tag = '';  
        }

        // ant.collisionGroup = 0x00000001;
        // ant.collisionMask = 0xFFFFFFFF;
        // ant.isStatic = false;
        // Main.speed += ant.radius * massScale;
        ant = null;
        segment = null;
    }
}
