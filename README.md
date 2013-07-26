# Touchstone

**Easy defaults for use in debugging and production.**

`NSUserDefaults` is a great way to save settings that should be configured in your app. And you'll find yourself registering those settings at app startup with `registerDefaults:`. What happens though when you want some settings to be overrideable when debugging (through a secret debug menu), and yet still be persistent? However, when the app is not a debug build, those settings should always be the defaults. In this case, you'll have lots of places in your code like the following:

```objective-c
#if DEBUG
    logger.level = (AFHTTPRequestLoggerLevel)[userDefaults integerForKey:kUserDefaultsNetworkLoggingLevel];
#else
    logger.level = AFHTTPLoggerLevelOff;
#endif
```

... or something like it.

Well, Touchstone is here to solve this problem.

## Example

```objective-c
// Standard Defaults
NSDictionary *defaults = @{
    kFirstLaunchKey: @(YES),
};

// Debug Defaults
NSDictionary *debugDefaults = @{
    kLoggingEnabledKey: @(NO),
};

// Setup Touchstone
Touchstone *touchstone = [Touchstone standardUserDefaults];
[touchstone registerDefaults:defaults
               debugDefaults:debugDefaults
                       debug:(DEBUG == 1)];
```

## Installation

Use Cocoapods to install or use a git submodule. Then include the necessary categories.

## Contact

[Chris Streeter](http://github.com/streeter)
[@chrisstreeter](https://twitter.com/chrisstreeter)

## License

Touchstone is available under the MIT license. See the LICENSE file for more info.

