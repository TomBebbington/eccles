----
-- a filter to match entities against based on their components
-- @classmod Aspect
class Aspect
	--- make a new aspect with the given conditions
	-- @param self the aspect
	-- @param all components that must all be in the entity
	-- @param one components that at least one of must be in the entity
	-- @param exclude components that must not be in the entity
	new: (all = {}, one = {}, exclude = {}) =>
		@_all = all
		@_one = one
		@_exclude = exclude
	--- set the components that must all be in the entity
	-- @param self the aspect
	all: (...) =>
		insert_all args @_all
	--- set the components that at least one of must be in the entity
	-- @param self the aspect
	one: (...) =>
		insert_all args @_one
	--- set the components that must not be in the entity
	-- @param self the aspect
	none: (...) =>
		insert_all args @_none
	--- check if the entity matches the aspect
	-- @param self the aspect
	-- @param world the world the entity is in
	-- @param id the entity
	matches: (world, id) =>
		layout = world.layouts[id]
		for i = 1, #@_all
			if layout[@_all[i]] == nil
				return false
		has_one = false
		for i = 1, #@_one
			has_one or= layout[@_one[i]] ~= nil
		for i = 1, #@_exclude
			if layout[@_exclude[i]] ~= nil
				return false
		(#@_one == 0 or has_one) and true
