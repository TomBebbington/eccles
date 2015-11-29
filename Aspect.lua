local Aspect
do
  local _base_0 = {
    all = function(self, ...)
      return insert_all(args(self._all))
    end,
    one = function(self, ...)
      return insert_all(args(self._one))
    end,
    none = function(self, ...)
      return insert_all(args(self._none))
    end,
    matches = function(self, world, id)
      local layout = world.layouts[id]
      for i = 1, #self._all do
        if layout[self._all[i]] == nil then
          return false
        end
      end
      local has_one = false
      for i = 1, #self._one do
        has_one = has_one or (layout[self._one[i]] ~= nil)
      end
      for i = 1, #self._exclude do
        if layout[self._exclude[i]] ~= nil then
          return false
        end
      end
      return (#self._one == 0 or has_one) and true
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, all, one, exclude)
      if all == nil then
        all = { }
      end
      if one == nil then
        one = { }
      end
      if exclude == nil then
        exclude = { }
      end
      self._all = all
      self._one = one
      self._exclude = exclude
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
