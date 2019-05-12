package base; 

import flixel.tweens.FlxTween;

@:keepSub class PushableObject extends NormalObject
{
    public function new(state:PlayState, gridX:Int, gridY:Int, ?rotates:Bool=false) 
    {
        super(state, gridX, gridY, rotates);
    }

    /***
    Called when a PushableObject is pushed onto an empty tile.
    Default behaviour is just to BLOCK
    **/
    private function onSplash(x:Int, y:Int) : BumpAction
    {
        // by default, we just do nothing - cannot fall into water
        return BLOCK;
    }


    override public function onBump(?dX:Int=0, ?dY:Int=0) : BumpAction
    {
        var newX = gridX + dX;
        var newY = gridY + dY;

        // check if it has somewhere to go
        var plat:PlatformObject = state.getPlatform(newX, newY);
        // if it has nowhere to go, run onSplash and return its result
        // this lets objects fall into the water, and other shenanigans
        if (plat == null)
            return onSplash(newX, newY);
        
        // if there is a platform, does it have an object?
        if (plat.hasObject())
        {
            var action = plat.getObject().onBump(dX, dY);
            if (action == BLOCK)
                return BLOCK;
            else if (action == PUSH)
            {
                moveTo(newX, newY);
                return PUSH;
            }
        }
        else 
        {
            // no object, can move here
            //NOTE: gonna be some potential issues with the async stuff
            moveTo(newX, newY);
            return PUSH;
        }
        return PUSH;
    }

    private function moveTo(newX:Int, newY:Int)
    {
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
                            platform = newPlatform;
                            
                            newPlatform.setObject(this);
                            newPlatform.onMove(dX, dY);
                            // state.tick();
                        }});
    }
}