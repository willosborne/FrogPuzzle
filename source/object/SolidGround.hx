package object; 

import flixel.util.FlxColor;

import base.PlatformObject;
import base.MoveAction;

class SolidGround extends PlatformObject
{
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);

        set_visible(false);
        
        // makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.GRAY);
        // centerOrigin();
    }

    override public function onMove(dX:Int, dY:Int) : MoveAction
    {
        state.endTurn();
        return NOTHING;
    }
}