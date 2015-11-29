local pluralize, remove_value
do
  local _obj_0 = require('util')
  pluralize, remove_value = _obj_0.pluralize, _obj_0.remove_value
end
local System = require('eccles.System')
local EntitySystem
do
  local _parent_0 = System
  local _base_0 = {
    initialize = function(self)
      _parent_0.initialize(self)
      self:import_names(self.aspect._all)
      return self:import_names(self.aspect._one)
    end,
    import_names = function(self, list)
      local plural, v
      local components = self.world.components
      for i = 1, #list do
        v = list[i]
        plural = pluralize(v)
        if components[v] == nil then
          components[v] = { }
        end
        self[plural] = components[v]
      end
    end,
    matches = function(self, id)
      return self.aspect:matches(self.world, id)
    end,
    entity_added = function(self, id)
      if self:matches(id) then
        return table.insert(self.cache, id)
      end
    end,
    entity_removed = function(self, id)
      return remove_value(self.cache, id)
    end,
    update_entity = function(self, dt, id)
      return error("Entity updater not implemented for " .. tostring(self.__class.__name))
    end,
    update = function(self, dt)
      local cache = self.cache
      for i = 1, #cache do
        self:update_entity(dt, cache[i])
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, world, aspect, depends)
      _parent_0.__init(self, world, depends)
      if aspect == nil or aspect.__class.__name ~= 'Aspect' then
        error("An aspect is required to construct " .. tostring(self.__class.__name))
      end
      self.aspect = aspect
      self.cache = { }
    end,
    __base = _base_0,
    __name = "EntitySystem",
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
  EntitySystem = _class_0
  return _class_0
end
