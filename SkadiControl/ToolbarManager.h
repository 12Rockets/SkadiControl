//
//  ToolbarManager.h
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MoveViewController.h"
#import "RotateViewController.h"
#import "ResizeViewController.h"
#import "ControlsViewController.h"

@interface ToolbarManager : NSObject

+ (ToolbarManager *)manager;

@property (nonatomic, strong)MoveViewController *moveVC;
@property (nonatomic, strong)RotateViewController *rotateVC;
@property (nonatomic, strong)ResizeViewController *resizeVC;
@property (nonatomic, strong)ControlsViewController *controlsVC;

@property (nonatomic, strong)id<MoveProtocol, RotateProtocol, ResizeProtocol, ControlsProtocol> delegate;

@end
