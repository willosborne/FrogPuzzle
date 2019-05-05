package;

import haxe.ds.GenericStack;

import base.PlatformObject;
import base.NormalObject;
import base.FloatingObject;
import base.FaceDirection;

typedef Grid<T> = Array<Array<T>>;

typedef PlatformState = { 
    x:Int, 
    y:Int, 
    object:ObjectState, 
    type:Class<PlatformObject>, 
    faceDir:FaceDirection
}
typedef ObjectState = { 
    type:Class<NormalObject>,
    faceDir:FaceDirection
}
typedef FloaterState = { 
    x:Int, 
    y:Int, 
    type:Class<FloatingObject>,
    faceDir:FaceDirection
}

typedef Snapshot = {
    platforms:Array<PlatformState>,
    floaters:Array<FloaterState>,
    flies:Int
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

    public function resetState()
    {
        if (!stack.isEmpty())
        {
            var item;
            do 
                item = stack.pop()
            while (stack.head != null);
            
            restoreState(item);
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
                    faceDir: obj.faceDir
                };
            }

            var platState:PlatformState = {
                x: platform.gridX,
                y: platform.gridY,
                type: Type.getClass(platform),
                object: objState,
                faceDir: platform.faceDir
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
                faceDir: floater.faceDir
            };

            floaterArr.push(flState);
        });
        return {
            platforms: platformArr,
            floaters: floaterArr,
            flies: state.flies
        };
    }

    private function restoreState(snapshot: Snapshot)
    {
        state.deleteAll();

        for (platState in snapshot.platforms) 
        {
            var plat:PlatformObject = Type.createInstance(platState.type, [state, platState.x, platState.y]);
            plat.setFaceDir(platState.faceDir);
            state.platforms.add(plat);

            if (platState.object != null)
            {
                var obj:NormalObject = Type.createInstance(platState.object.type, 
                                                           [state, platState.x, platState.y]);
                obj.setFaceDir(platState.object.faceDir);
                plat.setObject(obj);
                obj.platform = plat;
                state.objects.add(obj);
            }
            state.setPlatform(platState.x, platState.y, plat);
        }

        for (flState in snapshot.floaters) 
        {
            var fl:FloatingObject = Type.createInstance(flState.type, [state, flState.x, flState.y]);
            fl.setFaceDir(flState.faceDir);
            state.floaters.add(fl);

            state.setFloater(flState.x, flState.y, fl);
        }

        state.flies = snapshot.flies;
        state.endTurn();
    }
}