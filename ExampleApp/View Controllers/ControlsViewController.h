//
//  ControlsViewController.h
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. 12Rockets. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlsProtocol <NSObject>

- (void)controlsThemeChanged:(NSString *)themeName;

- (void)setInitialControlsThemeValues;

@end

@interface ControlsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *controlsPicker;

- (void)selectThemeNamed:(NSString *)name;

@end
