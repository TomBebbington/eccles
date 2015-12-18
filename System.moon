----
-- logic to run
-- @classmod System
class System
	--- make a new system
	-- @param self the system
	-- @param world the world to add the system to
	-- @param depends the systems this depends on
	new: (world, passive = false, depends = {}) =>
		if world == nil or world.__class == nil or world.__class.__name ~= 'World'
			error "A world is required to construct #{@__class.__name}"
		@world = world
		@passive = passive
		@depends = depends
		world.systems[@__class.__name] = self
		table.insert world.fast_systems, self
	--- initialize the system
	-- @param self the system
	initialize: () =>
		print "Initializing #{@__class.__name}"
		entities = @world.entities
		depends = @depends
		@depends = nil
		for i = 1, #entities
			@entity_added entities[i]
		for f, v in pairs depends
			self[f] = @world.systems[v]
			if self[f] == nil
				error "No system found for #{v}"
			else
				print "Loaded #{f} into #{@__class.__name}"
	--- dispose the system's resources
	-- @param self the system
	dispose: () =>
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