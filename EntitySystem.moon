----
-- logic to run against components matching a certain aspect
-- @classmod EntitySystem
import pluralize, remove_value from require 'util'

System = require 'eccles.System'

class EntitySystem extends System
	--- make a new system
	-- @param self the system
	-- @param world the world to add the system to
	-- @param aspect the aspect to match entities against
	-- @param passive if the system is passive or not
	-- @param depends the systems this depends on
	new: (world, aspect, passive, depends) =>
		super world, passive, depends
		if aspect == nil or aspect.__class.__name ~= 'Aspect'
			error "An aspect is required to construct #{@__class.__name}"
		@aspect = aspect
		@cache = {}

	--- initialize the system
	-- @param self the system
	initialize: () =>
		super!
		@import_names @aspect._all
		@import_names @aspect._one

	--- import the names into the system
	-- @param self the system
	-- @param list the list of names to import
	import_names: (list) =>
		local plural, v
		components = @world.components
		for i = 1, #list do
			v = list[i]
			plural = pluralize v
			if components[v] == nil
				components[v] = {}
			self[plural] = components[v]
	--- check if the system should run against this entity
	-- @param self the system
	-- @param id the entity
	matches: (id) =>
		@aspect\matches @world, id
	--- notify the system that an entity has been added to the world
	-- @param self the system
	-- @param id the entity that has been added
	entity_added: (id) =>
		if self\matches id
			table.insert @cache, id
	--- notify the system that an entity has been removed to the world
	-- @param self the system
	-- @param id the entity that has been removed
	entity_removed: (id) =>
		remove_value @cache, id
	--- update the system in regards to an entity with a delta time
	-- @param self the system
	-- @param dt the elapsed time from the last call in seconds
	-- @param id the entity to update
	update_entity: (dt, id) =>
		error "Entity updater not implemented for #{@__class.__name}"
	--- update the system with a delta time
	-- @param self the system
	-- @param dt the elapsed time from the last call in seconds
	update: (dt) =>
		cache = @cache
		for i = 1, #cache do
			@update_entity dt, cache[i]