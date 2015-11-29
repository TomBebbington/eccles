local System = require('eccles.System')
local sleep
if love ~= nil then
  sleep = love.timer.sleep
else
  local time = os.time
  sleep = function(s)
    local start = time()
    while (time() - start) < s do
      local _ = nil
    end
  end
end
local IntervalSystem
do
  local _parent_0 = System
  local _base_0 = {
    initialize = function(self)
      local interval = self.interval
      local c = coroutine.create(function()
        while true do
          sleep(interval)
          self:update(interval)
        end
      end)
      coroutine.resume(c)
      return _parent_0.initialize(self)
    end,
    sleep = sleep
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, world, interval, depends)
      if interval == nil then
        error("An interval is required to construct " .. tostring(self.__class.__name))
      end
      self.interval = interval
      return _parent_0.__init(self, world, true, depends)
    end,
    __base = _base_0,
    __name = "IntervalSystem",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  IntervalSystem = _class_0
  return _class_0
end
