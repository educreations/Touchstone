//
//  Touchstone.m
//
//  Created by Chris Streeter on 7/25/13.
//  Copyright (c) 2013 Educreations. All rights reserved.
//

#import "Touchstone.h"

@interface Touchstone ()

@property (nonatomic, readwrite, getter=isDebugging) BOOL debugging;
@property (nonatomic, readwrite, strong) NSMutableDictionary *debugRegistrationDictionary;

@end

@implementation Touchstone

#pragma mark -
#pragma mark - NSUserDefaults

+ (instancetype)standardUserDefaults
{
    static Touchstone *_standardUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardUserDefaults = [[self alloc] init];
    });

    return _standardUserDefaults;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.debugging = NO;
    self.debugRegistrationDictionary = [NSMutableDictionary dictionary];

    return self;
}

- (id)objectForKey:(NSString *)defaultName
{
    // If we are not debugging, then we want to return the default object
    // for the key if it exists. Otherwise, revert back to the super
    // implementation.
    if (!self.debugging && [self.debugRegistrationDictionary objectForKey:defaultName] != nil) {
        return [self.debugRegistrationDictionary objectForKey:defaultName];
    }

    return [super objectForKey:defaultName];
}

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    // If we are not debugging, and this is a debug key, then we want to store it as a volatile
    // value. So we replace the value stored in our debugRegistrationDictionary. This way the value
    // can be continued to be re-read this session. But the next time we configure Touchstone,
    // we'll get the default value. Otherwise, use the super implementation which will persist the
    // value.
    if (!self.debugging && [self.debugRegistrationDictionary objectForKey:defaultName] != nil) {
        [self.debugRegistrationDictionary setObject:[value copy] forKey:defaultName];
    } else {
        [super setObject:value forKey:defaultName];
    }
}


#pragma mark -
#pragma mark - Register Defaults

- (void)registerDefaults:(NSDictionary *)registrationDictionary
           debugDefaults:(NSDictionary *)debugRegistrationDictionary
                   debug:(BOOL)debug
{
    // Register the standard defaults. These are volatile unless overriden by
    // the user
    [self registerDefaults:registrationDictionary];

    // Keep track of some state
    self.debugging = debug;
    self.debugRegistrationDictionary = [[NSMutableDictionary alloc] initWithDictionary:debugRegistrationDictionary
                                                                             copyItems:YES];

    // Save the debug registration values. These are persisted. However, we don't overwrite existing
    // values.
    for (id key in debugRegistrationDictionary) {
        if ([super objectForKey:key] == nil) {
            [super setObject:[debugRegistrationDictionary objectForKey:key]
                      forKey:key];
        }
    }
}

@end
