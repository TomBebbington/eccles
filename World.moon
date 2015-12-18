----
-- a container for components, systems and entities
-- @classmod World
bit = require 'bit'
band = bit.band
mp = require 'MessagePack'
class World
	--- constructor that takes an optional list of systems
	-- @param self the world
	-- @param systems the systems to add to the world
	new: (systems) =>
		@components = {}
		@component_ids = {}
		@systems = {}
		@fast_systems = {}
		@entities = {}
		@layouts = {}
		@free_spaces = {}
		local v
		if systems == nil
			for f, v in pairs _G
				if (string.sub f, -6, -1) == 'System'
					print "import #{f}"
					v self
		else
			for i = 1, #systems do
				v = systems[i]
				if v == nil
					error "System ##{i} does not exist"
				if v.__name == nil
					error "System ##{i} does not have a name"
				v self
		for i = 1, #@fast_systems do
			@fast_systems[i]\initialize!
	--- set a system in the world
	-- @param self the world
	-- @param system the system to be set
	set_system: (system) =>
		name = system.__class.__name
		if @systems[name] ~= nil
			@systems[name]\dispose!
			table.remove @fast_systems, @systems[name]
		@systems[name] = system
		table.insert @fast_systems, system
		system.world = self
		system\initialize!

	--- remove a system from the world by its name
	-- @param self the world
	-- @param name the name of the system to remove
	remove_system: (name) =>
		system = @systems[name]
		table.remove world.systems, name
		table.remove @fast_systems, system
		system.world = nil
		system\dispose!

	--- make a new entity with the components given
	-- @param self the world
	-- @param config the components to add to the entity as it is created
	-- @return the new entity
	create: (config) =>
		free = table.remove @free_spaces
		id = free ~= nil and free or #@entities + 1
		table.insert @entities, id
		layout = 0
		for f, v in pairs config
			if @components[f] == nil
				@components[f] = {}
				@component_ids[f] = #@component_ids
			@components[f][id] = v
			layout = band layout, @component_ids[f]
		@layouts[id] = layout
		for i = 1, #@fast_systems
			@fast_systems[i]\entity_added id
	--- check if the entity id is associated with the component
	-- @param self the world
	-- @param id the entity to check
	-- @param component the name of the component to check is contained in the entity
	-- @return a boolean representing if the check was successful or not
	contains: (id, component) =>
		@layouts[id][component]
	--- update with a delta time in seconds dt
	-- @param self the world
	-- @param dt the elapsed time since the last update in seconds
	update: (dt) =>
		local v
		for i = 1, #@fast_systems
			v = @fast_systems[i]
			unless v.passive
				v\update dt
	--- remove the entity id from this world
	-- @param self the world
	-- @param id the entity to remove
	remove: (id) =>
		for f, v in pairs @layouts[id]
			@components[f][id] = nil
		for i = 1, #@fast_systems
			@fast_systems[i]\entity_removed i
		@entities[id] = nil
		@layouts[id] = nil
		table.insert @free_spaces, id
	--- save this to a file
	-- @param self the world
	-- @param file the file name to save this to
	save: (file) =>
		f = assert (io.open file, 'w')
		f\write (mp.pack {
			components: @components,
			systems: [ f for f, v in pairs @systems],
			entities: @entities,
			free_spaces: @free_spaces,
			layouts: @layouts
		})
		f\close!
	--- read the world at file
	-- @param file the file name to load this from
	-- @return a World loaded from the file
	read: (file) ->
		f = assert (io.open file, 'r')
    	t = f\read '*all'
		f\close!
		o = mp.unpack t
		setmetatable o, {__index: World}
		local pack, name, system, v
		systems = o.systems
		for i = 1, #systems do
			f = systems[i]
			{pack, name} = [ v for v in string.gmatch(v, '([^\\.]+)')]
			print v, pack, name
			if _G[pack] == nil
				_G[pack] = require pack
				if _G[pack] == nil
					error "Invalid module #{pack}"
			if _G[pack][name] == nil
				error "Invalid class #{name} in #{pack}"
			system = _G[pack][name] o
			o.systems[f] = system
			o.fast_systems[i] = system
		o