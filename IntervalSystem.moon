----
-- logic to run every interval
-- @classmod EntitySystem

require_opt = (name) ->
	module = nil
	pcall () -> module = require name
	module

System = require 'eccles.System'
nanosleep = require_opt 'posix.time.nanosleep'
for f, v in pairs posix
	print f, v
sleep = if nanosleep ~= nil
		(s) -> nanosleep s * 1000000000
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
	-- @param aspect the aspect to match entities against
	-- @param interval how long in seconds between updates
	-- @param depends the systems this depends on
	new: (world, interval, depends) =>
		if interval == nil
			error "An interval is required to construct #{@__class.__name}"
		@interval = interval
		@coroutine = coroutine.create () ->
			print "every #{interval}"
			while true
				sleep interval
				@update interval
		@passive = true
		super world, depends

	sleep: sleep