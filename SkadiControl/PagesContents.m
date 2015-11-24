//
//  PagesContents.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/23/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "PagesContents.h"
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
                                             selector:@selector(centerRange:) name:@"CenterRange"
                                               object:nil];
}
-(void)setup
{
    [self.scaleSlider setMaximumValue:1.0f];
    [self.scaleSlider setMaximumValue:100.0f];
    
    [self.rotationSlider setMinimumValue:-2*M_PI];
    [self.rotationSlider setMaximumValue:2*M_PI];

}


- (IBAction)onScaleChanged:(id)sender {
}

- (IBAction)onRotationChanged:(id)sender {

}

- (IBAction)onXCentarChanged:(id)sender {

}
- (IBAction)onYCenterChanged:(id)sender {
}

- (IBAction)onImageChanged:(id)sender {
    
    if ([sender isMemberOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)sender;
        NSString *imageName =btn.currentTitle;
        //set image with this title to be image in the view
    }
}

- (IBAction)onSetChanged:(id)sender {
    
    if ([sender isMemberOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)sender;
        NSString *imageName =btn.currentTitle;
        //set assets with this title to be assets in the view
    }
}
-(void)centerRange: (NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    
    float xRange =[[dict objectForKey:@"xRange"] floatValue];
    float yRange =[[dict objectForKey:@"yRange"] floatValue];
    
    [self.centerXSlider setMinimumValue:0.0f];
    [self.centerXSlider setMaximumValue:xRange -1];
    
    [self.centerYSlider setMinimumValue:0.0f];
    [self.centerYSlider setMaximumValue:yRange -1];
    
}

@end
