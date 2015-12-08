//
//  RotateViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. 12Rockets. All rights reserved.
//

#import "RotateViewController.h"
#import "ToolbarManager.h"
#import "SkadiControl.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation RotateViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ToolbarManager manager].rotateVC = self;
    
    [self.rotationSlider setMaximumValue:MAX_ROTATION];
    [self.rotationSlider setMinimumValue:MIN_ROTATION];
    
    [[ToolbarManager manager].delegate setInitialRotationValues];
}

- (IBAction)rotationSliderChanged:(UISlider *)sender
{
    [[ToolbarManager manager].delegate rotationSliderChanged:sender.value];
    [self.rotationLabel setText:[NSString stringWithFormat:@"%d°", (int)RADIANS_TO_DEGREES(sender.value)]];

}

@end
