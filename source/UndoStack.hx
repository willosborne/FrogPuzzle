package;

import haxe.ds.GenericStack;

import base.PlatformObject;
import base.NormalObject;
import base.FloatingObject;

typedef Grid<T> = Array<Array<T>>;

typedef PlatformState = { 
    x:Int, 
    y:Int, 
    object:ObjectState, 
    type:Class<PlatformObject>, 
    facing:Int
}
typedef ObjectState = { 
    type:Class<NormalObject>,
    facing:Int
}
typedef FloaterState = { 
    x:Int, 
    y:Int, 
    type:Class<FloatingObject>,
    facing:Int
}

typedef Snapshot = {
    platforms:Array<PlatformState>,
    floaters:Array<FloaterState>
}

class UndoStack
{
    private var stack:GenericStack<Snapshot>;
    private var state:PlayState;

    public function new(state:PlayState)
    {
        this.state = state;
        stack = new GenericStack<Snapshot>();
    }

    public function pushState() 
    {
        var snap:Snapshot = saveState();
        // trace(snap);
        stack.add(snap);
    }

    public function popState()
    {
        if (!stack.isEmpty()) 
        {
            trace("Undo!");
            var snap:Snapshot = stack.pop();
            restoreState(snap);
        }
    }

    private function saveState() : Snapshot
    {
        var platformArr:Array<PlatformState> = [];

        state.platforms.forEachAlive(function(platform)
        // for (platform in state.platforms)
        {
            var objState:ObjectState = null;
            if (platform.hasObject()) 
            {
                var obj:NormalObject = platform.getObject();

                objState = {
                    type: Type.getClass(obj),
                    facing: obj.facing
                };
            }

            var platState:PlatformState = {
                x: platform.gridX,
                y: platform.gridY,
                type: Type.getClass(platform),
                object: objState,
                facing: platform.facing
            };

            platformArr.push(platState);
        });

        var floaterArr:Array<FloaterState> = [];

        state.floaters.forEachAlive(function(floater)
        // for (platform in state.platforms)
        {

            var flState:FloaterState = {
                x: floater.gridX,
                y: floater.gridY,
                type: Type.getClass(floater),
                facing: floater.facing
            };

            floaterArr.push(flState);
        });
        return {
            platforms: platformArr,
            floaters: floaterArr
        };
    }

    private function restoreState(snapshot: Snapshot)
    {
        state.deleteAll();

        for (platState in snapshot.platforms) 
        {
            var plat:PlatformObject = Type.createInstance(platState.type, [state, platState.x, platState.y]);
            plat.facing = platState.facing;
            state.platforms.add(plat);

            if (platState.object != null)
            {
                var obj:NormalObject = Type.createInstance(platState.object.type, 
                                                           [state, platState.x, platState.y]);
                obj.facing = platState.object.facing;
                plat.setObject(obj);
                obj.platform = plat;
                state.objects.add(obj);
            }
            state.setPlatform(platState.x, platState.y, plat);
        }

        //TODO: check that restoring floaters works
        for (flState in snapshot.floaters) 
        {
            var fl:FloatingObject = Type.createInstance(flState.type, [state, flState.x, flState.y]);
            fl.facing = flState.facing;
            state.floaters.add(fl);

            state.setFloater(flState.x, flState.y, fl);
        }
    }
}