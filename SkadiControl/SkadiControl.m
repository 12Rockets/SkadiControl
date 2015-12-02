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

@interface SkadiControl()
@property(nonatomic,strong) WControlButton *scalingControl;
@property(nonatomic,strong) WControlButton *rotationControl;
@property(nonatomic,strong) WControlButton *deletionControl;
@property(nonatomic,strong) WControlButton *confirmControl;


@property(nonatomic) CGFloat validYTranslation;
@property(nonatomic) CGFloat validXTranslation;

@property(nonatomic) CGFloat startRotationAngle;

@property(nonatomic) CGFloat maxScaleDistance;
@property(nonatomic) CGFloat minScaleDistance;

@property(nonatomic) CGPoint translation;

@property(nonatomic) CGPoint rotationControlStartPoint;
@property(nonatomic) BOOL initial;
@property(nonatomic) CGPoint defaultCenterPoint;
@property(nonatomic, strong) SkadiCanvas *canvas;

@property(nonatomic, strong) UIPanGestureRecognizer *translationGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *scalingGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *rotationGestureRecognizer;
@property(nonatomic, strong) UITapGestureRecognizer *deletionTapGestureRecognizer;
@property(nonatomic, strong) UITapGestureRecognizer *confirmTapGestureRecognizer;


@end

@implementation SkadiControl

#pragma mark - Constructors
-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
         startPosition:(CGPoint)pos
            imageNamed:(NSString*)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12rockets"]];
    
   return [self initWithsuperview:superview controlsDelegate:controlsDelegate startPosition:pos view:imageView];
}


-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
            imageNamed:(NSString*)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12rockets"]];
    CGPoint pos = CGPointMake(superview.frame.size.width/2, superview.frame.size.height/2);
    return [self initWithsuperview:superview controlsDelegate:controlsDelegate startPosition:pos view:imageView];
}

-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
         startPosition:(CGPoint)pos
                 image:(UIImage*)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return [self initWithsuperview:superview controlsDelegate:controlsDelegate startPosition:pos view:imageView];
}


-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
                 image:(UIImage*)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGPoint pos = CGPointMake(superview.frame.size.width/2, superview.frame.size.height/2);
    return [self initWithsuperview:superview controlsDelegate:controlsDelegate startPosition:pos view:imageView];
}

