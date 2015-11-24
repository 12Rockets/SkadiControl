//
//  PagesContents.h
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/23/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageControlDelegate

- (void)onScaleChanged:(float)scale;
- (void)onRotationChanged:(float)rotation;

@end

@interface PagesContents : UIViewController

@property(nonatomic, weak) id <PageControlDelegate> delegate;

@end
