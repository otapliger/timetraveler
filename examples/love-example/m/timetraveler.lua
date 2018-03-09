local M = {}
M.rewindLimit = 5 -- time limit expressed in seconds
M.fixedStep = true
M.fps = 60

local properties = {}
local timeFrames = {}
local properties = {}
local tick = 0

local function init(...)
  local args = {...}
  for i = 1, #args do
    if #args[i] == 2
    and type(args[i]) == "table"
    and type(args[i][1]) == "function"
    and type(args[i][2]) == "function" then
      table.insert(properties, args[i])
    else
      print("init expects a table of get and set functions, eg.: init({ get_function, set_function })\n")
    end
  end
end

local function record(dt)
  local now = {}
  if M.fixedStep then
    for i, v in ipairs(properties) do
      table.insert(now, {v[1](), os.time()})
    end
    table.insert(timeFrames, now)
  else
    tick = tick + dt
    while tick >= 1 / M.fps do
      for i, v in ipairs(properties) do
        table.insert(now, {v[1](), os.time()})
      end
      table.insert(timeFrames, now)
      tick = tick - 1 / M.fps
    end
  end
  -- Remove old frames from the list if the time exceeds the rewindLimit
  if M.rewindLimit ~= 0 then
    if M.fixedStep then
      local fps = 1 / dt
      if #timeFrames / fps >= M.rewindLimit then
        framesToRemove = math.floor(#timeFrames - M.rewindLimit * fps)
        for i = 1, framesToRemove do
          table.remove(timeFrames, 1)
        end
      end
    else
      local time = os.time()
      for i, v in ipairs(timeFrames) do
        if os.difftime(time, v[2][2]) >= M.rewindLimit then
          table.remove(timeFrames, i)
        else
          break
        end
      end
    end
  end
end

local function rewind(dt)
  if M.fixedStep then
    for i, v in ipairs(properties) do
      v[2](timeFrames[#timeFrames][i][1])
    end
    if #timeFrames > 1 then
      table.remove(timeFrames, #timeFrames)
    end
  else
    tick = tick + dt
    while tick >= 1 / M.fps do
      for i, v in ipairs(properties) do
        v[2](timeFrames[#timeFrames][i][1])
      end
      if #timeFrames > 1 then
        table.remove(timeFrames, #timeFrames)
      end
      tick = tick - 1 / M.fps
    end
  end
end

M.init = init
M.record = record
M.rewind = rewind

return M
