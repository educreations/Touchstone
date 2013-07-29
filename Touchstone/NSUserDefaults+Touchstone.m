//
//  NSUserDefaults+Touchstone.m
//
//  Created by Chris Streeter on 7/26/13.
//  Copyright (c) 2013 Educreations. All rights reserved.
//

#import "NSUserDefaults+Touchstone.h"

#import <objc/runtime.h>

static void TSSwizzleInstanceMethods(Class klass, SEL original, SEL new)
{
    Method origMethod = class_getInstanceMethod(klass, original);
    Method newMethod = class_getInstanceMethod(klass, new);

    if (class_addMethod(klass, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(klass, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}


static char kTSIsVolatileObjectKey;
static char kTSVolatileDictionaryObjectKey;


@interface NSUserDefaults (_Touchstone)

@property (nonatomic, readwrite) BOOL isVolatile;
@property (nonatomic, readwrite, strong) NSMutableDictionary *volatileDictionary;

@end

#pragma mark -
#pragma mark - NSUserDefaults+Touchstone

@implementation NSUserDefaults (Touchstone)

@dynamic isVolatile;

#pragma mark -
#pragma mark - Class Loading

+ (void)load
{
    // Swizzle for fun and profit
    TSSwizzleInstanceMethods(self, @selector(objectForKey:), @selector(ts_objectForKey:));
    TSSwizzleInstanceMethods(self, @selector(setObject:forKey:), @selector(ts_setObject:forKey:));
}

#pragma mark -
#pragma mark - Defaults Registration

- (void)registerDefaults:(NSDictionary *)registrationDictionary
        volatileDefaults:(NSDictionary *)volatileRegistrationDictionary
              isVolatile:(BOOL)isVolatile
{
    // Register the standard defaults. These are volatile unless overriden by
    // the user.
    [self registerDefaults:registrationDictionary];

    NSMutableDictionary *volatileDictionary = [[NSMutableDictionary alloc] initWithDictionary:volatileRegistrationDictionary
                                                                                    copyItems:YES];

    // Keep track of some state
    [self setIsVolatile:isVolatile];
    [self setVolatileDictionary:volatileDictionary];

    // If we are not volatile, then treat the volatileDictionary as normal registration defaults.
    // Otherwise, the volatile defaults will be handled by our custom object getter and setter
    // overrides.
    if (!self.isVolatile) {
        [self registerDefaults:volatileRegistrationDictionary];
    }
}

#pragma mark -
#pragma mark - Object Getter/Setter Overrides

- (id)ts_objectForKey:(NSString *)defaultName
{
    // If we have volatile defaults, then we want to return the default object
    // for the key if it exists. Otherwise, revert back to the super
    // implementation.
    BOOL isVolatile = [self isVolatile];
    NSMutableDictionary *volatileDictionary = [self volatileDictionary];

    if (isVolatile && [volatileDictionary objectForKey:defaultName] != nil) {
        return [volatileDictionary objectForKey:defaultName];
    }

    // Refer to the original method, which was swizzled.
    return [self ts_objectForKey:defaultName];
}

- (void)ts_setObject:(id)value forKey:(NSString *)defaultName
{
    // If we have volatile defaults, and this is a volatile key, then we want to store it as a
    // volatile value. So we replace the value stored in our volatileRegistrationDictionary. This
    // way the value can be continued to be re-read this session. But the next time we configure
    // Touchstone, we'll get the default value. Otherwise, use the super implementation which will
    // persist the value.
    BOOL isVolatile = [self isVolatile];
    NSMutableDictionary *volatileDictionary = [self volatileDictionary];

    if (isVolatile && [volatileDictionary objectForKey:defaultName] != nil) {
        [volatileDictionary setObject:[value copy] forKey:defaultName];
    } else {
        // Refer to the original method, which was swizzled.
        [self ts_setObject:value forKey:defaultName];
    }
}


#pragma mark -
#pragma mark - Internal Property Accessors

- (BOOL)isVolatile
{
    NSNumber *boolNumber = (NSNumber *)objc_getAssociatedObject(self, &kTSIsVolatileObjectKey);
    return [boolNumber boolValue];
}

@end

#pragma mark -
#pragma mark - NSUserDefaults+_Touchstone

@implementation NSUserDefaults (_Touchstone)

@dynamic isVolatile;
@dynamic volatileDictionary;

#pragma mark -
#pragma mark - Internal Property Accessors

- (void)setIsVolatile:(BOOL)isVolatile
{
    objc_setAssociatedObject(self, &kTSIsVolatileObjectKey, @(isVolatile), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)volatileDictionary
{
    return (NSMutableDictionary *)objc_getAssociatedObject(self, &kTSVolatileDictionaryObjectKey);
}

- (void)setVolatileDictionary:(NSMutableDictionary *)volatileDictionary
{
    objc_setAssociatedObject(self, &kTSVolatileDictionaryObjectKey, volatileDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
