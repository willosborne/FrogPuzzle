package object; 

import flixel.util.FlxColor;

import base.PushableObject;
import base.BumpAction;

import flixel.util.FlxColor;

class Block extends PushableObject
{   
    @:keep
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);
        
        // centerOrigin();
        // loadGraphic(AssetPaths.goal__png, false, 24, 24);
        loadGraphic("assets/images/block-sheet.png", true, 24, 24);
        animation.add("ground", [0], 10, false);
        animation.add("water", [1], 10, false);
        offset.set(0, 4);
        animation.play("ground");
    }

    override private function onSplash(x:Int, y:Int):BumpAction
    {
        if (state.outOfBounds(x, y))
            return BLOCK;
        var sunk = new BlockSunk(state, x, y);
        state.addPlatform(sunk);

        kill();

        return PUSH;
    }
}