build:
	mkdir -p .build
	moonc -t .build *.moon
	luarocks pack eccles-1.0-1.rockspec

install: build
	