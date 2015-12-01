//
//  PagesContents.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/23/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "PagesContents.h"
#import "SkadiControl.h"
#import "Notifications.h"

@interface PagesContents ()


@end

float xRange;
float yRange;
float scale;
float rotation;
CGPoint position;

@implementation PagesContents

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setInitialData];
}
-(void)setup
{
    [self.scaleSlider setMinimumValue:0.0f];
    [self.scaleSlider setMaximumValue:1.0f];
    
    [self.rotationSlider setMinimumValue:0];
    [self.rotationSlider setMaximumValue:2*M_PI];

}
- (void)setInitialData
{
    xRange = self.selectedControl.frame.size.width;
    yRange = self.selectedControl.frame.size.height;

    scale = self.selectedControl.scale;
    rotation = self.selectedControl.rotationAngle;
    position = self.selectedControl.controlCenter;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.centerXSlider setMinimumValue:0.0f];
    [self.centerXSlider setMaximumValue:xRange];
    
    [self.centerYSlider setMinimumValue:0.0f];
    [self.centerYSlider setMaximumValue:yRange];
    
    [self.scaleSlider setValue:scale];
    [self.rotationSlider setValue:rotation];
    
}

- (IBAction)onScaleChanged:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_SCALE_CHANGED object:[NSNumber numberWithFloat:self.scaleSlider.value]];
}

- (IBAction)onRotationChanged:(id)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_ROTATION_CHANGED object:[NSNumber numberWithFloat:self.rotationSlider.value]];

}

- (IBAction)onXCentarChanged:(id)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_X_CENTER_CHANGED object:[NSNumber numberWithFloat:self.centerXSlider.value]];

}
- (IBAction)onYCenterChanged:(id)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_Y_CENTER_CHANGED object:[NSNumber numberWithFloat:self.centerYSlider.value]];
}

- (IBAction)onImageChanged:(id)sender {
    
    if ([sender isMemberOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)sender;
        NSString *imageName =btn.currentTitle;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_IMAGE_CHANGED object:imageName];
    }
}

- (IBAction)onSetChanged:(id)sender {
    
    if ([sender isMemberOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)sender;
        NSString *imageName =btn.currentTitle;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ON_ASSETS_CHANGED object:imageName];
    }
}


@end
