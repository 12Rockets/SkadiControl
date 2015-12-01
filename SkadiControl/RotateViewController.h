//
//  RotateViewController.h
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RotateProtocol <NSObject>

- (void)rotationSliderChanged:(CGFloat)value;

@end

@interface RotateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *rotationSlider;
@property (weak, nonatomic) IBOutlet UILabel *rotationLabel;

@end