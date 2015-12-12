
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


class Main extends luxe.Game {
    public static var hud_batcher:Batcher;

    override function ready() {
        // Luxe.renderer.vsync = true;

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
            for (i in 0...10) {
                new Circle({
                    name : 'Circle' + i,
                    name_unique : true,
                    // pos: new Vector(Std.random(400)+50,Std.random(400)+50),
                    pos: new Vector(Std.random(400)+50,Std.random(400)-500),
                    radius: Std.random(24) + 16,
                    isStatic : true,
                    depth:2,
                    texture:Luxe.resources.texture('assets/circle.png')
                });
            }
        }

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    }

    override function update(dt:Float) {

    }


}
