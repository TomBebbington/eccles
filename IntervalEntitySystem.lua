local EntitySystem = require('eccles.EntitySystem')
local IntervalEntitySystem
do
  local _parent_0 = EntitySystem
  local _base_0 = {
    initialize = function(self)
      _parent_0.initialize(self)
      self.passive = true
    end,
    update = function(self, dt)
      local interval = self.interval
      self.elapsed = self.elapsed + dt
      if self.elapsed > interval then
        _parent_0.update(self, interval)
        self.elapsed = self.elapsed - interval
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, world, aspect, interval, depends)
      if interval == nil then
        error("An interval is required to construct " .. tostring(self.__class.__name))
      end
      self.interval = interval
      self.elapsed = 0
      return _parent_0.__init(self, world, aspect, depends)
    end,
    __base = _base_0,
    __name = "IntervalEntitySystem",
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
  IntervalEntitySystem = _class_0
  return _class_0
end
