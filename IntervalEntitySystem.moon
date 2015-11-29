----
-- logic to run against components matching a certain aspect every interval
-- @classmod EntitySystem


IntervalSystem = require 'eccles.IntervalSystem'
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
		super world, aspect, interval, depends

	initialize: () =>
		interval = @interval
		@coroutine = coroutine.create () ->
			while true
				sleep interval
				@update interval
		coroutine.resume @coroutine
		@passive = true

	dispose: () =>
		@coroutine = nil