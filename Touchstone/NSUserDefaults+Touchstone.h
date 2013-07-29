//
//  NSUserDefaults+Touchstone.h
//
//  Created by Chris Streeter on 7/26/13.
//  Copyright (c) 2013 Educreations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Touchstone)

@property (nonatomic, readonly) BOOL isVolatile;

- (void)registerDefaults:(NSDictionary *)registrationDictionary
        volatileDefaults:(NSDictionary *)volatileRegistrationDictionary
              isVolatile:(BOOL)isVolatile;

@end
