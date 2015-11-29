local System
do
  local _base_0 = {
    initialize = function(self)
      local entities = self.world.entities
      local depends = self.depends
      for i = 1, #entities do
        self:entity_added(entities[i])
      end
      for i = 1, #depends do
        local name = depends[i]
        self[name] = self.world.systems[name]
        if self[name] == nil then
          error("No system found for " .. tostring(name))
        end
      end
    end,
    entity_added = function(self, id) end,
    entity_removed = function(self, id) end,
    update = function(self, dt) end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world, depends)
      if depends == nil then
        depends = { }
      end
      if world == nil or world.__class == nil or world.__class.__name ~= 'World' then
        error("A world is required to construct " .. tostring(self.__class.__name))
      end
      self.world = world
      self.passive = false
      self.depends = depends
      world.systems[self.__class.__name] = self
      return table.insert(world.fast_systems, self)
    end,
    __base = _base_0,
    __name = "System"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  System = _class_0
  return _class_0
end
