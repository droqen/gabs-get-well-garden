# API

what sort of things do you have access to, as a drifter? (this documentation may be out of date, but is hopefully useful anyway)

* Drifter
  * variables:
    * `cell:Vector2` - where is the drifter on the grid
    * `world:World` - the garden world
    * `guts:int` - how [gutsy](./tutorial#guts) is the drifter
    * `dead:bool` - is the drifter dead
  * methods:
    * note that you don't directly do anything, you just register intents with the game system, which will resolve everyone's intents after everyone has a chance to `evolve`
    * `drifter.intend_die()`
    * `drifter.intend_spawn(respath:String, dir:Vector2)`
    * `drifter.intend_move(dir:Vector2)`
    * `drifter.intend_transmute(respath:String)`
    * `drifter.intend_spawn_at(respath:String, newcell:Vector2)`
    * `drifter.intend_move_to(newcell:Vector2)`
    * `drifter.vibiest_dir(dirs:Array,weights:Dictionary) -> Vector2` - find the vibiest direction, weighted by the given elemental weights
* World
  * methods:
    * `vibe_nearby(cell:Vector2)` - a [weighted sum](#vibe_nearby) of the vibes of the 8 nearby tiles
    * `vibe_at(cell:Vector2)` - the vibe at a single cell in particular
    * `intend_kill(drifter:Drifter)`
    * `intend_spawn_at(respath:String, cell:Vector2)` - path is a resource path
    * `intend_move_to(drifter:Drifter, cell:Vector2)`
    * `log(msg:String)` - print a log of a thing that just happened to the player
* Vibe
  * methods:
    * `get_guts() -> int`
    * `get_element(typeid:String or Element) -> int`

## vibe_nearby

the weights are specifically like this; `(a,b)`, where `a` scales the major element and `b` scales the minor element:
```
  (1,0) (3,1) (1,0)
  (3,1) (0,0) (3,1)
  (1,0) (3,1) (1,0)
```
(the (0,0) weight in the center there represents the center cell)

for instance, a drifter right above me with major/minor elements Fire/Gem will contribute 3 vibe points of Fire to the return value of vibe_nearby, and 1 point of Gem.
