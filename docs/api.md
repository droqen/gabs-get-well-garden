# API

what sort of things do you have access to, as a drifter? (this documentation may be out of date, but is hopefully useful anyway)

* Drifter
  * variables:
    * `DirsOrthogonal` - a constant list of `Vector2`s for the 4 orthogonal directions
    * `DirsAdjacent` - a constant list of `Vector2`s for the 8 adjacent directions
    * `cell:Vector2` - where is the drifter on the grid
    * `world:World` - the garden world
    * `guts:int` - how [gutsy](./tutorial.md#guts) is the drifter
    * `dead:bool` - is the drifter dead
  * methods:
    * note that you don't directly do anything, you just register intents with the game system, which will resolve everyone's intents after everyone has a chance to `evolve`
    * `drifter.intend_die()` - die
    * `drifter.intend_kill(dir:Vector2)` - kill whatever is in the given direction
    * `drifter.intend_spawn(respath:String, dir:Vector2)` - spawn a drifter in a direction
    * `drifter.intend_move(dir:Vector2)` - move in a direction
    * `drifter.intend_transmute(respath:String)` - kill the drifter and replace it with another
    * `drifter.intend_clone(dir:Vector2)` - make a copy of the drifter in the given direction
    * `drifter.vibiest_dir(dirs:Array,weights:Dictionary) -> Vector2` - find the [vibiest direction](#vibiest_dir), weighted by the given elemental weights
* World
  * methods:
    * `world.vibe_nearby(cell:Vector2)` - a [weighted sum](#vibe_nearby) of the vibes of the 8 nearby tiles
    * `world.vibe_at(cell:Vector2)` - the vibe at a single cell in particular
    * `world.intend_kill_at(cell:Vector2)`
    * `world.intend_spawn_at(respath:String, cell:Vector2)` - path is a resource path
    * `world.intend_move_to(drifter:Drifter, cell:Vector2)`
    * `world.log(msg:String)` - print a log of a thing that just happened to the player
* Vibe
  * methods:
    * `vibe.get_guts() -> int`
    * `vibe.get_fire() -> int`
    * `vibe.get_water() -> int`
    * `vibe.get_earth() -> int`
    * `vibe.get_grass() -> int`
    * `vibe.get_wind() -> int`
    * `vibe.get_sand() -> int`
    * `vibe.get_gem() -> int`
    * `vibe.get_coal() -> int`
    * `vibe.get_element(typeid:Element) -> int` - use one of the above instead, probably

## vibe_nearby

the weights are specifically like this; `(a,b)`, where `a` scales the major element and `b` scales the minor element:
```
  (1,0) (3,1) (1,0)
  (3,1) (0,0) (3,1)
  (1,0) (3,1) (1,0)
```
(the (0,0) weight in the center there represents the center cell)

for instance, a drifter right above me with major/minor elements Fire/Gem will contribute 3 vibe points of Fire to the return value of vibe_nearby, and 1 point of Gem.

## vibiest_dir

gets the vibe in each given direction, and then evaluates each vibe according to the weights you give it. then, returns the direction with the highest vibe score.

for example, to find a direction with high Wind but low Coal (and additionally avoid existing things via Guts), use this:

```
vibiest_dir(DirsAdjacent,{"Wind":1, "Coal":-1, "Guts":-2})
```
