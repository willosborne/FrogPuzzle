package object; 

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

import base.PlatformObject;
import base.MoveAction;

class LilyPad extends PlatformObject
{
    var slideVelocity:Float = 100;
    public var sliding:Bool = false;
    private var killSliding=false;

    var targetGridX:Int;
    var targetGridY:Int;

    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY, rotates);
        
        loadGraphic("assets/images/lilypad-sheet.png", true, 24, 24);
        animation.add("idle", [0], 10, false);
        // centerOrigin();
    }

    override public function update(elapsed:Float)
    {
        if (x < -24 || y < -24
            || x > Utils.gridToWorldX(state.gridWidth) + 24
            || y > Utils.gridToWorldY(state.gridHeight) + 24)
        {
            if (hasObject()) 
            {
                object.kill();
                removeObject();
            }
            kill();
            return;
        }            

        // call triggers for current cell if it's sliding
        if (sliding && !killSliding) 
        {
            // call triggers, update cells
            var currentGridX = Utils.worldToGridX(x);
            var currentGridY = Utils.worldToGridY(y);


            if (currentGridX != gridX || currentGridY != gridY)
            {
                // if we have moved a square, update
                state.clearPlatform(gridX, gridY);
                state.setPlatform(currentGridX, currentGridY, this);

                gridX = currentGridX;
                gridY = currentGridY;
            }

            // TODO need more intelligent detection for when we are about to hit the wall
            var halfDX = Utils.tileWidth / 2 * Utils.sign(velocity.x); 
            var halfDY = Utils.tileHeight / 2 * Utils.sign(velocity.y); 

            var nextGridX = Utils.worldToGridX(x + halfDX + (velocity.x / FlxG.updateFramerate));
            var nextGridY = Utils.worldToGridY(y + halfDY + (velocity.y / FlxG.updateFramerate));

            if ((currentGridX == targetGridX && nextGridX != targetGridX) ||
                (currentGridY == targetGridY && nextGridY != targetGridY))
            {
                snapToGrid();
                sliding = false;
                velocity.set(0, 0);

                state.endTurn();
                state.tick();

                // trace("Bump");
            }
            
        }

        super.update(elapsed);
    }

    override public function takeTurn():Void
    {

    }

    override public function onMove(dX:Int, dY:Int) : MoveAction
    {
        if (state.platformCellFree(gridX + dX, gridY + dY))
        {
            // slide!
            slide(dX, dY);
            return SLIDE;
        }
        return NOTHING;
    }


    public function slide(dX:Int, dY:Int) : Void
    {
        var newGridX = gridX + dX;
        var newGridY = gridY + dY;

        if (state.outOfBounds(newGridX, newGridY))
            return;

        // cast a ray until we hit an object
        while (true)
        {
            var newX = newGridX + dX;
            var newY = newGridY + dY;

            if (state.outOfBounds(newX, newY))
            {
                // if this will take us out of bounds, set killsliding
                // killSliding will keep sliding until out of bounds, then kill lilypad+object
                killSliding = true;
                // trace('KILL');
                break;
            }

            if (!state.platformCellFree(newX, newY))
                break;
            newGridX = newX;
            newGridY = newY;
        }
        // TODO: handle case where lilypad floats offscreen

        state.turnRunning = true;
        sliding = true;

        velocity.x = dX * slideVelocity;
        velocity.y = dY * slideVelocity;

        targetGridX = newGridX;
        targetGridY = newGridY;

        // trace('Target: ($targetGridX, $targetGridY)');

        // lastGridX = gridX;
        // lastGridY = gridY;
    }
}