//
//  WControlsView.m
//  SkadiControl
//
//  Created by Marko Čančar on 20.11.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import "SkadiControl.h"
#import "SkadiCanvas.h"

#define USING_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IPAD_SCALE 1.5

#define CONTROL_WIDTH   (USING_IPAD ? IPAD_SCALE*30.0 : 29.0)
#define CONTROL_HEIGHT  (USING_IPAD ? IPAD_SCALE*30.0 : 29.0)
#define LABEL_SCALE     (USING_IPAD ? IPAD_SCALE*0.4  : 0.8)
#define MAX_SCALE       (USING_IPAD ? IPAD_SCALE*5.2  : 5.2)
#define MIN_SCALE       (USING_IPAD ? IPAD_SCALE*0.2  : 0.2)


@interface SkadiControl()
@property(nonatomic,strong) WControlButton *scalingControl;
@property(nonatomic,strong) WControlButton *rotationControl;
@property(nonatomic,strong) WControlButton *deletionControl;
@property(nonatomic,strong) WControlButton *confirmControl;


@property(nonatomic) CGFloat validYTranslation;
@property(nonatomic) CGFloat validXTranslation;
@property(nonatomic) CGPoint translation;
@property(nonatomic) CGPoint scalingControlStartPoint;
@property(nonatomic) CGPoint rotationControlStartPoint;
@property(nonatomic) CGFloat rotationAngle;
@property(nonatomic) BOOL initial;
@property(nonatomic) CGPoint defaultCenterPoint;
@property(nonatomic, strong) SkadiCanvas *canvas;

@property(nonatomic, strong) UIPanGestureRecognizer *translationGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *scalingGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *rotationGestureRecognizer;
@property(nonatomic, strong) UITapGestureRecognizer *deletionTapGestureRecognizer;

@end

@implementation SkadiControl

-(id)initWithFrame:(CGRect)frame
      superview:(UIView *)superview
       controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
  startPosition:(CGPoint)pos
     imageNamed:(NSString*)imageName
{
    // Initialize adjustable view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12rockets"]];
    
    self = [super initWithFrame:imageView.frame];
    
    if (self) {
        
        self.canvas = [[SkadiCanvas alloc] initWithCanvasView:imageView];
        [self addSubview:self.canvas];
        
        self.defaultCenterPoint = pos;
    
        // Initialize controls
        self.delegate = controlsDelegate;
        
        self.confirmControl = [[WControlButton alloc] initWithFrame:CGRectMake(-CONTROL_WIDTH/2, -CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [self.confirmControl setImage:[UIImage imageNamed:@"textbox_duplicate"]];
        
        self.rotationControl = [[WControlButton alloc] initWithFrame:CGRectMake(-CONTROL_WIDTH/2, self.bounds.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [self.rotationControl setImage:[UIImage imageNamed:@"textbox_rotate"]];
        
        self.scalingControl = [[WControlButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - CONTROL_WIDTH/2, self.bounds.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [self.scalingControl setImage:[UIImage imageNamed:@"textbox_resize"]];
        
        self.deletionControl = [[WControlButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-CONTROL_WIDTH/2, -CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [self.deletionControl setImage:[UIImage imageNamed:@"textbox_close"]];
        
        [self addSubview:self.confirmControl];
        [self addSubview:self.deletionControl];
        [self addSubview:self.rotationControl];
        [self addSubview:self.scalingControl];
        
        self.initial = YES;
        
        self.scale = LABEL_SCALE;
        self.validYTranslation = 0;
        self.translation = CGPointZero;
        self.rotationAngle = 0;
        
        CGAffineTransform transform = CGAffineTransformMakeScale(self.scale, self.scale);
        transform = CGAffineTransformTranslate(transform, self.translation.x, self.translation.y);
        self.transform = CGAffineTransformRotate(transform, self.rotationAngle);
        self.confirmControl.transform = CGAffineTransformMakeScale(1.0/self.scale, 1.0/self.scale);
        self.scalingControl.transform = CGAffineTransformMakeScale(1.0/self.scale, 1.0/self.scale);
        self.rotationControl.transform = CGAffineTransformMakeScale(1.0/self.scale, 1.0/self.scale);
        self.deletionControl.transform = CGAffineTransformMakeScale(1.0/self.scale, 1.0/self.scale);
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.userInteractionEnabled = YES;
        self.scalingControl.userInteractionEnabled = YES;
        self.scalingControl.userInteractionEnabled = YES;
        self.rotationControl.userInteractionEnabled = YES;
        self.deletionControl.userInteractionEnabled = YES;
    
        //Gesture recognizers
        self.rotationGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationControlGesture:)];
        self.rotationGestureRecognizer.minimumNumberOfTouches = 1;
        self.rotationGestureRecognizer.maximumNumberOfTouches = 1;
        [self.rotationControl addGestureRecognizer:self.rotationGestureRecognizer];
        [self.rotationControl setExclusiveTouch:YES];
        self.rotationGestureRecognizer.delegate = self;
        
        self.scalingGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScaleControlGesture:)];
        self.scalingGestureRecognizer.minimumNumberOfTouches = 1;
        self.scalingGestureRecognizer.maximumNumberOfTouches = 1;
        [self.scalingControl addGestureRecognizer:self.scalingGestureRecognizer];
        [self.scalingControl setExclusiveTouch:YES];
        self.scalingGestureRecognizer.delegate = self;
        
        self.translationGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTranslationGesture:)];
        self.translationGestureRecognizer.minimumNumberOfTouches = 1;
        self.translationGestureRecognizer.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:self.translationGestureRecognizer];
        self.translationGestureRecognizer.delegate = self;
        
        self.deletionTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletionTapGesture:)];
        self.deletionTapGestureRecognizer.numberOfTapsRequired = 1;
        [self.deletionControl addGestureRecognizer:self.deletionTapGestureRecognizer];
        [self.deletionControl setExclusiveTouch:YES];
        self.deletionTapGestureRecognizer.delegate = self;
        
        self.userInteractionEnabled = YES;
        [superview addSubview:self];
        
        if(self.initial){
            [self restrictCenterPoint];
            self.center = self.defaultCenterPoint;
            self.initial = NO;
        }
        
        [self controlSelected:YES];
    }
    return self;
}


