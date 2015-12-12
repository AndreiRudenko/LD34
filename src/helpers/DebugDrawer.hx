package helpers;

import phoenix.Color;
import phoenix.geometry.Geometry;
import phoenix.geometry.Vertex;
import phoenix.Vector;

class DebugDrawer{

     // If true, then all bodies in the space (whether active or not) will be drawn.
    public var drawBodies:Bool = true;
     // If true, then things like the body centre of mass, and bounding box will be drawn.
     // This will only have an effect if drawBodies is true.
    public var drawBodyDetail:Bool = true;
     // If true, then things like shape centre of mass and bounding box will be drawn.
     // This will only have an effect if drawBodies is true.
    public var drawShapeDetail:Bool = false;
     // If true, then indicators of the shapes rotation will be drawn.
     // This will only have an effect if drawBodies is true.
    public var drawShapeAngleIndicators:Bool = true;
     // If true, then representations of the active constraints will be drawn.
    public var drawConstraints:Bool = false;
     // The depth to draw the geometry at :todo:
    public static var depth:Float = 10.0;

    public static var color_gray = new Color(1,1,1,0.5);
	public static var color_gray_01 = new Color(1,1,1,0.1);
    public static var color_white = new Color(1,1,1,1);
    // public static var color_red = new Color(1,1,1,1).rgb(0xCC0000);
    // public static var color_green = new Color(1,1,1,1).rgb(0x00CC00);
    // public static var color_green = new Color(0,1,0,1);
    // public static var color_green_05 = new Color(0,1,0,0.5);
    // public static var color_green_02 = new Color(0,1,0,0.2);
    // public static var color_green_01 = new Color(0,1,0,0.1);
    // public static var color_yellow = new Color(1,1,0,1);
    public static var render_scale = new Vector(128,128);
    public static var render_scale2 = new Vector(32,32);

    public static var color_green:Color = new Color().rgb(0x3ED867);
    public static var color_green2:Color = new Color().rgb(0xA6F145);
    public static var color_blue:Color = new Color().rgb(0x4487C8);
    public static var color_bluegreen:Color = new Color().rgb(0xA6F145);
    public static var color_orange:Color = new Color().rgb(0xFFB549);
    public static var color_purple:Color = new Color().rgb(0x6D4CCE);
    public static var color_red:Color = new Color().rgb(0xFA4859);
    public static var color_yellow:Color = new Color().rgb(0xFFF949);
    public static var color_pink:Color = new Color().rgb(0xE84288);



    inline public static function draw_dot( position:Vector, color:Color, ?_immediate:Bool = true ) {

        Luxe.draw.rectangle({
            x: (position.x-3),
            y: (position.y-3),
            w: 6,
            h: 6,
            depth: depth,
            color: color,
            immediate:_immediate
        });

    } //draw_AABB

    inline public static function draw_line( p0:Vector, p1:Vector, color:Color, ?_immediate:Bool = true ) {

	    Luxe.draw.line({
	        p0: p0,
	        p1: p1,
	        color: color,
	        depth: depth,
	        immediate: _immediate
	    });

    } //draw_point

    inline public static function draw_ray( p0:Vector, p1:Vector, color:Color, ?_immediate:Bool = true ) {

	    Luxe.draw.line({
	        p0: p0,
	        p1: new Vector(p0.x + p1.x, p0.y + p1.y),
	        color: color,
	        depth: depth,
	        immediate: _immediate
	    });

    } //draw_point

    // inline public static function draw_polygon( bd:Array<Vector>, color:Color, ?_immediate:Bool = true ) {

    //     var g = new Geometry({
    //         primitive_type : phoenix.Batcher.PrimitiveType.line_loop,
    //         immediate: _immediate,
    //         depth: depth,
    //         batcher: Luxe.renderer.batcher,
    //         // color : color
    //     });

    //     for (v in bd) {
    //         g.add( new Vertex( new Vector(v.x, v.y).multiply(render_scale), color ) );
    //         draw_dot(v, color);
    //     }
    // }
 //    inline public static function draw_shape( sh:Array<JelloPointMass>, color:Color, ?_immediate:Bool = true ) {

	//     var g = new Geometry({
	//         primitive_type : phoenix.Batcher.PrimitiveType.line_loop,
	//         immediate: _immediate,
	//         depth: depth,
	//         batcher: Luxe.renderer.batcher,
	//         // color : color
	//     });

	//     for (v in sh) {
	//     	g.add( new Vertex( v.Position.toVec().multiply(render_scale), color ) );
	//     	draw_dot(v.Position, color);
	//     }
	// }

    inline public static function draw_circle( position:Vector,radius:Float, color:Color, _immediate:Bool = true ) {

        Luxe.draw.ring({
            x: position.x,
            y: position.y,
            r: radius,
            color: color,
            depth: depth,
            immediate: _immediate
        });

    } //draw_point

    inline public static function draw_point( position:Vector, color:Color, _immediate:Bool = true ) {

        Luxe.draw.ring({
            x: position.x,
            y: position.y,
            r: 2,
            color: color,
            depth: depth,
            immediate: _immediate
        });

    } //draw_point

    inline public static function draw_box( position:Vector, w:Float, h:Float, color:Color, _immediate:Bool = true ) {

        Luxe.draw.rectangle({
            x : position.x, y : position.y,
            w : w,
            h : h,
            origin : new Vector( w*0.5, h*0.5),
            color : color,
            depth : depth,
            immediate : _immediate
        });

    } //draw_point

    inline public static function draw_aabb( position:Vector, half:Vector, color:Color, _immediate:Bool = true ) {

        Luxe.draw.rectangle({
            x : position.x, y : position.y,
            w : half.x*2,
            h : half.y*2,
            origin : new Vector( half.x, half.y),
            depth : depth,
            color : color,
            immediate : _immediate
        });
        // draw_text(position, position.y);

    } //draw_point

    inline public static function draw_text( position:Vector, text:Dynamic, _immediate:Bool = true ) {

        Luxe.draw.text({
            // pos : Vector.Add(collA.pos , collB.pos).multiplyScalar(0.5),
            pos : position.clone(),
            text : "\ntext: = " + text,
            point_size : 12,
            depth : depth,
            immediate : _immediate
        });
    } //draw_point

    inline public static function draw_polygon( position:Vector, verts:Array<Vector>, color:Color, _immediate:Bool = true ) {
        var _verts:Array<Vector> = [];
        for (v in verts) {
            _verts.push(v.clone().add(position));
        }
        drawVertList(_verts, color, _immediate);

    }

    static function drawVertList(_verts : Array<Vector>, color:Color, _immediate:Bool = true ) {

        var _count : Int = _verts.length;
        if(_count < 3) {
            throw "cannot draw polygon with < 3 verts as this is a line or a point.";
        }

            //start the polygon by drawing this start point
        draw_line( _verts[0], _verts[1], color, _immediate );

            //draw the rest of the points
        for(i in 1 ... _count-1) {
            draw_line( _verts[i], _verts[i+1], color, _immediate );
        }
            //join last point to first point
        draw_line( _verts[_count-1], _verts[0], color, _immediate );

    } //drawVertList



}
