//
//  ViewController.m
//
//  Created by Chris Streeter on 7/25/13.
//  Copyright (c) 2013 Educreations. All rights reserved.
//

#import "ViewController.h"

#import "Defaults.h"
#import "NSUserDefaults+Touchstone.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectZero];
    CGRect switchFrame = s.frame;
    switchFrame.origin = (CGPoint) {
        CGRectGetMidX(self.view.bounds),
        CGRectGetMidY(self.view.bounds),
    };
    s.frame = switchFrame;
    s.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLoggingEnabledKey];
    [s addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:s];
}

- (void)switchDidChange:(UISwitch *)aSwitch
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setBool:aSwitch.on forKey:kLoggingEnabledKey];

    // This needs to be called, even if isVolatile is set to true. We might have saved
    // a non-volatile key that should be persisted.
    [standardDefaults synchronize];
}

@end
