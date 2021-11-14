# API

what sort of things do you have access to, as a drifter? (this documentation may be out of date, but is hopefully useful anyway)

* Drifter
    * variables:
        * `DirsOrthogonal` - a constant list of `Vector2`s for the 4 orthogonal directions
        * `DirsAdjacent` - a constant list of `Vector2`s for the 8 adjacent directions
        * `cell:Vector2` - where is the drifter on the grid
        * `world:World` - the garden world
        * `guts:int` (0-100) - how [gutsy](./tutorial.md#guts) is the drifter
        * `dead:bool` - is the drifter dead
    * methods:
        * note that you don't directly do anything, you just register intents with the game system, which will resolve everyone's intents after everyone has a chance to `evolve`
        * `drifter.intend_die()` - die
        * `drifter.intend_kill(dir:Vector2)` - kill whatever is in the given direction
        * `drifter.intend_spawn(respath:String, dir:Vector2)` - spawn a drifter in a direction
        * `drifter.intend_move(dir:Vector2)` - move in a direction (swapping with whatever you run into)
        * `drifter.intend_move_and_leave(dir:Vector2, respath:String)` - move in a direction and leave the given drifter behind
        * `drifter.intend_transmute(respath:String)` - kill the drifter and replace it with another
        * `drifter.intend_clone(dir:Vector2)` - make a copy of the drifter in the given direction
        * `drifter.vibiest_dir(dirs:Array,weights:Dictionary) -> Vector2` - find the [vibiest direction](#vibiest_dir), weighted by the given elemental weights
* World
    * methods:
        * `world.vibe_at(cell:Vector2)` - the [vibe at](#vibe_at) a single cell in particular
        * `world.vibe_nearby(cell:Vector2)` - a [weighted sum](#vibe_nearby) of the vibes of the 8 nearby tiles
        * `world.intend_kill_at(cell:Vector2)`
        * `world.intend_spawn_at(respath:String, cell:Vector2)`
        * `world.intend_move_to(drifter:Drifter, cell:Vector2)`
        * `world.intend_move_from_to(cell1:Vector2, cell2:Vector2)` - move whatever is at `cell1` to `cell2`
        * `world.log(msg:String)` - print a message for the player about what just happened
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

## vibe_at

for example, if the `othercell` contains a drifter with major/minor elements Fire/Gem and guts 50, `var vibe = world.vibe_at(othercell)` will have:
* `vibe.get_fire() == 3` (3 points from major element)
* `vibe.get_gem() == 1` (1 point from minor element)
* `vibe.get_guts() == 50`

it's a little strange that guts are returned as part of the vibe object, but that can be useful; see [vibiest_dir](#vibiest_dir)

right-click in-game to see `vibe_at` the mouse cursor

## vibe_nearby

the weights are specifically like this; `(a,b)`, where `a` scales the major element and `b` scales the minor element:
```
  (1,0) (3,1) (1,0)
  (3,1) (0,0) (3,1)
  (1,0) (3,1) (1,0)
```
(the (0,0) weight in the center there represents the center cell)

here's an example:
```
.AB
.@.
...
```

this is a 2D map where `@` represents your drifter, `A` represents a drifter with major/minor elements Fire/Gem and guts 50, and `B` represents a drifter with major/minor elements `Fire/Coal` and guts 10. Then, if the current drifter (`@`) calls `var vibe = world.vibe_nearby(cell)`, the returned vibe will have:
* `vibe.get_fire() == 4` (3 points from `A` and 1 point from `B`)
* `vibe.get_gem() == 1` (1 point from `A`)
* `vibe.get_guts() == 60`

right-click in-game to see `vibe_nearby` the mouse cursor

## vibiest_dir

gets the vibe in each given direction, and then evaluates each vibe according to the weights you give it. then, returns the direction with the highest vibe score.

for example, to find a direction with high Fire and low Grass (and additionally avoid existing things via Guts), use this:

```python
var dir:Vector2 = vibiest_dir(DirsAdjacent,{"Fire":1, "Grass":-1, "Guts":-0.01})
```

given the same example as above (with `@`, `A` and `B`), the algorithm works like this:
* for each of the 8 `dir`s in `DirsAdjacent`:
    * evaluate `var vibe = world.vibe_at(dir)` . For example:
        * in the direction of `A`, `vibe` will have `Fire: 3, Gem: 1, Guts: 50` (0 for other elements)
        * in the direction of `B`, `vibe` will have `Fire: 3, Coal: 1, Guts: 10` (0 for other elements)
        * in the empty directions, `vibe` will have 0 for all elements.
    * mulitply this vibe pairwise with the given weights to get a `score`. For example:
        * in the direction of `A`, `score` will equal `3*1 (fire) + 1*0 (gem) + 0*-1 (grass) + 50*-0.01 (guts)` which is `3+0+0-0.5 == 2.5`
        * in the direction of `B`, `score` will equal `3*1 (fire) + 1*0 (coal) + 0*-1 (grass) + 10*-0.01 (guts)` which is `3+0+0-0.1 == 2.9`
        * in the empty directions, `score` will be `0`.
    * each score gets randomly shifted by a value between 0.0 and 1.0. then, the maximum score is found and the direction is returned. In this example, that will likely be the direction of `B`, but will sometimes be the direction of `A` depending on how the random shifting goes
