//
//  ToolbarManager.m
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. 12Rockets. All rights reserved.
//

#import "ToolbarManager.h"

@interface ToolbarManager()


@end

@implementation ToolbarManager

#pragma mark - Initialization

+ (ToolbarManager *)manager
{
    static ToolbarManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ToolbarManager alloc] init];
    });
    return _sharedInstance;
}



@end
