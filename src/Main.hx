
import luxe.Input;
import luxe.Sprite;
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
import game.Spawner;
import phoenix.geometry.TextGeometry;
import phoenix.Texture.ClampType;

class Main extends luxe.Game {
    public static var hud_batcher:Batcher;
    public static var playerPos:Vector;
    public static var playerScale:Float;
    public static var speed(default, null):Float;
    public static var score:Float;
    public static var health:Float;
    public static var game_is_started:Bool = false;

    var fps:Fps;

    var active:Bool = false;
    var spawntimer:Float = 2.5;
    var timer:Float = 0;

    var speedText : TextGeometry;
    var scoreText : TextGeometry;
    var scoreTextBig : TextGeometry;
    var maxSpeedText : TextGeometry;
    var healthText : TextGeometry;

    var spawner : Spawner;

    var bg:Sprite;
    var menu:Sprite;
    var menu2:Sprite;
    var player:Player;
    var bestScore:Float;
    var maxSpeed:Float;
    var maxBestSpeed:Float;
    var tSpeed:Float;

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
        Luxe.audio.loop('theme2');
        tSpeed = 0;
        maxSpeed = 0;
        maxBestSpeed = 0;
        bestScore = 0;
        score = 0;
        playerScale = 1;
        playerPos = new Vector();
        spawner = new Spawner();

        speed = 800;
        health = 100;

        // start_game();

        menu = new Sprite({
            // size : new Vector(Luxe.screen.w, Luxe.screen.w / ratio),
            size : new Vector(Luxe.screen.w, Luxe.screen.h),
            centered : false,
            texture: Luxe.resources.texture('assets/menu.png'),
            depth : 100
        });

        menu2 = new Sprite({
            // size : new Vector(Luxe.screen.w, Luxe.screen.w / ratio),
            visible : false,
            pos : Luxe.screen.mid.clone(),
            scale : new Vector(0.75, 0.75),
            // size : new Vector(Luxe.screen.w, Luxe.screen.h),
            // centered : false,
            texture: Luxe.resources.texture('assets/menu2.png'),
            depth : 100
        });

    }

    function start_game() {

        maxSpeed = 0;
        score = 0;
        playerScale = 1;
        health = 100;

        if(player == null){
            player = new Player({
                name : 'Player1',
                // name_unique : true,
                pos: new Vector(Luxe.screen.mid.x, 370),
                radius: 16,
                // isStatic : true,
                depth:50,
                texture : Luxe.resources.texture('assets/head.png')
            });
        } else {
            // player.visible = true;
            player.body.head.body.position.x = Luxe.screen.mid.x;
            player.body.head.body.position.y = 370;
            player.scale.set_xy(1,1);
        }

        if(bg == null){

            bg = new Sprite({
                // size : new Vector(Luxe.screen.w, Luxe.screen.w / ratio),
                size : new Vector(Luxe.screen.w, Luxe.screen.h),
                centered : false,
                texture: Luxe.resources.texture('assets/tile1.png'),
                depth : 1
            });
            bg.texture.clamp_s = bg.texture.clamp_t = ClampType.repeat;
        } else {
            // bg.visible = true;
        }


        game_is_started = true;
    }

    function restart_game() {

        menu.visible = false;
        menu2.visible = false;

        speedText.visible = true;
        scoreText.visible = true;
        healthText.visible = true;
        maxSpeedText.visible = false;
        scoreTextBig.visible = false;

        spawner.reset();
        // player.destroy();

        for (b in Physics.space.bodies) {
            if(b.tag == 'segment' || b.tag == 'mouth') continue;
            b.entity.destroy();
        }

        // player.body.head.body.position.x = Luxe.screen.mid.x;
        // player.body.head.body.position.y = Luxe.screen.mid.y;

        start_game();
    }


    function create_hud() {

        hud_batcher = new Batcher(Luxe.renderer, 'hud_batcher');
        var hud_view = new Camera();
        hud_batcher.view = hud_view;
        hud_batcher.layer = 2;
        Luxe.renderer.add_batch(hud_batcher);


        speedText = new TextGeometry({
            pos: new Vector(20,Luxe.screen.height - 20),
            align: left,
            point_size: 14,
            batcher: hud_batcher
        });

        scoreText = new TextGeometry({
            pos: new Vector(Luxe.screen.width - 100 ,Luxe.screen.height - 20),
            align: left,
            point_size: 14,
            batcher: hud_batcher
        });

        healthText = new TextGeometry({
            pos: new Vector(Luxe.screen.mid.x - 30 ,Luxe.screen.height - 20),
            align: left,
            point_size: 14,
            batcher: hud_batcher
        });

        scoreTextBig = new TextGeometry({
            pos: new Vector(Luxe.screen.mid.x ,Luxe.screen.mid.y + 70),
            align: center,
            point_size: 18,
            batcher: hud_batcher
        });
        scoreTextBig.visible = false;

        maxSpeedText = new TextGeometry({
            pos: new Vector(Luxe.screen.mid.x ,Luxe.screen.mid.y + 100),
            align: center,
            point_size: 18,
            batcher: hud_batcher
        });
        maxSpeedText.visible = false;

        // var fps:Fps = new Fps(hud_batcher);
        // fps = new Fps();

    }

    override function onkeyup( e:KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

        // if(e.keycode == Key.key_v) {
        //     health = 0;
        // }

        if(e.keycode == Key.space) {
            restart_game();
        }

    }

    override function update(dt:Float) {
        if(!game_is_started) return;

        tSpeed = speed * playerScale * 0.25;

        score = score + tSpeed * Luxe.physics.step_delta * Luxe.physics.step_delta ;

        speedText.text = 'SPEED : ' + Math.round(tSpeed) + 'm/h';
        scoreText.text = 'SCORE : ' + Math.round(score);
        healthText.text = 'HP : ' + Math.ceil(health);


        if(playerPos.y >= Luxe.screen.height - 20){
            health = 0;
            playerPos.y = 370;
        }

        if(health <= 0 ){
            game_is_started = false;
            health = 0;

            if(score > bestScore){
                bestScore = score;
            }

            if(maxSpeed > maxBestSpeed){
                maxBestSpeed = maxSpeed;
            }

            menu2.visible = true;
            speedText.visible = false;
            scoreText.visible = false;
            healthText.visible = false;
            maxSpeedText.visible = true;
            scoreTextBig.visible = true;

            scoreTextBig.text = 'YOUR SCORE IS : ' + Math.round(score) + ' / BEST : ' + Math.round(bestScore);
            maxSpeedText.text = 'MAX SPEED IS  : ' + Math.round(maxSpeed) + ' / BEST : ' + Math.round(maxBestSpeed);
            return;
        }

        if(tSpeed > maxSpeed){
            maxSpeed = tSpeed;
        }

        Physics.space.gravity.y = speed * playerScale;

        // Physics.space.step( Luxe.physics.step_delta * Luxe.timescale);
        Physics.space.step( Luxe.physics.step_delta);



        if(speed * playerScale < 300){
            speed -= 0.01;
        }

        timer += Luxe.physics.step_delta * speed * playerScale * 0.0015;
        if(timer >= spawntimer + Math.random()){
            spawner.spawn();
            timer = 0;
        }
        // bg.uv.y -= speed * playerScale * Luxe.physics.step_delta * Luxe.physics.step_delta;
        // bg.uv.y -= speed * playerScale * Luxe.physics.step_delta * 0.0294;
        bg.uv.y -= speed * playerScale * Luxe.physics.step_delta * 0.0376;

        if(maxSpeed > maxBestSpeed){
            maxBestSpeed = maxSpeed;
        }


    }


}
