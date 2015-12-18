local bit = require('bit')
local band = bit.band
local mp = require('MessagePack')
local World
do
  local _class_0
  local _base_0 = {
    set_system = function(self, system)
      local name = system.__class.__name
      if self.systems[name] ~= nil then
        self.systems[name]:dispose()
        table.remove(self.fast_systems, self.systems[name])
      end
      self.systems[name] = system
      table.insert(self.fast_systems, system)
      system.world = self
      return system:initialize()
    end,
    remove_system = function(self, name)
      local system = self.systems[name]
      table.remove(world.systems, name)
      table.remove(self.fast_systems, system)
      system.world = nil
      return system:dispose()
    end,
    create = function(self, config)
      local free = table.remove(self.free_spaces)
      local id = free ~= nil and free or #self.entities + 1
      table.insert(self.entities, id)
      local layout = 0
      for f, v in pairs(config) do
        if self.components[f] == nil then
          self.components[f] = { }
          self.component_ids[f] = #self.component_ids
        end
        self.components[f][id] = v
        layout = band(layout, self.component_ids[f])
      end
      self.layouts[id] = layout
      for i = 1, #self.fast_systems do
        self.fast_systems[i]:entity_added(id)
      end
    end,
    contains = function(self, id, component)
      return self.layouts[id][component]
    end,
    update = function(self, dt)
      local v
      for i = 1, #self.fast_systems do
        v = self.fast_systems[i]
        if not (v.passive) then
          v:update(dt)
        end
      end
    end,
    remove = function(self, id)
      for f, v in pairs(self.layouts[id]) do
        self.components[f][id] = nil
      end
      for i = 1, #self.fast_systems do
        self.fast_systems[i]:entity_removed(i)
      end
      self.entities[id] = nil
      self.layouts[id] = nil
      return table.insert(self.free_spaces, id)
    end,
    save = function(self, file)
      local f = assert((io.open(file, 'w')))
      f:write((mp.pack({
        components = self.components,
        systems = (function()
          local _accum_0 = { }
          local _len_0 = 1
          for f, v in pairs(self.systems) do
            _accum_0[_len_0] = f
            _len_0 = _len_0 + 1
          end
          return _accum_0
        end)(),
        entities = self.entities,
        free_spaces = self.free_spaces,
        layouts = self.layouts
      })))
      return f:close()
    end,
    read = function(file)
      local f = assert((io.open(file, 'r')))
      local t = f:read('*all')
      f:close()
      local o = mp.unpack(t)
      setmetatable(o, {
        __index = World
      })
      local pack, name, system, v
      local systems = o.systems
      for i = 1, #systems do
        f = systems[i]
        do
          local _accum_0 = { }
          local _len_0 = 1
          for v in string.gmatch(v, '([^\\.]+)') do
            _accum_0[_len_0] = v
            _len_0 = _len_0 + 1
          end
          pack, name = _accum_0[1], _accum_0[2]
        end
        print(v, pack, name)
        if _G[pack] == nil then
          _G[pack] = require(pack)
          if _G[pack] == nil then
            error("Invalid module " .. tostring(pack))
          end
        end
        if _G[pack][name] == nil then
          error("Invalid class " .. tostring(name) .. " in " .. tostring(pack))
        end
        system = _G[pack][name](o)
        o.systems[f] = system
        o.fast_systems[i] = system
      end
      return o
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, systems)
      self.components = { }
      self.component_ids = { }
      self.systems = { }
      self.fast_systems = { }
      self.entities = { }
      self.layouts = { }
      self.free_spaces = { }
      local v
      if systems == nil then
        for f, v in pairs(_G) do
          if (string.sub(f, -6, -1)) == 'System' then
            print("import " .. tostring(f))
            v(self)
          end
        end
      else
        for i = 1, #systems do
          v = systems[i]
          if v == nil then
            error("System #" .. tostring(i) .. " does not exist")
          end
          if v.__name == nil then
            error("System #" .. tostring(i) .. " does not have a name")
          end
          v(self)
        end
      end
      for i = 1, #self.fast_systems do
        self.fast_systems[i]:initialize()
      end
    end,
    __base = _base_0,
    __name = "World"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  World = _class_0
  return _class_0
end
