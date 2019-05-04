package object; 

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.input.FlxKeyManager;
import flixel.tweens.FlxTween;
// import flixel.math.FlxRandom;

import base.NormalObject;
import base.PlatformObject;

class Player extends NormalObject
{
    private var vibrateTimer:Int = 0;
    private var vibrateStrength:Int = 2;
    private var baseX:Float;
    private var baseY:Float;

    private var moving:Bool = false;

    public var faceDir:FaceDirection;
    
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY, true);

        // makeGraphic(Utils.tileWidth - 4, Utils.tileHeight - 4, FlxColor.GREEN);
        loadGraphic("assets/images/frog-sheet.png", true, 24, 24);
        offset.set(1, 6);

        faceDir = RIGHT;

        animation.add("lr-idle", [0], 6);
        animation.add("back-idle", [1], 6);
        animation.add("front-idle", [2], 6);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.LEFT) 
        {
            tryMove(-1, 0);
            faceDir = LEFT;
            animation.play("lr-idle", false);
            flipX = true;
        }
        else if (FlxG.keys.justPressed.RIGHT) 
        {
            tryMove(1, 0);
            faceDir = RIGHT;
            animation.play("lr-idle", false);
            flipX = false;
        }
        else if (FlxG.keys.justPressed.UP) 
        {
            tryMove(0, -1);
            animation.play("back-idle", false);
            flipX = false;
        }
        else if (FlxG.keys.justPressed.DOWN) 
        {
            tryMove(0, 1);
            animation.play("front-idle", false);
            flipX = false;
        }
        else if (FlxG.keys.justPressed.SPACE) 
        {
            wait();
        }

        if (vibrateTimer > 0) 
        {
            vibrateTimer -= 1;

            x = baseX + FlxG.random.int(-vibrateStrength, vibrateStrength);
            y = baseY + FlxG.random.int(-vibrateStrength, vibrateStrength);

            if (vibrateTimer <= 0)
            {
                x = baseX;
                y = baseY;
            }
        }
    }

    private function wait():Void
    {
        if (!ready()) return;

        state.startTurn();
        state.tick();
    }

    private function tryMove(dX:Int, dY:Int):Void 
    {
        if (!ready()) return;

        state.startTurn();

        var newX = gridX + dX;
        var newY = gridY + dY;

        if (newX < 0 || newX >= state.gridWidth || newY < 0 || newY > state.gridHeight)
        {
            vibrate(4);
            return;
        }

        var newPlatform = state.getPlatform(newX, newY);

        if (newPlatform != null)
        {
            if (newPlatform.hasObject()) 
            {
                var obj:NormalObject = newPlatform.getObject();
                if (obj != null)
                    obj.onBump();
                // interact with object on platform
                vibrate(4);
            }
            else
            {
                // move to new platform
                moving = true;

                gridX = newX;
                gridY = newY;

                var newPosX = Utils.gridToWorldCentreX(newX);
                var newPosY = Utils.gridToWorldCentreY(newY);
                // var newPosX = Utils.gridToWorldX(newX);
                // var newPosY = Utils.gridToWorldY(newY);

                // nb player has no platform mid jump
                platform.removeObject();

                FlxTween.tween(this, 
                               {x: newPosX, y: newPosY},                                
                               0.1, 
                               { onComplete: function(tween:FlxTween) {
                                    moving = false;
                                    platform = newPlatform;
                                   
                                    newPlatform.setObject(this);
                                    newPlatform.onMove(dX, dY);
                                    state.tick();
                               }});
            }
        }
        else
        {
            // do nothing
            vibrate(4);
        }
    }

    private function vibrate(duration:Int):Void
    {
        vibrateTimer = duration;
        baseX = x;
        baseY = y;
    }

    private function ready():Bool
    {
        return vibrateTimer <= 0 && !moving && !state.turnRunning;
    }

    override public function takeTurn():Void
    {

    }
}