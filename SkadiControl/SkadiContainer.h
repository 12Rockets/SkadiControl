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


/**
 * @brief The default constructor.
 * @param superview A superview on which SkadiControll will be attached.
 * @return SkadiControl view.
 */
- (instancetype)initWithDefaultFrame;

@end
