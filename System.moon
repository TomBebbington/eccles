----
-- logic to run
-- @classmod System
class System
	--- make a new system
	-- @param self the system
	-- @param world the world to add the system to
	-- @param depends the systems this depends on
	new: (world, depends = {}) =>
		if world == nil or world.__class == nil or world.__class.__name ~= 'World'
			error "A world is required to construct #{@__class.__name}"
		@world = world
		@passive = false
		@depends = depends

		world.systems[@__class.__name] = self
		table.insert world.fast_systems, self
	--- initialize the system
	-- @param self the system
	initialize: () =>
		entities = @world.entities
		depends = @depends
		for i = 1, #entities
			@entity_added entities[i]
		for i = 1, #depends
			name = depends[i]
			self[name] = @world.systems[name]
			if self[name] == nil
				error "No system found for #{name}"
	--- notify the system that an entity has been added to the world
	-- @param self the system
	-- @param id the entity that has been added
	entity_added: (id) =>
	--- notify the system that an entity has been removed to the world
	-- @param self the system
	-- @param id the entity that has been removed
	entity_removed: (id) =>
	--- update the system with a delta time
	-- @param self the system
	-- @param dt the elapsed time from the last call in seconds
	update: (dt) =>