# Time Traveler

A Lua module that records and rewinds values. Extremely useful in games that use a rewind mechanic. Tested with Defold and LOVE but should work with any game engine. By default it is set to work in fixed time-steps. If your game engine has variable time-steps and vsync is off, set fixedStep to false.

## Usage:
### Defold
1. Save the module (timetraveler.lua) inside your project folder
2. Import it in your script:
```Lua
local traveler = require("timetraveler")
```
3. Inside the init function, initialize the module:
```Lua
function init(self)
    traveler.init(
      {go.get_position, go.set_position},
      {go.get_rotation, go.set_rotation},
      {go.get_scale, go.set_scale}
    )
end
```
4. At the end of the update function add the if statement:
```Lua
function update(self, dt)
    -- GAME LOGIC HERE --
    if doRewind then
      traveler.rewind(dt)
    else
      traveler.record(dt)
    end
end
```

### LOVE
1. Save the module (timetraveler.lua) inside your project folder
2. Import it in your script:
```Lua
local traveler = require("timetraveler")
```
3. Inside the load function, initialize the module:
```Lua
function love.load()
    traveler.init(
      {function() return player.x end, function(v) player.x = v end},
      {function() return player.y end, function(v) player.y = v end}
    )
end
```
4. At the end of the update function add the if statement:
```Lua
function love.update(dt)
    if love.keyboard.isDown('lshift') then
      traveler.rewind(dt)
    else
      -- GAME LOGIC HERE --
      traveler.record(dt)
    end
end
```

## References:
### init(...)
function - Initializes the traveler and receives any number of tables. The table(s) must be composed of 2 functions: a function that retrieves the value to record and a function that sets the value recorded back. Eg.:
```Lua
traveler.init(
    {go.get_position, go.set_position},
    {function() return self.flip end, function(v) self.flip = v end}
)
```

### record(dt)
function - Records the values per frame.

### rewind(dt)
function - Rewinds back the values per frame.
### rewindLimit
number - How far back in time the traveler can go. It is expressed in seconds and it defaults to 5.
### fixedStep
boolean - True by default. If your game engine works with a variable time-step, set it to false.
### fps
number - How many frames per seconds record. Useful when you have a variable time-step engine. It is 60 by default.

## Example:
Check the folder examples inside the repository.
