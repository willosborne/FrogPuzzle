# Frog Puzzle notes

## Plan
- Frog tongue mechanics
- Objects you can push
- Other frogs
- Logs
- Sinking lilypads

## Core ideas
- Frog jumps around from one square to another
- Entire screen is pond, with small islands dotted around
- Falling into the pond fails the level
- Lilypads are moving platforms
- Frog can push things by jumping into them
- Frog has tongue that can pull things and itself around
- Tongue can reach over 1 tile


Is the game strictly turn-based?
e.g. if you are on a moving lilypad, can you grab objects with your tongue?
no, because that would make pulling things towards you confusing

## Objectives
- Get to certain point on screen?
- Eat all flies?
- Both?

## Other ideas
- Multiple frogs?
- Big frog only moves to follow food, too heavy for lilypads? Can push heavy things?
- Birds act as predators, swoop down

## Game objects
### Lilypads
Moving platforms that float on the water.
**Core**
- Jumping onto a lilypad causes it to slide until it hits an obstacle
- A moving lilypad stops when it hits a stationary lilypad
- The lilypad can be pulled while the frog is on it by latching onto an obstacle with the tongue
- A lilypad with an object on it can be pulled to the player with the tongue

**Extra ideas**
- Other objects can be pushed onto lilypads

### Sunken lilypads
Platforms that sink after 1 turn when the frog jumps on it.
Essentially acts as a barrier; things cannot be pushed over it.
Slow predator cannot pass it.

### Floating logs
Move like lilypads, but can't be jumped on

### Flies
Frog can catch flies with its tongue

### Predator
Moves slowly, c/2
Cannot move fast enough to jump over sunken lilies.

## Technical notes
- Two main superclasses: `PlatformObject` and `NormalObject`
- Could also have `FloatingObject`

### `NormalObject`
- A object on the same layer as the frog.
- Only one per tile.
- Frog can usually interact with it in some way
  - Solid object; frog cannot pass or move
  - Pushable object
  - Weak object; destroyed when frog moves into it
  - Lethal object; destroys frog on contact
- Objects may move on their own each turn, but that comes later

### `PlatformObject`
- One per tile
- Each can (usually) contain a single `NormalObject`
- The object moves with its platform unless it's being transferred to another platform

- Example interactions:
  - Slide when object pushed onto it
  - Kills frog if he jumps on
  - Destroys item 1 turn after it jumps on

- `PlatformObject` is for lilypads, regular ground, etc. 
- Each `PlatformObject` 

### Interfaces for actions
- eg `Pushable` defines a `push()` func which returns true if the object can be pushed
- Pushing an object first pushes its platform; if that doesn't move it does the whole object movement thing on top

### Turn structure
- User performs an action
- Disable user input
- If the action affects an object:
  - Run that action to completion
- For each object that needs to take a turn:
  - Do that to completion

#### Key notes:
- Do each turn one at a time, no simultaneous movement

What happens if an object is moving and it moves past an object it should interact with?
Could have 'trigger' objects that start new actions temporarily - stack of current actions