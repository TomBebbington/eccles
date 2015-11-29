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
		@left = interval
		@coroutine = coroutine.create () ->
			sleep = IntervalSystem.sleep
			while true
				sleep interval
				@update interval
		coroutine.resume @coroutine
		super world, aspect, depends
		@passive = true







