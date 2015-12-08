//
//  MoveViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. 12Rockets. All rights reserved.
//

#import "MoveViewController.h"
#import "ToolbarManager.h"

@implementation MoveViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ToolbarManager manager].moveVC = self;
    
    [[ToolbarManager manager].delegate setInitialMoveValues];
}

- (IBAction)xMoveSliderChanged:(UISlider *)sender
{
    [[ToolbarManager manager].delegate xMoveSliderChanged:sender.value];
    [self.xMoveLabel setText:[NSString stringWithFormat:@"%d", (int)sender.value]];
}

- (IBAction)yMoveSliderChanged:(UISlider *)sender
{
    [[ToolbarManager manager].delegate yMoveSliderChanged:sender.value];
    [self.yMoveLabel setText:[NSString stringWithFormat:@"%d", (int)sender.value]];
}

@end
