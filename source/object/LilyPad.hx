package object; 

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

import base.PlatformObject;

class LilyPad extends PlatformObject
{
    var slideVelocity:Float = 100;
    public var sliding:Bool = false;

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

        // call triggers for current cell if it's sliding
        if (sliding) 
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
                state.turnRunning = false;

                trace("Bump");
            }
            
        }

        super.update(elapsed);
    }

    override public function takeTurn():Void
    {

    }

    override public function onMove(dX:Int, dY:Int) : Void 
    {
        if (state.platformCellFree(gridX + dX, gridY + dY))
        {
            // slide!
            slide(dX, dY);
        }
    }

    public function slide(dX:Int, dY:Int) : Void
    {
        var newGridX = gridX + dX;
        var newGridY = gridY + dY;

        // cast a ray until we hit an object
        while (state.platformCellFree(newGridX + dX, newGridY + dY))
        {
            newGridX += dX;
            newGridY += dY;

            if (newGridX < 0 || newGridX >= state.gridWidth
                || newGridY < 0 || newGridY >= state.gridHeight)
            {   
                newGridX -= dX;
                newGridY -= dY;
                break;
            }
        }
        // TODO: handle case where lilypad floats offscreen

        state.turnRunning = true;
        sliding = true;

        velocity.x = dX * slideVelocity;
        velocity.y = dY * slideVelocity;

        targetGridX = newGridX;
        targetGridY = newGridY;

        // lastGridX = gridX;
        // lastGridY = gridY;
    }
}