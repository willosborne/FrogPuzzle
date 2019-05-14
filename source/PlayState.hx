package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import flixel.util.FlxColor;

import base.PlatformObject;
import base.NormalObject;
import base.FloatingObject;
import base.PushableObject;

// all of these need to be imported, or the optimiser deletes the classes
// even when i specifically set the @keep attribute. Cool
import object.SolidGround;
import object.Tree;
import object.Player;
import object.LilyPad;
import object.Goal;
import object.Fly;
import object.Block;
import object.BlockSunk;
import object.Tomato;

import UndoStack;

class PlayState extends FlxState
{
	public var platformGrid:Grid<PlatformObject>;
	public var floaterGrid:Grid<FloatingObject>;

	private var undoStack:UndoStack;

	public var gridWidth:Int = 10;
	public var gridHeight:Int = 10;

	public var platforms:FlxTypedGroup<PlatformObject>;
	public var objects:FlxTypedGroup<NormalObject>;
	public var floaters:FlxTypedGroup<FloatingObject>;

	// private var renderGroup:FlxTypedGroup<FlxSprite>;

	public var turnRunning:Bool = false;

	public var levelManager:LevelManager;

	public var flies:Int;

	private var flyCounter:FlxText;
	private var levelNameText:FlxText;

	override public function create():Void
	{
		set_bgColor(0xFF639BFF);
		platforms = new FlxTypedGroup<PlatformObject>();
		objects = new FlxTypedGroup<NormalObject>();
		floaters = new FlxTypedGroup<FloatingObject>();
		// renderGroup = new FlxTypedGroup<FlxSprite>();

		levelManager = new LevelManager(this);
		
		// add(new FlxText(10, 10, 100, "Hello world!"));

		FlxG.mouse.visible = false;

		FlxG.console.registerFunction("loadLevel", function(level:Int) {
			levelManager.loadLevel(level);
		});

		super.create();
	}

	public function loadLevel(path:Dynamic)
	{
		// deleteAll();
		this.clear();
		turnRunning = false;
		var level:LevelLoader = new LevelLoader(path, this);

		trace('Loading level ${level.name}');

		// renderGroup.clear();

		platforms = level.platforms;
		objects = level.objects;
		floaters = level.floaters;

		platforms.forEach(function (plat) {
			plat.create();
		});
		
		flyCounter = new FlxText(10,24, 100, "Flies: 0");
		levelNameText = new FlxText(10, 10, 100, level.name);

		add(level.bgTilemaps);

		// add(renderGroup)

		add(level.platforms);
		add(level.objects);
		add(level.floaters);

		// add(flyCounter);
		add(levelNameText);

		platformGrid = level.platformGrid;
		floaterGrid = level.floaterGrid;
		
		flies = 0;
		
		undoStack = new UndoStack(this);
	}

	public function win() {
		trace('Level complete!\nFlies: $flies');
	}

	override public function update(elapsed:Float):Void
	{
		#if sys
			if (FlxG.keys.anyJustPressed([Q, ESCAPE]))
			{
				Sys.exit(0);
			}
		#end

		if (FlxG.keys.justPressed.Z)
		{
			undoStack.popState();
		}

		if (FlxG.keys.justPressed.R)
		{
			// if (!turnRunning)
			if (FlxG.keys.pressed.SHIFT)
				levelManager.reloadLevel();
			else
				undoStack.resetState();
		}

		if (FlxG.keys.justPressed.W)
		{
			FlxG.resetState();
		}
        if (FlxG.keys.justPressed.RBRACKET) 
        {
            levelManager.nextLevel();
        }

		// flyCounter.text = 'Flies: $flies';

		objects.sort(FlxSort.byY, FlxSort.ASCENDING);

		super.update(elapsed);
	}
    
	public function outOfBounds(x:Int, y:Int) : Bool
    {
        return x < 0 || x >= gridWidth ||
               y < 0 || y >= gridHeight;
    }

	public function addPlatform(obj:PlatformObject):Void 
	{
		platformGrid[obj.gridX][obj.gridY] = obj;
		platforms.add(obj);
	}

	public function addObject(obj:NormalObject):Void
	{
		objects.add(obj);
	}

	public function platformCellFree(gridX:Int, gridY:Int) : Bool
	{
		return getPlatform(gridX, gridY) == null;
	}

	public function getPlatform(gridX:Int, gridY:Int):PlatformObject
	{
		return platformGrid[gridX][gridY];
	}

	public function clearPlatform(gridX:Int, gridY:Int) : Void 
	{
		platformGrid[gridX][gridY] = null;
	}
	
	public function setPlatform(gridX:Int, gridY:Int, obj:PlatformObject) : Void 
	{
		platformGrid[gridX][gridY] = obj;
	}


	public function getFloater(gridX:Int, gridY:Int):FloatingObject
	{
		return floaterGrid[gridX][gridY];
	}

	public function clearFloater(gridX:Int, gridY:Int) : Void 
	{
		floaterGrid[gridX][gridY] = null;
	}
	
	public function setFloater(gridX:Int, gridY:Int, obj:FloatingObject) : Void 
	{
		floaterGrid[gridX][gridY] = obj;
	}

	public function deleteAll() : Void
	{
		platformGrid = [for (x in 0...gridWidth) [for (y in 0...gridHeight) null]];
		platforms.clear(); // NOTE: do I need to destroy everything?
		floaterGrid = [for (x in 0...gridWidth) [for (y in 0...gridHeight) null]];
		floaters.clear(); // NOTE: do I need to destroy everything?
		objects.clear();

		flies = 0;
	}
	
	public function startTurn()
	{
		undoStack.pushState();
	}

	public function updateFloaters()
	{
		for (x in 0...gridWidth)
		{
			for (y in 0...gridHeight)
			{
				// trace('X: $x, Y: $y');
				if (floaterGrid[x][y] != null)
				{
					var plat = platformGrid[x][y];
					if (plat != null)
					{
						if (plat.hasObject())
							floaterGrid[x][y].onHover(plat.getObject());
					}
				}
			}
		}
	}

	public function tick()
	{
		updateFloaters();
	}

	public function endTurn()
	{
		turnRunning = false;
	}
}
