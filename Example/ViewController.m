//
//  ViewController.m
//
//  Created by Chris Streeter on 7/25/13.
//  Copyright (c) 2013 Educreations. All rights reserved.
//

#import "ViewController.h"

#import "Defaults.h"
#import "Touchstone.h"

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
    s.on = [[Touchstone standardUserDefaults] boolForKey:kLoggingEnabledKey];
    [s addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:s];
}

- (void)switchDidChange:(UISwitch *)aSwitch
{
    Touchstone *touchstone = [Touchstone standardUserDefaults];
    [touchstone setBool:aSwitch.on forKey:kLoggingEnabledKey];
    [touchstone synchronize];
}

@end
