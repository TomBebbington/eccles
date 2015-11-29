package = "eccles"
version = "1.0-1"
source = {
	url = "https://github.com/TomBebbington/eccles",
	tag = "v1.0",
}
description = {
	summary = "A simple entity component system",
	detailed = [[
	This is a really simple entity component system written in Moonscript to make everyone's life easier!
	]],
	homepage = "https://github.com/TomBebbington/eccles",
	license = "MIT"
}
dependencies = {
	"lua ~> 5.3",
	"lua-messagepack ~> 0.3.3-1"
}
build = {
	type = "builtin",
	modules = {
		Aspect = ".build/Aspect.lua",
		System = ".build/System.lua",
		EntitySystem = ".build/EntitySystem.lua",
		World = ".build/World.lua"
	}
}