-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
         startPosition:(CGPoint)pos
                  view:(UIView*)canvasView
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
        
        self.rotationControl = [[WControlButton alloc] initWithFrame:CGRectMake(-CONTROL_WIDTH/2, self.bounds.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
        
        self.scalingControl = [[WControlButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - CONTROL_WIDTH/2, self.bounds.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
        
        self.deletionControl = [[WControlButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-CONTROL_WIDTH/2, -CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
        
        [self setAssetsWithNameForConfirm:@"skadi-confirm-default" forRotation:@"skadi-rotate-default" forScaling:@"skadi-scale-default" andForDeletion:@"skadi-delete-default"];
        
        [self addSubview:self.confirmControl];
        [self addSubview:self.deletionControl];
        [self addSubview:self.rotationControl];
        [self addSubview:self.scalingControl];
        
        CGSize maxSize = CGSizeMake(superview.frame.size.width, superview.frame.size.height);
        self.maxScaleDistance = pow(pow(maxSize.width/2, 2.0) + pow(maxSize.height/2, 2.0), 0.5);
        CGSize minSize = CGSizeMake(CONTROL_WIDTH, CONTROL_HEIGHT);
        self.minScaleDistance = pow(pow(minSize.width/2, 2.0) + pow(minSize.height/2, 2.0), 0.5);

        _scale = 1.0;
        
        if (self.frame.size.width >= self.frame.size.width)
        {
            _maxScale = maxSize.width/self.frame.size.width;
            _minScale = minSize.height/self.frame.size.height;
        }
        else
        {
            _maxScale = maxSize.height/self.frame.size.height;
            _minScale = minSize.width/self.frame.size.width;
        }
        
        
        self.initial = YES;
        self.controlsThemeName = @"Default";
        self.validYTranslation = 0;
        self.translation = CGPointZero;
        _rotationAngle = 0;
        self.controlCenter = pos;
        
        //rotation
        CGFloat r = [self distanceFromPoint:self.center toPoint:self.rotationControl.center];
        CGFloat y = fabs(self.center.y - self.rotationControl.center.y);
        _startRotationAngle = M_PI_2 + acosf(y/r);

        
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
        
        self.confirmTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmTapGesture:)];
        self.confirmTapGestureRecognizer.numberOfTapsRequired = 1;
        [self.confirmControl addGestureRecognizer:self.confirmTapGestureRecognizer];
        [self.confirmControl setExclusiveTouch:YES];
        self.confirmTapGestureRecognizer.delegate = self;
        
        
        self.userInteractionEnabled = YES;
        [superview addSubview:self];
        [superview sendSubviewToBack:self];
        
        if(self.initial){
            [self restrictCenterPoint];
            self.center = self.defaultCenterPoint;
            self.initial = NO;
        }
        
        self.selected = YES;
    }
    return self;
}


-(id)initWithsuperview:(UIView *)superview
      controlsDelegate:(id<SkadiControlDelegate>)controlsDelegate
                  view:(UIView*)canvasView
{
    CGPoint pos = CGPointMake(superview.frame.size.width/2, superview.frame.size.height/2);
    return [self initWithsuperview:superview controlsDelegate:controlsDelegate startPosition:pos view:canvasView];
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

-(void)confirmTapGesture: (UITapGestureRecognizer *)gestureRecognizer
{
    [self.delegate skadiControlDidConfirm:self];
}
-(void)deletionTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self deleteView];
    [self.delegate skadiControlWillRemove:self];
}
-(void)deleteView
{
    [self removeFromSuperview];
}

- (void)handleRotationControlGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged ||
            gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint currentPoint = [gestureRecognizer locationInView:self.superview];
        CGPoint center = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2);

        CGFloat x = (center.x - currentPoint.x);
        CGFloat y = (center.y - currentPoint.y);
        
        CGFloat r = sqrtf(powf(x, 2.0) + powf(y, 2.0));
        
        CGFloat TETA;
        if (y>0)
        {
            if (x>0)
            {
                TETA = M_PI + acosf(fabs(x)/r);

            }
            else
            {
                TETA = 3*M_PI_2 + acosf(fabs(y)/r);

            }
        }
        else
        {
            if (x<0)
            {
                TETA = acosf(fabs(x)/r);

            }
            else
            {
                TETA = M_PI_2 + acosf(fabs(y)/r);

            }
        }
        
        NSLog(@"Angle: %f", TETA);
        
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(self.translation.x, self.translation.y);
        transform = CGAffineTransformScale(transform, self.scale, self.scale);
        transform = CGAffineTransformRotate(transform, TETA - self.startRotationAngle);
        self.transform = transform;

        CGAffineTransform controlTransform = CGAffineTransformMakeRotation(-TETA+self.startRotationAngle);

        self.confirmControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
        self.scalingControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
        self.rotationControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
        self.deletionControl.transform = CGAffineTransformScale(controlTransform, 1.0/self.scale, 1.0/self.scale);
       
        _rotationAngle = TETA - self.startRotationAngle;
        _rotationAngle = _rotationAngle > 0 ? _rotationAngle : 2*M_PI + TETA - self.startRotationAngle;

        [self.delegate skadiControlDidRotate:self];
    }
}

- (float)distanceFromPoint:(CGPoint)a toPoint:(CGPoint)b
{
    CGFloat x = a.x - b.x;
    CGFloat y = a.y - b.y;
    
    CGFloat r = sqrtf(powf(x, 2.0) + powf(y, 2.0));
    return r;
}

- (void)handleScaleControlGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint currentPoint = [gestureRecognizer locationInView:self.superview];
    CGPoint center = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2);
    CGFloat currentDistance = [self distanceFrom:center to:currentPoint];
    
    CGFloat scaleToPerform = (currentDistance/(self.maxScaleDistance-self.minScaleDistance))*self.maxScale;
    
    scaleToPerform = MIN(self.maxScale, scaleToPerform);
    scaleToPerform = MAX(self.minScale, scaleToPerform);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(self.translation.x, self.translation.y);
    transform = CGAffineTransformScale(transform, scaleToPerform, scaleToPerform);
    transform = CGAffineTransformRotate(transform, self.rotationAngle);
    self.transform = transform;
    
    CGAffineTransform controlTransform = CGAffineTransformMakeScale(1/scaleToPerform, 1/scaleToPerform);
    controlTransform = CGAffineTransformRotate(controlTransform, -self.rotationAngle);
    
    self.confirmControl.transform = controlTransform;
    self.scalingControl.transform = controlTransform;
    self.rotationControl.transform = controlTransform;
    self.deletionControl.transform = controlTransform;
    
    _scale = scaleToPerform;
    
    [self.delegate skadiControlDidScale:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.selected = YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil && self.userInteractionEnabled) {
                self.selected = YES;
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
    
    _controlCenter = CGPointMake(checkPoint.x, checkPoint.y);
    [self.delegate skadiControlDidTranslate:self];

    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        _translation = CGPointMake(xTranslation,
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

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self.canvas setSelected:selected];
    
    [self setHiddenForControls:!selected];
    [self setUserInteractionEnabledForControls:selected];
    if (selected) {
        [self.delegate skadiControlDidSelect:self];
    }
}

