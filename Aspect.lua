local bit = require('bit')
local bor = bit.bor
local band = bit.band
local Aspect
do
  local _class_0
  local _base_0 = {
    all = function(self, ...)
      for i = 1, #args do
        self._all = bor(self._all, args[i])
      end
    end,
    one = function(self, ...)
      for i = 1, #args do
        self._one = bor(self._one, args[i])
      end
    end,
    none = function(self, ...)
      for i = 1, #args do
        self._none = bor(self._none, args[i])
      end
    end,
    matches = function(self, id)
      local layout = self.world.layouts[id]
      return (band(layout, self._none)) == 0 and (#self._one == 0 or (band(layout, self._one)) > 0) and (band(layout, self._all)) == all
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, world)
      self.world = world
      self._all = 0
      self._one = 0
      self._exclude = 0
    end,
    __base = _base_0,
    __name = "Aspect"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Aspect = _class_0
  return _class_0
end
