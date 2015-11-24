//
//  WControlsView.h
//  SkadiControl
//
//  Created by Marko Čančar on 20.11.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WControlButton.h"
#import "SkadiCanvas.h"

@protocol SkadiControlDelegate

- (void)skadiControlDidSelect:(id)sender;
- (void)skadiControlWillRemove:(id)sender;

@end

@interface SkadiControl : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,weak) id<SkadiControlDelegate> delegate;

-(id)initWithFrame:(CGRect)frame
         superview:(UIView *)superview
  controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
     startPosition:(CGPoint)pos
        imageNamed:(NSString*)imageName;

- (void)controlSelected:(BOOL)selected;

- (void)changeCanvasImage:(NSString*)imageName;
- (CGFloat)scale;
- (CGFloat)rotation;
- (void)setTransformWithScale:(CGFloat)scale andRotation:(CGFloat)rotation;

@end

