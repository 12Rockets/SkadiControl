//
//  SkadiCanvas.h
//  SkadiControl
//
//  Created by Marko Čančar on 20.11.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkadiCanvas : UIView

@property(nonatomic) BOOL selected;

- (id)initWithCanvasView:(UIView *)view;
- (void)setCanvasView:(UIView *)view;

@end
