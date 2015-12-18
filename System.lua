local System
do
  local _class_0
  local _base_0 = {
    initialize = function(self)
      print("Initializing " .. tostring(self.__class.__name))
      local entities = self.world.entities
      local depends = self.depends
      self.depends = nil
      for i = 1, #entities do
        self:entity_added(entities[i])
      end
      for f, v in pairs(depends) do
        self[f] = self.world.systems[v]
        if self[f] == nil then
          error("No system found for " .. tostring(v))
        else
          print("Loaded " .. tostring(f) .. " into " .. tostring(self.__class.__name))
        end
      end
    end,
    dispose = function(self) end,
    entity_added = function(self, id) end,
    entity_removed = function(self, id) end,
    update = function(self, dt) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, world, passive, depends)
      if passive == nil then
        passive = false
      end
      if depends == nil then
        depends = { }
      end
      if world == nil or world.__class == nil or world.__class.__name ~= 'World' then
        error("A world is required to construct " .. tostring(self.__class.__name))
      end
      self.world = world
      self.passive = passive
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
