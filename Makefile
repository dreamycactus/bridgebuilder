.PHONY: debug cpp release cpp-release

debug:
	openfl build flash -debug
	fdb bin/flash/bin/BridgeBuilderBob.swf

cpp:
	openfl build cpp -debug

release:
	openfl build flash
	open bin/flash/bin/BridgeBuilderBob.swf

cpp-release:
	openfl build cpp
