//
//  Touchstone.h
//  Touchstone Example
//
//  Created by Chris Streeter on 7/25/13.
//  Copyright (c) 2013 Educreations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Touchstone : NSUserDefaults

@property (nonatomic, readonly, getter=isDebugging) BOOL debugging;

+ (instancetype)standardUserDefaults;

- (void)registerDefaults:(NSDictionary *)registrationDictionary
           debugDefaults:(NSDictionary *)debugRegistrationDictionary
                   debug:(BOOL)debug;

@end
