//
//  ExampleViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 20.11.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import "ExampleViewController.h"
#import "SkadiControl.h"
#import "Notifications.h"
#import "ToolbarManager.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


@interface ExampleViewController() <SkadiControlDelegate, MoveProtocol, RotateProtocol, ResizeProtocol, CanvasProtocol, ControlsProtocol>

@property (nonatomic, strong)NSMutableArray *skadiControls;

@property (weak, nonatomic) IBOutlet UIView *skadiView;

@end


@implementation ExampleViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [ToolbarManager manager].delegate = self;
}

- (IBAction)addSkadi:(id)sender
{
    [self.skadiControls addObject:[[SkadiControl alloc] initWithsuperview:self.skadiView controlsDelegate:self imageNamed:@"12rockets-square"]];
}

#pragma mark - Toolbar Delegate Methods

- (void)xMoveSliderChanged:(CGFloat)value
{
    SkadiControl *control = [self selectedSkadiControl];
    [control setControlCenter:CGPointMake(value, control.controlCenter.y)];
}

- (void)yMoveSliderChanged:(CGFloat)value
{
    SkadiControl *control = [self selectedSkadiControl];
    [control setControlCenter:CGPointMake(control.controlCenter.x, value)];
}

- (void)rotationSliderChanged:(CGFloat)value
{
    [[self selectedSkadiControl] setRotationAngle:value];
}

- (void)resizeSliderChanged:(CGFloat)value
{
    [[self selectedSkadiControl] setScale:value];
}

- (void)canvasViewChanged:(UIView *)view
{
    SkadiControl *control = [self selectedSkadiControl];
    
    [control setCanvasView:view];
}

- (void)controlsChangedConfirm:(NSString *)confirm
                   forRotation:(NSString *)rotation
                    forScaling:(NSString *)scaling
                andForDeletion:(NSString *)deletion
{
    SkadiControl *control = [self selectedSkadiControl];
    [control setAssetsWithNameForConfirm:confirm forRotation:rotation forScaling:scaling andForDeletion:deletion];;
}

#pragma mark - SkadiControl Delegate Methods

- (void)skadiControlDidSelect:(id)sender
{
    [self deselectAllOtherControlsExcept:sender];
    SkadiControl *control = (SkadiControl *)sender;
    
    [[ToolbarManager manager].moveVC.xMoveLabel setText:[NSString stringWithFormat:@"%d", (int)control.controlCenter.x]];
    [[ToolbarManager manager].moveVC.yMoveLabel setText:[NSString stringWithFormat:@"%d", (int)control.controlCenter.y]];
    
    [[ToolbarManager manager].moveVC.xMoveSlider setMaximumValue:self.skadiView.frame.size.width];
    [[ToolbarManager manager].moveVC.xMoveSlider setMinimumValue:0.0];
    [[ToolbarManager manager].moveVC.xMoveSlider setValue:control.controlCenter.x animated:YES];
    [[ToolbarManager manager].moveVC.yMoveSlider setMaximumValue:self.skadiView.frame.size.height];
    [[ToolbarManager manager].moveVC.yMoveSlider setMinimumValue:0.0];
    [[ToolbarManager manager].moveVC.yMoveSlider setValue:control.controlCenter.y animated:YES];
    
    [[ToolbarManager manager].resizeVC.resizeSlider setMaximumValue:control.maxScale];
    [[ToolbarManager manager].resizeVC.resizeSlider setMinimumValue:control.minScale];
    [[ToolbarManager manager].resizeVC.resizeLabel setText:[NSString stringWithFormat:@"%d%%", (int)(control.scale*100)]];
    [[ToolbarManager manager].resizeVC.resizeSlider setValue:control.scale animated:YES];

    [[ToolbarManager manager].rotateVC.rotationLabel setText:[NSString stringWithFormat:@"%d°", (int)RADIANS_TO_DEGREES(control.rotationAngle)]];
    
    [[ToolbarManager manager].rotateVC.rotationSlider setValue:control.rotationAngle animated:YES];
}

- (void)skadiControlWillRemove:(id)sender
{
    SkadiControl *control = (SkadiControl *)sender;
    [self.skadiControls removeObject:control];

    if ([control isComponentSelected])
    {
        SkadiControl *newSelection = (SkadiControl*)[self.skadiControls firstObject];
        [newSelection setSelected:YES];
    }
}

- (void)skadiControlDidConfirm:(id)sender
{
    NSLog(@"control is confirmed");
}

- (void)skadiControlDidTranslate:(id)sender
{
    SkadiControl *control = (SkadiControl *)sender;
    [[ToolbarManager manager].moveVC.xMoveLabel setText:[NSString stringWithFormat:@"%d", (int)control.controlCenter.x]];
    [[ToolbarManager manager].moveVC.yMoveLabel setText:[NSString stringWithFormat:@"%d", (int)control.controlCenter.y]];
    
    [[ToolbarManager manager].moveVC.xMoveSlider setValue:control.controlCenter.x animated:YES];
    [[ToolbarManager manager].moveVC.yMoveSlider setValue:control.controlCenter.y animated:YES];
}

- (void)skadiControlDidScale:(id)sender
{
    SkadiControl *control = (SkadiControl *)sender;
    
    [[ToolbarManager manager].resizeVC.resizeLabel setText:[NSString stringWithFormat:@"%d%%", (int)(control.scale*100)]];
    
    [[ToolbarManager manager].resizeVC.resizeSlider setValue:control.scale animated:YES];
}

- (void)skadiControlDidRotate:(id)sender
{
    SkadiControl *control = (SkadiControl *)sender;
    
    [[ToolbarManager manager].rotateVC.rotationLabel setText:[NSString stringWithFormat:@"%d°", (int)RADIANS_TO_DEGREES(control.rotationAngle)]];
    
    [[ToolbarManager manager].rotateVC.rotationSlider setValue:control.rotationAngle animated:YES];
}

#pragma mark - Utils

- (NSMutableArray *)skadiControls
{
    if (!_skadiControls)
    {
        _skadiControls = [[NSMutableArray alloc] init];
    }
    return _skadiControls;
}

- (SkadiControl *)selectedSkadiControl
{
    for (SkadiControl *sc in self.skadiControls)
    {
        if ([sc isComponentSelected])
        {
            return sc;
        }
    }
    return nil;
}

- (void)deselectAllOtherControlsExcept:(id)sender
{
    for (SkadiControl *sc in self.skadiControls)
    {
        if ([sc isComponentSelected] && sender != sc)
        {
            [sc setSelected:NO];
        }
    }
}

@end
