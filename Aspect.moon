----
-- a filter to match entities against based on their components
-- @classmod Aspect
bit = require 'bit'
bor = bit.bor
band = bit.band

class Aspect
	--- make a new aspect with the given conditions
	-- @param world the world to use ids from
	new: (world) =>
		@world = world
		@_all = 0
		@_one = 0
		@_exclude = 0
	--- set the components that must all be in the entity
	-- @param self the aspect
	all: (...) =>
		for i = 1, #args
			@_all = bor @_all, args[i]
	--- set the components that at least one of must be in the entity
	-- @param self the aspect
	one: (...) =>
		for i = 1, #args
			@_one = bor @_one, args[i]
	--- set the components that must not be in the entity
	-- @param self the aspect
	none: (...) =>
		for i = 1, #args
			@_none = bor @_none, args[i]
	--- check if the entity matches the aspect
	-- @param self the aspect
	-- @param id the entity's id
	matches: (id) =>
		layout = @world.layouts[id]
		(band layout, @_none) == 0 and (#@_one == 0 or (band layout, @_one) > 0) and (band layout, @_all) == all
