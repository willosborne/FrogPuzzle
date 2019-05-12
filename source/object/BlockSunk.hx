package object; 

import flixel.util.FlxColor;

import base.PlatformObject;

class BlockSunk extends PlatformObject
{
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);
        loadGraphic("assets/images/block-sheet.png", true, 24, 24);

        animation.add("ground", [0], 10, false);
        animation.add("water", [1], 10, false);
        offset.set(0, 4);
        animation.play("water");
        
        // makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.GRAY);
        // centerOrigin();
    }

    override public function onMove(dX:Int, dY:Int) : Void
    {
        state.endTurn();
    }
}