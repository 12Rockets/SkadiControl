//
//  CanvasViewController.h
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CanvasProtocol <NSObject>

- (void)canvasViewChanged:(UIView *)view;

@end

@interface CanvasViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *canvasPicker;

@end
