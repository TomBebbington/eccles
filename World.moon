----
-- a container for components, systems and entities
-- @classmod World
mp = require 'MessagePack'
class World
	--- constructor that takes an optional list of systems
	-- @param self the world
	-- @param systems the systems to add to the world
	new: (systems) =>
		@components = {}
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
			v = @fast_systems[i]
			print "Initializing #{v.__class.__name}"
			v\initialize!

	--- make a new entity with the components given
	-- @param self the world
	-- @param config the components to add to the entity as it is created
	-- @return the new entity
	create: (config) =>
		free = table.remove @free_spaces
		id = free ~= nil and free or #@entities + 1
		table.insert @entities, id
		@layouts[id] = {}
		for f, v in pairs config
			if @components[f] == nil
				@components[f] = {}
			@components[f][id] = v
			@layouts[id][f] = true
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
			if not v.passive
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