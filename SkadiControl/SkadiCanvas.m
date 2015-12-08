//
//  SkadiCanvas.m
//  SkadiControl
//
//  Created by Marko Čančar on 20.11.15..
//  Copyright © 2015. 12Rockets. All rights reserved.
//

#import "SkadiCanvas.h"

@interface SkadiCanvas()

@property(nonatomic, strong) UIView* canvas;

@end

@implementation SkadiCanvas

- (id)initWithCanvasView:(UIView *)view
{
    self = [super initWithFrame:view.frame];
    
    if (self) {
        self.opaque = NO;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        _canvas = view;
        [self addSubview:_canvas];
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.222]];
        self.layer.cornerRadius = self.frame.size.width * 0.025;
        [self sizeToFit];

        _selected = YES;
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    if  (_selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.222]];
    }
    else
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    _selected = selected;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self;
    }
    return nil;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.bounds, point)) {
        return YES;
    }
    return NO;
}

- (void)setCanvasView:(UIView*)view
{
    [_canvas removeFromSuperview];
    _canvas = view;
    [self addSubview:_canvas];
    self.frame = view.frame;
}


@end
