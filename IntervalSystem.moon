----
-- logic to run every interval
-- @classmod EntitySystem

class IntervalSystem extends System
	--- make a new system
	-- @param self the system
	-- @param world the world to add the system to
	-- @param interval how long in seconds between updates
	-- @param depends the systems this depends on
	new: (world, interval, depends) =>
		if interval == nil
			error "An interval is required to construct #{@__class.__name}"
		@interval = interval
		@elapsed = 0
		super world, depends

	initialize: () =>
		super!
		@passive = true

	update: (dt) =>
		interval = @interval
		@elapsed += dt
		if @elapsed > interval
			super interval
			@elapsed -= interval