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
- (void)skadiControlDidScale:(id)sender;
- (void)skadiControlDidRotate:(id)sender;
- (void)skadiControlDidTranslate:(id)sender;

@end

@interface SkadiControl : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,weak) id<SkadiControlDelegate> delegate;

@property(nonatomic) CGFloat scale;
@property(nonatomic) CGFloat rotationAngle;

-(id)initWithsuperview:(UIView *)superview
  controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
     startPosition:(CGPoint)pos
        imageNamed:(NSString*)imageName;


-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
            imageNamed:(NSString*)imageName;

-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
         startPosition:(CGPoint)pos
            image:(UIImage*)image;


-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
            image:(UIImage*)image;

-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
         startPosition:(CGPoint)pos
                 view:(UIView*)canvasView;


-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
                 view:(UIView*)canvasView;


- (void)controlSelected:(BOOL)selected;

-(void)setAssetsWithNameForConfirm:(NSString *)confirm
                        forControl:(NSString *)rotation
                        forScaling:(NSString *)scaling
                    andForDeletion:(NSString *)deletion;

- (void)setCanvasImageNamed:(NSString *)imageName;
- (void)setCanvasImage:(UIImage *)image;
- (void)setCanvasView:(UIView *)view;

-(void)setRotationAngle:(CGFloat)rotationAngle;
-(void)setScale:(CGFloat)scale;

@end
