package base; 

import flixel.FlxSprite;

@:keepSub class FloatingObject extends FlxSprite 
{
    public var rotates:Bool;

    var state:PlayState;

    public var gridX:Int;
    public var gridY:Int;

    public function new(state:PlayState, gridX:Int, gridY:Int, ?rotates:Bool=false) 
    {
        this.state = state;
        this.rotates = rotates;
        
        this.gridX = gridX;
        this.gridY = gridY;
        
        var cX = Utils.gridToWorldCentreX(gridX);
        var cY = Utils.gridToWorldCentreY(gridY);
        // var cX = Utils.gridToWorldX(gridX);
        // var cY = Utils.gridToWorldY(gridY);

        super(cX, cY);
    }

    public function takeTurn():Void
    {
    }

    /***
    Called once per turn when an object is underneath it. 
    Only happens on *full* turns - that is, an platform sliding past will not trigger this.
    @param obj The object underneath.
    **/
    public function onHover(obj:NormalObject)
    {
    }
}