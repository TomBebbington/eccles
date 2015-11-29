----
-- logic to run every interval
-- @classmod EntitySystem

System = require 'eccles.System'
sleep = if love ~= nil
		love.timer.sleep
	else
		time = os.time
		(s) ->
			start = time!
			while (time! - start) < s
				nil

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
		super world, true, depends

	initialize: () =>
		interval = @interval
		c = coroutine.create () ->
			while true
				sleep interval
				@update interval
		coroutine.resume c
		super!

	sleep: sleep