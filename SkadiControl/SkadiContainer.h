//
//  SkadiContainer.h
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/19/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkadiContainer : UIView

@property (nonatomic, strong) UIButton * confirmComamnd;
@property (nonatomic, strong) UIButton * deleteCommand;
@property (nonatomic, strong) UIButton * rotateCommand;
@property (nonatomic, strong) UIButton * resizeCommand;


-(instancetype)initWithSuperview: (UIView *)superview;

@end
