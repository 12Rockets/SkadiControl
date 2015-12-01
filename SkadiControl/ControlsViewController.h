//
//  ControlsViewController.h
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlsProtocol <NSObject>

- (void)controlsChangedConfirm:(NSString *)confirm
                   forRotation:(NSString *)rotation
                    forScaling:(NSString *)scaling
                andForDeletion:(NSString *)deletion;

@end

@interface ControlsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *controlsPicker;

@end