#pragma mark -
#pragma mark Gesture handling

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGRect confirmFrame = CGRectInset(self.confirmControl.frame, -10, -10);
    CGRect scalingFrame = CGRectInset(self.scalingControl.frame, -10, -10);
    CGRect rotationFrame = CGRectInset(self.rotationControl.frame, -10, -10);
    CGRect deleteFrame = CGRectInset(self.deletionControl.frame, -10, -10);
    if(gestureRecognizer == self.translationGestureRecognizer)
    {
        if(CGRectContainsPoint(scalingFrame,  [touch locationInView:self])  ||
           CGRectContainsPoint(rotationFrame, [touch locationInView:self])  ||
           CGRectContainsPoint(deleteFrame,   [touch locationInView:self])  ||
           CGRectContainsPoint(confirmFrame,  [touch locationInView:self])
           )
            return NO;
    }
    return YES;
}

-(void)deletionTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.delegate skadiControlWillRemove:self];
}

- (void)handleRotationControlGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.rotationControlStartPoint = [gestureRecognizer locationInView:self.superview];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged ||
            gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(self.translation.x, self.translation.y);
        
        CGPoint currentPoint = [gestureRecognizer locationInView:self.superview];
        CGPoint center = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2);
        
        CGFloat startDistance = [self distanceFrom:center to:self.rotationControlStartPoint];
        if(startDistance==0)
            return;
        
        CGFloat currentAngle = atan2f(currentPoint.y-center.y, currentPoint.x - center.x);
        CGFloat startAngle = atan2f(self.rotationControlStartPoint.y-center.y, self.rotationControlStartPoint.x - center.x);
        
        
        transform = CGAffineTransformScale(transform, self.scale, self.scale);
        transform = CGAffineTransformRotate(transform, currentAngle-startAngle+self.rotationAngle);
        self.transform = transform;

        CGAffineTransform controlTransform = CGAffineTransformMakeRotation(-currentAngle+startAngle-self.rotationAngle);

        self.confirmControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
        self.scalingControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
        self.rotationControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
        self.deletionControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
       
        
        if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            self.rotationAngle += currentAngle-startAngle;
        }
    }
}

- (void)handleScaleControlGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.scalingControlStartPoint = [gestureRecognizer locationInView:self.superview];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged ||
            gestureRecognizer.state==UIGestureRecognizerStateEnded)
    {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(self.translation.x, self.translation.y);
        
        CGPoint currentPoint = [gestureRecognizer locationInView:self.superview];
        CGPoint center = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2);
        
        CGFloat startDistance = [self distanceFrom:center to:self.scalingControlStartPoint];
        CGFloat currentDistance = [self distanceFrom:center to:currentPoint];
        if(startDistance==0)
            return;
        
        CGFloat newScale = currentDistance/startDistance;
        
        CGFloat scaleToPerform = MIN(MAX_SCALE, newScale*self.scale);
        scaleToPerform = MAX(MIN_SCALE, scaleToPerform);
        
        transform = CGAffineTransformScale(transform, scaleToPerform, scaleToPerform);
        transform = CGAffineTransformRotate(transform, self.rotationAngle);
        self.transform = transform;
        
        
        CGAffineTransform controlTransform = CGAffineTransformMakeScale(1/scaleToPerform, 1/scaleToPerform);
        controlTransform = CGAffineTransformRotate(controlTransform, -self.rotationAngle);
        
        self.confirmControl.transform = controlTransform;
        self.scalingControl.transform = controlTransform;
        self.rotationControl.transform = controlTransform;
        self.deletionControl.transform = controlTransform;
        
        
        if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            self.scale = scaleToPerform;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self controlSelected:YES];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil && self.userInteractionEnabled) {
                [self controlSelected:YES];
                return result;
            }
        }
    }
    return nil;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for(UIView *editableView in [self.subviews reverseObjectEnumerator]){
        if(self.userInteractionEnabled && [editableView pointInside:[self convertPoint:point toView:editableView] withEvent:event]){
            return YES;
        }
    }
    return NO;
}



