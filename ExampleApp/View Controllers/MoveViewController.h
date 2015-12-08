//
//  MoveViewController.h
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. 12Rockets. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoveProtocol <NSObject>

- (void)xMoveSliderChanged:(CGFloat)value;
- (void)yMoveSliderChanged:(CGFloat)value;

- (void)setInitialMoveValues;

@end

@interface MoveViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *xMoveSlider;
@property (weak, nonatomic) IBOutlet UISlider *yMoveSlider;
@property (weak, nonatomic) IBOutlet UILabel *xMoveLabel;
@property (weak, nonatomic) IBOutlet UILabel *yMoveLabel;

@end
