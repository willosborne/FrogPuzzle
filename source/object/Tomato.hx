package object; 

import flixel.util.FlxColor;

import base.PushableObject;

import flixel.util.FlxColor;

class Tomato extends PushableObject
{   
    @:keep
    public function new(state:PlayState, gridX:Int, gridY:Int) 
    {
        super(state, gridX, gridY);
        
        // makeGraphic(Utils.tileWidth, Utils.tileHeight, FlxColor.BROWN);
        // centerOrigin();
        // loadGraphic(AssetPaths.goal__png, false, 24, 24);
        loadGraphic("assets/images/tomato-sheet.png", false, 24, 24);
        offset.set(0, 4);
        animation.add("idle", [0], 10, false);
    }
}