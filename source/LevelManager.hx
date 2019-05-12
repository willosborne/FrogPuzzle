package;

class LevelManager
{
    var levels:Array<String> = [
        "assets/data/map-test.tmx",
		"assets/data/map-1.tmx",
		"assets/data/map-2.tmx",
		"assets/data/map-3.tmx"
    ];

    var currentLevel:Int;

    private var state:PlayState;

    public function new(state:PlayState) {
        this.state = state;

        currentLevel = 0;
        loadLevel(0);
    }

    public function loadLevel(newLevel:Int)
    {
        if (newLevel >= 0 && newLevel < levels.length)
        {
            currentLevel = newLevel;
            state.loadLevel(levels[currentLevel]);
        }
        else
        {
            trace('Invalid level index $newLevel');
        }
    }

    public function reloadLevel()
    {
        state.loadLevel(levels[currentLevel]);
    }

    public function nextLevel() 
    {
        if (currentLevel + 1 < levels.length)
            loadLevel(currentLevel + 1);
    }
}