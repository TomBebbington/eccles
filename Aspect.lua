local bit = require('bit')
local bor = bit.bor
local band = bit.band
local to_set
to_set = function(world, list)
  local ids, set = world.component_ids, 0
  local curr
  for i = 1, #list do
    curr = list[i]
    if ids[curr] == nil then
      ids[curr] = #ids
    end
    set = bor(set, ids[curr])
  end
  return set
end
local Aspect
do
  local _class_0
  local _base_0 = {
    all = function(self, ...)
      self._all = bor(self._all, (to_set(self.world, args)))
    end,
    one = function(self, ...)
      self._one = bor(self._one, (to_set(self.world, args)))
    end,
    none = function(self, ...)
      self._none = bor(self._none, (to_set(self.world, args)))
    end,
    matches = function(self, id)
      local layout = self.world.layouts[id]
      return (band(layout, self._none)) == 0 and (#self._one == 0 or (band(layout, self._one)) > 0) and (band(layout, self._all)) == all
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, world, all, one, exclude)
      if all == nil then
        all = { }
      end
      if one == nil then
        one = { }
      end
      if exclude == nil then
        exclude = { }
      end
      self.world = world
      local ids = world.component_ids
      self._all = to_set(world, all)
      self._one = to_set(world, one)
      self._exclude = to_set(world, exclude)
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
