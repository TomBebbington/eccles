local System = require('eccles.System')
local band = (require('bit')).band
local pluralize
pluralize = function(word)
  local _exp_0 = string.sub(word, -1, -1)
  if 'y' == _exp_0 then
    return string.sub(word, 1, -2) .. 'ies'
  elseif 's' == _exp_0 or 'c' == _exp_0 or 'ch' == _exp_0 or 'sh' == _exp_0 then
    return word .. 'es'
  else
    return word .. 's'
  end
end
local remove_value
remove_value = function(array, value)
  for i, v in ipairs(array) do
    if v == value then
      table.remove(array, i)
      return v
    end
  end
  return nil
end
local EntitySystem
do
  local _class_0
  local _parent_0 = System
  local _base_0 = {
    initialize = function(self)
      _class_0.__parent.__base.initialize(self)
      self:import_names(self.aspect._all)
      return self:import_names(self.aspect._one)
    end,
    import_names = function(self, set)
      local plural, v
      local components = self.world.components
      for n, id in pairs(self.world.component_ids) do
        if (band(set, n)) == set then
          plural = pluralize(n)
          if components[n] == nil then
            components[n] = { }
          end
          self[plural] = components[v]
        end
      end
    end,
    matches = function(self, id)
      return self.aspect:matches(id)
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
  _class_0 = setmetatable({
    __init = function(self, world, aspect, passive, depends)
      _class_0.__parent.__init(self, world, passive, depends)
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
  EntitySystem = _class_0
  return _class_0
end
