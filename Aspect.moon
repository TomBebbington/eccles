----
-- a filter to match entities against based on their components
-- @classmod Aspect
bit = require 'bit'
bor = bit.bor
band = bit.band

to_set = (world, list) ->
	ids, set = world.component_ids, 0
	local curr
	for i = 1, #list do
		curr = list[i]
		if ids[curr] == nil
			ids[curr] = #ids
		set = bor set, ids[curr]
	set

class Aspect
	--- make a new aspect with the given conditions
	-- @param world the world to use ids from
	new: (world, all = {}, one = {}, exclude = {}) =>
		@world = world
		ids = world.component_ids
		@_all = to_set world, all
		@_one = to_set world, one
		@_exclude = to_set world, exclude
	--- set the components that must all be in the entity
	-- @param self the aspect
	all: (...) =>
		@_all = bor @_all, (to_set @world, args)
	--- set the components that at least one of must be in the entity
	-- @param self the aspect
	one: (...) =>
		@_one = bor @_one, (to_set @world, args)
	--- set the components that must not be in the entity
	-- @param self the aspect
	none: (...) =>
		@_none = bor @_none, (to_set @world, args)
	--- check if the entity matches the aspect
	-- @param self the aspect
	-- @param id the entity's id
	matches: (id) =>
		layout = @world.layouts[id]
		(band layout, @_none) == 0 and (#@_one == 0 or (band layout, @_one) > 0) and (band layout, @_all) == all
