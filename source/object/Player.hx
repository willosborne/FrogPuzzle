package object; 

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.input.FlxKeyManager;
import flixel.tweens.FlxTween;
// import flixel.math.FlxRandom;

import base.NormalObject;
import base.PlatformObject;

import base.FaceDirection;

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

        if (ready())
        {
            if (FlxG.keys.justPressed.LEFT) 
            {
                tryMove(-1, 0);
                setFaceDir(LEFT);
            }
            else if (FlxG.keys.justPressed.RIGHT) 
            {
                tryMove(1, 0);
                setFaceDir(RIGHT);
            }
            else if (FlxG.keys.justPressed.UP) 
            {
                tryMove(0, -1);
                setFaceDir(UP);
            }
            else if (FlxG.keys.justPressed.DOWN) 
            {
                tryMove(0, 1);
                setFaceDir(DOWN);
            }
            else if (FlxG.keys.justPressed.SPACE) 
            {
                wait();
            }
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

    //TODO weird stuff when you try to move on a moving platform
    private function tryMove(dX:Int, dY:Int):Void 
    {
        if (!ready()) 
            return;

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
                state.startTurn();

                var obj:NormalObject = newPlatform.getObject();
                if (obj == null)
                    throw "Platform hasObject(), but getObject() returned null. Something wrong here.";
                var bumpAction = obj.onBump();

                // NB object has already performed its bump action by now
                // TODO make object slide if:
                //  - On a lilypad
                //  - Not KILL or DESTROY

                // interact with object on platform
                switch bumpAction {
                    case BLOCK:
                        vibrate(4);
                    case KILL:
                        // kill player
                        trace("You died!");
                        kill();
                    case PUSH:
                        // push object
                    case DESTROY:
                        // destroy object and move to its tile
                        obj.kill();
                        newPlatform.removeObject();
                        moveTo(newX, newY);
                }
            }
            else
            {
                state.startTurn();
                // move to new platform
                moveTo(newX, newY);
            }
        }
        else
        {
            // do nothing
            vibrate(4);
        }
    }

    private function moveTo(newX:Int, newY:Int)
    {
        moving = true;

        var dX = newX - gridX;
        var dY = newY - gridY;

        gridX = newX;
        gridY = newY;
        
        var newPlatform = state.getPlatform(newX, newY);

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

    override public function setFaceDir(dir:FaceDirection)
    {
        switch(dir)
        {
            case UP:
                animation.play("back-idle", false);
                flipX = false;
            case DOWN:
                animation.play("front-idle", false);
                flipX = false;

            case LEFT:
                animation.play("lr-idle", false);
                flipX = true;

            case RIGHT:
                animation.play("lr-idle", false);
                flipX = false;
        }

        super.setFaceDir(dir);
    }
}