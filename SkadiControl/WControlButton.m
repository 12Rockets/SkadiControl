//
//  WControlButton.m
//  CustomTextView
//
//  Created by Marko Čančar on 9/5/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import "WControlButton.h"

@implementation WControlButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setClipsToBounds:NO];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    CGFloat insetHeight = 0.0;
    CGFloat insetWidth = 0.0;
    if (self.superview)
    {
        insetWidth  -= (self.superview.bounds.size.width > 100) ? 10.0 : self.superview.bounds.size.width * 0.1;
        insetHeight -= (self.superview.bounds.size.height > 100) ? 10.0 : self.superview.bounds.size.height * 0.1;
    }
    CGRect touchRect = CGRectInset(self.bounds, insetWidth, insetHeight);
    if (CGRectContainsPoint(touchRect, point)) {
        return self;
    }
    return nil;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat insetHeight = 0.0;
    CGFloat insetWidth = 0.0;
    if (self.superview)
    {
        insetWidth  -= (self.superview.bounds.size.width > 100) ? 10.0 : self.superview.bounds.size.width * 0.1;
        insetHeight -= (self.superview.bounds.size.height > 100) ? 10.0 : self.superview.bounds.size.height * 0.1;
    }
    CGRect touchRect = CGRectInset(self.bounds, insetWidth, insetHeight);
    if (CGRectContainsPoint(touchRect, point)) {
        return YES;
    }
    return NO;
}
@end
