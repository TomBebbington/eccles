----
-- logic to run against components matching a certain aspect every interval
-- @classmod EntitySystem

EntitySystem = require 'eccles.EntitySystem'

class IntervalEntitySystem extends EntitySystem
	--- make a new system
	-- @param self the system
	-- @param world the world to add the system to
	-- @param aspect the aspect to match entities against
	-- @param interval how long in seconds between updates
	-- @param depends the systems this depends on
	new: (world, aspect, interval, depends) =>
		if interval == nil
			error "An interval is required to construct #{@__class.__name}"
		@interval = interval
		@elapsed = 0
		super world, aspect, depends

	initialize: () =>
		super !
		@passive = true

	update: (dt) =>
		interval = @interval
		@elapsed += dt
		if @elapsed > interval
			super interval
			@elapsed -= interval