- (void)setCanvasImageNamed:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.canvas setCanvasView:imageView];

    [self updateFrames];
}

- (void)setCanvasImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.canvas setCanvasView:imageView];

    [self updateFrames];
}

- (void)setCanvasView:(UIView *)view
{
    [self.canvas setCanvasView:view];
    [self updateFrames];

}

- (void)updateFrames
{
    CGRect frame = self.canvas.frame;
    frame.origin = self.frame.origin;
    self.frame = frame;
    
    self.confirmControl.frame = CGRectMake(-CONTROL_WIDTH/2, -CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT);
    
    self.rotationControl.frame = CGRectMake(-CONTROL_WIDTH/2, self.frame.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT);
    
    self.scalingControl.frame = CGRectMake(self.frame.size.width - CONTROL_WIDTH/2, self.frame.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT);
    
    self.deletionControl.frame = CGRectMake(self.frame.size.width-CONTROL_WIDTH/2, -CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT);

    
    [self setTransformWithScale:self.scale andRotation:self.rotationAngle andTranslation:self.controlCenter];
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

-(void)setTransformWithScale:(CGFloat)scale andRotation:(CGFloat)rotation andTranslation:(CGPoint)position
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
    transform = CGAffineTransformScale(transform, scale, scale);
    transform = CGAffineTransformRotate(transform, rotation);
    
    self.transform = transform;
    
    CGAffineTransform controlTransform = CGAffineTransformMakeScale(1/scale, 1/scale);
    controlTransform = CGAffineTransformRotate(controlTransform, -rotation);
    
    self.confirmControl.transform = controlTransform;
    self.scalingControl.transform = controlTransform;
    self.rotationControl.transform = controlTransform;
    self.deletionControl.transform = controlTransform;
}

-(void)setAssetsWithNameForConfirm: (NSString *)confirmAssetName forRotation: (NSString *)rotationAssetName forScaling: (NSString *)scalingAssetName andForDeletion:(NSString *)deletionAssetName
{
    [self.confirmControl setImage:[UIImage imageNamed:confirmAssetName]];
    [self.rotationControl setImage:[UIImage imageNamed:rotationAssetName]];
    [self.scalingControl setImage:[UIImage imageNamed:scalingAssetName]];
    [self.deletionControl setImage:[UIImage imageNamed:deletionAssetName]];
}


@synthesize scale = _scale;
@synthesize rotationAngle = _rotationAngle;
@synthesize controlCenter = _controlCenter;
-(CGFloat)scale
{
    return _scale;
}

-(CGFloat)rotation
{
    return _rotationAngle;
}

- (CGPoint)controlCenter
{
    return _controlCenter;
}

-(void)setScale:(CGFloat)newTransformScale
{
    _scale = newTransformScale;
    [self setTransformWithScale:newTransformScale andRotation:self.rotationAngle andTranslation:self.translation];
}
-(void)setRotationAngle:(CGFloat)rotationAngle
{
    _rotationAngle= rotationAngle;
    [self setTransformWithScale:self.scale andRotation:rotationAngle andTranslation:self.translation];
}

- (void)setControlCenter:(CGPoint)controlCenter
{
    CGPoint translation = CGPointMake(controlCenter.x-self.controlCenter.x, controlCenter.y-self.controlCenter.y);
    
    CGFloat xTranslation = translation.x + self.translation.x;
    CGFloat yTranslation = translation.y + self.translation.y;
    
    _controlCenter = controlCenter;
    
    _translation = CGPointMake(xTranslation, yTranslation);
    
    [self setTransformWithScale:self.scale andRotation:self.rotationAngle andTranslation:_translation];
}
@end
