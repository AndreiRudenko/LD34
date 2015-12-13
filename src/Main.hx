
import luxe.Input;
import luxe.Vector;
import components.Collider;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.resource.Resource;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Camera;
import utils.Fps;
import entities.Circle;
import entities.Player;
import entities.Ant;


class Main extends luxe.Game {
    public static var hud_batcher:Batcher;
    public static var playerPos:Vector;
    public static var speed:Float;

    var spawntimer:Float = 2.5;
    var timer:Float = 0;

    override function ready() {
        Luxe.renderer.vsync = true;

        Luxe.physics.add_engine( Physics );
        Luxe.resources.load_json('assets/parcel.json').then(function(json:JSONResource) {
            var parcel = new Parcel();
            parcel.from_json(json.asset.json);

            var progress = new ParcelProgress({
                parcel      : parcel,
                background  : new Color(1,1,1,0.85),
                oncomplete  : assets_loaded
            });
            parcel.load();
        });
    }

    function assets_loaded(_) {
        create_hud();

        playerPos = new Vector();
        speed = 600;

        new Player({
            name : 'Player1',
            // name_unique : true,
            pos: new Vector(240, 600),
            radius: 16,
            // isStatic : true,
            depth:2,
            texture:Luxe.resources.texture('assets/circle.png')
        });

        for (i in 0...0) {
            new Circle({
                name : 'Circle' + i,
                name_unique : true,
                pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                radius: 16,
                isStatic : false,
                depth:2,
                texture:Luxe.resources.texture('assets/circle.png')
            });
        }
    }

    function create_hud() {

        hud_batcher = new Batcher(Luxe.renderer, 'hud_batcher');
        var hud_view = new Camera();
        hud_batcher.view = hud_view;
        hud_batcher.layer = 2;
        Luxe.renderer.add_batch(hud_batcher);

        var fps:Fps = new Fps(hud_batcher);
    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.key_n) {

        }

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    function spawn() {
        spawnRocks(Std.random(2)+1, Std.random(2)+2);
        spawnSand(Std.random(3)+1, Std.random(7)+3);
        spawnAnts(Std.random(2)+1, Std.random(3)+1);
    }

    function spawnRocks(_num1:Int, _num2:Int) {
        for (i in 0..._num1) {
            var rX:Float = Std.random(480);
            var rY:Float = Std.random(400)-500;
            for (j in 0..._num2) {
                new Circle({
                    name : 'Circle' + i,
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    pos: new Vector(Std.random(32) + rX - 32 , Std.random(32) + rY - 32),
                    radius: Std.random(24) + 16,
                    depth:2,
                    // texture:Luxe.resources.texture('assets/circle.png')
                });
            }
        }
    }

    function spawnSand(_num1:Int, _num2:Int) {
        for (i in 0..._num1) {
            var rX:Float = Std.random(480);
            var rY:Float = Std.random(400)-500;
            for (j in 0..._num2) {
                new Circle({
                    name : 'Circle' + i,
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    pos: new Vector(Std.random(96) + rX - 96 , Std.random(96) + rY - 96),
                    radius: Std.random(12) + 4,
                    depth:2,
                    // texture:Luxe.resources.texture('assets/circle.png')
                });
            }
        }
    }

    function spawnAnts(_num1:Int, _num2:Int) {
        for (i in 0..._num1) {
            var rX:Float = Std.random(480);
            var rY:Float = Std.random(400)-500;
            for (j in 0..._num2) {
                new Ant({
                    name : 'Ant' + i,
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    pos: new Vector(Std.random(48) + rX - 48 , Std.random(48) + rY - 48),
                    radius: Std.random(8) + 8,
                    depth:2,
                    // texture:Luxe.resources.texture('assets/circle.png')
                });
            }
        }
    }

    override function update(dt:Float) {

        Physics.space.gravity.y = speed;

        Physics.space.step( Luxe.physics.step_delta * Luxe.timescale);

        timer += dt;
        if(timer >= spawntimer + Math.random()){
            spawn();
            timer = 0;
        }
    }


}
