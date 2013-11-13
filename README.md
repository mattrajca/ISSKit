ISSKit
======

An iOS static library for tracking the International Space Station. Compatible with iOS 6.0+.

To merge the simulator and device products into one:

	lipo -create /path/to/device.a /path/to/simulator.a -output ISSKit.a
