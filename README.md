# Touchstone

**Easy defaults for use in debugging and production.**

Touchstone makes it easy to create defaults that are persistent in debug builds, while being volatile in non-debug builds.

In non-debug builds, defaults specified as volatile (registered with the `volatileDefaults` parameter of `registerDefaults:volatileDefaults:isVolatile:`), are not persisted but can be written and read from. The next time defaults are registered (ex. app startup), those defaults are set to the value passed in.

However, if you pass `NO` to `isVolatile` (for example, in debug builds), then the defaults specified with the `volatileDefaults` parameter are not actually volatile; they are persisted and act like normal defaults.

## Problem

Touchstone was created to solve a problem we at [Educreations](http://www.educreations.com) ran into frequently. We have debug settings that we want to configure in-app, and to persist between app sessions. However, we *do not* want those settings to be non-default in production builds.

For example, say we have a setting to change our API endpoint. In production builds, this should always be our production API endpoint. But in debug builds, we might want to default to our production endpoint, but be able to change, and persist that change, to a different endpoint.

We previously had lots of code like the following:

```objective-c
#if DEBUG
    if ([standardDefaults boolForKey:kLoggingEnabledKey]) {
        logger.level = AFHTTPLoggerLevelVerbose;
    } else {
        logger.level = AFHTTPLoggerLevelError;
    }
#else
    logger.level = AFHTTPLoggerLevelOff;
#endif
```

Touchstone was built to solve this problem of conditional debug blocks.

## Examples

### isVolatile:YES

Here is an example where Touchstone is configured with `isVolatile:` set to `YES`:


```objective-c
NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
[standardDefaults registerDefaults:@{kFirstLaunchKey: @(YES)}
                  volatileDefaults:@{kLoggingEnabledKey: @(NO)}
                        isVolatile:YES];

NSLog(@"-> %@", ([standardDefaults boolForKey:kFirstLaunchKey] ? @"YES" : @"NO"));
// -> YES
NSLog(@"-> %@", ([standardDefaults boolForKey:kLoggingEnabledKey] ? @"YES" : @"NO"));
// -> NO

// Set new values
[standardDefaults setBool:NO forKey:kFirstLaunchKey];
[standardDefaults setBool:YES forKey:kLoggingEnabledKey];

NSLog(@"-> %@", ([standardDefaults boolForKey:kFirstLaunchKey] ? @"YES" : @"NO"));
// -> NO
NSLog(@"-> %@", ([standardDefaults boolForKey:kLoggingEnabledKey] ? @"YES" : @"NO"));
// -> YES
```

Now restart the app...

```objective-c
NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
[standardDefaults registerDefaults:@{kFirstLaunchKey: @(YES)}
                  volatileDefaults:@{kLoggingEnabledKey: @(NO)}
                        isVolatile:YES];

NSLog(@"-> %@", ([standardDefaults boolForKey:kFirstLaunchKey] ? @"YES" : @"NO"));
// -> NO
NSLog(@"-> %@", ([standardDefaults boolForKey:kLoggingEnabledKey] ? @"YES" : @"NO"));
// -> NO
```

The key `kFirstLaunchKey` had the value that was set persisted, while the key `kLoggingEnabledKey` did not have it's value persisted and reverted to the default that was passed in to `registerDefaults:volatileDefaults:isVolatile:`.

### isVolatile:NO

Here's an example where `isVolatile:` is set to `NO`:

```objective-c
NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
[standardDefaults registerDefaults:@{kFirstLaunchKey: @(YES)}
                  volatileDefaults:@{kLoggingEnabledKey: @(NO)}
                        isVolatile:NO];

NSLog(@"-> %@", ([standardDefaults boolForKey:kFirstLaunchKey] ? @"YES" : @"NO"));
// -> YES
NSLog(@"-> %@", ([standardDefaults boolForKey:kLoggingEnabledKey] ? @"YES" : @"NO"));
// -> NO

// Set new values
[standardDefaults setBool:NO forKey:kFirstLaunchKey];
[standardDefaults setBool:YES forKey:kLoggingEnabledKey];

NSLog(@"-> %@", ([standardDefaults boolForKey:kFirstLaunchKey] ? @"YES" : @"NO"));
// -> NO
NSLog(@"-> %@", ([standardDefaults boolForKey:kLoggingEnabledKey] ? @"YES" : @"NO"));
// -> YES
```

Now restart the app...

```objective-c
NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
[standardDefaults registerDefaults:@{kFirstLaunchKey: @(YES)}
                  volatileDefaults:@{kLoggingEnabledKey: @(NO)}
                        isVolatile:NO];

NSLog(@"-> %@", ([standardDefaults boolForKey:kFirstLaunchKey] ? @"YES" : @"NO"));
// -> NO
NSLog(@"-> %@", ([standardDefaults boolForKey:kLoggingEnabledKey] ? @"YES" : @"NO"));
// -> YES
```

Note that the only thing that changed was we passed `NO` to `registerDefaults:volatileDefaults:isVolatile:` and that the last call to get the key `kLoggingEnabledKey` returned `YES`, which is the value we had set before the app restart; it was persisted.

Check out the example project included and play around with setting the value of `isVolatile:` to see how it reacts.

## Installation

Use Cocoapods to install or use a git submodule. Then include the necessary categories.

## Contact

[Chris Streeter](http://github.com/streeter)
[@chrisstreeter](https://twitter.com/chrisstreeter)

## License

Touchstone is available under the MIT license. See the LICENSE file for more info.

