//
//  ResizeViewController.h
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResizeProtocol <NSObject>

- (void)resizeSliderChanged:(CGFloat)value;

- (void)setInitialResizeValues;

@end

@interface ResizeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *resizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *resizeLabel;

@end
