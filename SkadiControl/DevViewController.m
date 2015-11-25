//
//  DevViewController.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/19/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "DevViewController.h"
#import "SkadiControl.h"

@interface DevViewController () <SkadiControlDelegate>
@property (nonatomic, strong)SkadiControl *skadi;

@end

@implementation DevViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.skadi = [[SkadiControl alloc] initWithsuperview:self.view controlsDelegate:self imageNamed:@"12rockets"];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)skadiControlDidSelect:(id)sender
{
    NSLog(@"control selected");
}
- (void)skadiControlWillRemove:(id)sender
{
    NSLog(@"control removed");
}
- (void)skadiControlDidTranslate:(id)sender
{
    NSLog(@"control moved: %f, %f", self.skadi.center.x, self.skadi.center.y);
}

- (void)skadiControlDidScale:(id)sender
{
    NSLog(@"control scale: %f", self.skadi.scale);
}

- (void)skadiControlDidRotate:(id)sender
{
    NSLog(@"control rotate: %f", self.skadi.rotationAngle);
    
}

@end
