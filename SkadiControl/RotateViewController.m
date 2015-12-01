//
//  RotateViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import "RotateViewController.h"
#import "ToolbarManager.h"
#import "SkadiControl.h"

@implementation RotateViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ToolbarManager manager].rotateVC = self;
    
    [self.rotationSlider setMaximumValue:MAX_ROTATION];
    [self.rotationSlider setMinimumValue:MIN_ROTATION];
}

- (IBAction)rotationSliderChanged:(UISlider *)sender
{
    [[ToolbarManager manager].delegate rotationSliderChanged:sender.value];
}

@end
