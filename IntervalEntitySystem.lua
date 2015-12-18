local EntitySystem = require('eccles.EntitySystem')
local IntervalSystem = require('eccles.IntervalSystem')
local IntervalEntitySystem
do
  local _class_0
  local _parent_0 = EntitySystem
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
      return _class_0.__parent.__base.initialize(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, world, aspect, interval, depends)
      if interval == nil then
        error("An interval is required to construct " .. tostring(self.__class.__name))
      end
      self.interval = interval
      return _class_0.__parent.__init(self, world, aspect, true, depends)
    end,
    __base = _base_0,
    __name = "IntervalEntitySystem",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
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
  IntervalEntitySystem = _class_0
  return _class_0
end
