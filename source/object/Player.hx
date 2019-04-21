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
    
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY, true);

        makeGraphic(Utils.tileWidth - 4, Utils.tileHeight - 4, FlxColor.GREEN);
        offset.set(-2, -2);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.LEFT) 
        {
            tryMove(-1, 0);
        }
        else if (FlxG.keys.justPressed.RIGHT) 
        {
            tryMove(1, 0);
        }
        else if (FlxG.keys.justPressed.UP) 
        {
            tryMove(0, -1);
        }
        else if (FlxG.keys.justPressed.DOWN) 
        {
            tryMove(0, 1);
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

    private function tryMove(dX:Int, dY:Int):Void 
    {
        if (!ready()) return;

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