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

//Page1
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imagesForContainer;

//Page2
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;

//Page3
@property (weak, nonatomic) IBOutlet UISlider *rotationSlider;

//Page4
@property (weak, nonatomic) IBOutlet UISlider *centerXSlider;
@property (weak, nonatomic) IBOutlet UISlider *centerYSlider;

//Page5
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *setOfAssets;

@end

@implementation PagesContents

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centerRange:) name:NOTIFICATION_INITIAL_DATA
                                               object:nil];
}
-(void)setup
{
    [self.scaleSlider setMinimumValue:0.5f];
    [self.scaleSlider setMaximumValue:1.5f];
    
    [self.rotationSlider setMinimumValue:-2*M_PI];
    [self.rotationSlider setMaximumValue:2*M_PI];

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
-(void)centerRange: (NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    
    float xRange =[[dict objectForKey:@"xRange"] floatValue];
    float yRange =[[dict objectForKey:@"yRange"] floatValue];
    float scale =[[dict objectForKey:@"scale"] floatValue];
    float rotation =[[dict objectForKey:@"rotation"] floatValue];
    
    [self.centerXSlider setMinimumValue:0.0f];
    [self.centerXSlider setMaximumValue:xRange -1];
    
    [self.centerYSlider setMinimumValue:0.0f];
    [self.centerYSlider setMaximumValue:yRange -1];
    
    [self.scaleSlider setValue:scale];
    [self.rotationSlider setValue:rotation];
    
}

@end