- (CGFloat)distanceFrom:(CGPoint)firstPoint to:(CGPoint)secondPoint
{
    return sqrtf(powf(firstPoint.x-secondPoint.x,2)+powf(firstPoint.y-secondPoint.y,2));
}


-(BOOL)outOfBounds:(CGPoint)point{
    
    BOOL answer = NO;
    
    if(point.y > self.superview.bounds.size.height || point.y < 0 ||
       point.x > self.superview.bounds.size.width || point.x < 0)
        answer = YES;
    
    return answer;
}

- (void)handleTranslationGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint checkPoint = [gestureRecognizer locationInView:self.superview];
    CGPoint translation = [gestureRecognizer translationInView:self.superview];
    
    CGFloat xTranslation = translation.x + self.translation.x;
    CGFloat yTranslation = translation.y + self.translation.y;
    
    if([self outOfBounds:checkPoint]){
        xTranslation = self.validXTranslation;
        yTranslation = self.validYTranslation;
    }
    else{
        self.validXTranslation = xTranslation;
        self.validYTranslation = yTranslation;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(xTranslation, yTranslation);
    
    transform = CGAffineTransformScale(transform, self.scale, self.scale);
    transform = CGAffineTransformRotate(transform, self.rotationAngle);
    self.transform = transform;
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        self.translation = CGPointMake(xTranslation,
                                       yTranslation);

    }
}
- (void)setHiddenForControls:(BOOL)hidden
{
    [self.confirmControl setHidden:hidden];
    [self.scalingControl setHidden:hidden];
    [self.rotationControl setHidden:hidden];
    [self.deletionControl setHidden:hidden];
}

- (void)setUserInteractionEnabledForControls:(BOOL)enabled
{
    [self.confirmControl setUserInteractionEnabled:enabled];
    [self.scalingControl setUserInteractionEnabled:enabled];
    [self.rotationControl setUserInteractionEnabled:enabled];
    [self.deletionControl setUserInteractionEnabled:enabled];
}


- (void)controlSelected:(BOOL)selected
{
    self.canvas.selected = selected;

    [self setHiddenForControls:!selected];
    [self setUserInteractionEnabledForControls:selected];
    if (selected) {
        [self.delegate skadiControlDidSelect:self];
    }
}

- (void)setCanvasImageNamed:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textbox_duplicate"]];
    [self.canvas setCanvasView:imageView];
}

- (void)setCanvasImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.canvas setCanvasView:imageView];
}

- (void)setCanvasView:(UIView *)view
{
    [self.canvas setCanvasView:view];
}

-(void)restrictCenterPoint
{
    CGFloat newXCord = self.defaultCenterPoint.x;
    CGFloat newYCord = self.defaultCenterPoint.y;
    
    if(self.defaultCenterPoint.x < self.frame.size.width/2)
        newXCord = 0 + self.frame.size.width/2;// - CONTROL_WIDTH;
    else if(self.defaultCenterPoint.x > self.superview.frame.size.width - self.frame.size.width/2)
        newXCord = self.superview.frame.size.width - self.frame.size.width/2;// + CONTROL_WIDTH;
    
    if(self.defaultCenterPoint.y < self.frame.size.height/2)
        newYCord = 0 + self.frame.size.height/2 + CONTROL_HEIGHT/2;
    else if(self.defaultCenterPoint.y > self.superview.frame.size.height - self.frame.size.height/2)
        newYCord = self.superview.frame.size.height - self.frame.size.height/2 - CONTROL_HEIGHT/2;
    
    self.defaultCenterPoint = CGPointMake(newXCord, newYCord);
}

-(void)setTransformWithScale:(CGFloat)scale andRotation:(CGFloat)rotation
{
    self.scale = scale;
    self.rotationAngle = rotation;
    self.translation = CGPointZero;
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    transform = CGAffineTransformRotate(transform, rotation);
    
    self.transform = transform;

    self.confirmControl.transform = CGAffineTransformMakeScale(1.0/scale, 1.0/scale);
    self.scalingControl.transform = CGAffineTransformMakeScale(1.0/scale, 1.0/scale);
    self.rotationControl.transform = CGAffineTransformMakeScale(1.0/scale, 1.0/scale);
    self.deletionControl.transform = CGAffineTransformMakeScale(1.0/scale, 1.0/scale);
}

-(CGFloat)scale
{
    return _scale;
}

-(CGFloat)rotation
{
    return _rotationAngle;
}

@end
