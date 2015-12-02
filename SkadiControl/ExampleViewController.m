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
#import "Themes.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


@interface ExampleViewController() <SkadiControlDelegate, MoveProtocol, RotateProtocol, ResizeProtocol, ControlsProtocol>

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

- (void)setInitialMoveValues
{
    SkadiControl *control = [self selectedSkadiControl];
    
    [self setToolbarMoveValuesForControl:control];
}

- (void)setInitialResizeValues
{
    SkadiControl *control = [self selectedSkadiControl];
    
    [self setToolbarResizeValuesForControl:control];
}

- (void)setInitialRotationValues
{
    SkadiControl *control = [self selectedSkadiControl];
    
    [self setToolbarRotationValuesForControl:control];
}

- (void)setInitialControlsThemeValues
{
    SkadiControl *control = [self selectedSkadiControl];

    [self setToolbarControlsThemeValuesForControl:control];
}

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

- (void)controlsThemeChanged:(NSString *)themeName
{
    SkadiControl *control = [self selectedSkadiControl];
    control.controlsThemeName = themeName;
    
    if ([themeName isEqualToString:CONTROL_THEME_GREEN])
    {
        [control  setAssetsWithNameForConfirm:@"skadi-confirm-green"
                                  forRotation:@"skadi-rotate-green"
                                   forScaling:@"skadi-scale-green"
                               andForDeletion:@"skadi-delete-green"];;
        
    }else if ([themeName isEqualToString:CONTROL_THEME_DEFAULT]) {
        
        [control  setAssetsWithNameForConfirm:@"skadi-confirm-default"
                                  forRotation:@"skadi-rotate-default"
                                   forScaling:@"skadi-scale-default"
                               andForDeletion:@"skadi-delete-default"];
        
    }else if ([themeName isEqualToString:CONTROL_THEME_PURPLE])
    {
        [control setAssetsWithNameForConfirm:@"skadi-confirm-purple"
                                 forRotation:@"skadi-rotate-purple"
                                  forScaling:@"skadi-scale-purple"
                              andForDeletion:@"skadi-delete-purple"];
    }
    

}

#pragma mark - SkadiControl Delegate Methods

- (void)skadiControlDidSelect:(id)sender
{
    [self deselectAllOtherControlsExcept:sender];
    SkadiControl *control = (SkadiControl *)sender;

    [self setToolbarMoveValuesForControl:control];
    [self setToolbarResizeValuesForControl:control];
    [self setToolbarRotationValuesForControl:control];
    [self setToolbarControlsThemeValuesForControl:control];
}

- (void)skadiControlWillRemove:(id)sender
{
    SkadiControl *control = (SkadiControl *)sender;
    [self.skadiControls removeObject:control];

    if ([control isComponentSelected] && self.skadiControls.count > 0)
    {
        SkadiControl *newSelection = (SkadiControl*)[self.skadiControls firstObject];
        [newSelection setSelected:YES];
        return;
    }
    
    // No component selected
    [self setToolbarMoveValuesForControl:nil];
    [self setToolbarResizeValuesForControl:nil];
    [self setToolbarRotationValuesForControl:nil];
    [self setToolbarControlsThemeValuesForControl:nil];
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

- (void)setToolbarMoveValuesForControl:(SkadiControl *)control
{
    [[ToolbarManager manager].moveVC.xMoveLabel setText:[NSString stringWithFormat:@"%d", control ? (int)control.controlCenter.x : 0]];
    [[ToolbarManager manager].moveVC.yMoveLabel setText:[NSString stringWithFormat:@"%d", control ? (int)control.controlCenter.y : 0]];
    [[ToolbarManager manager].moveVC.xMoveSlider setMaximumValue:self.skadiView.frame.size.width];
    [[ToolbarManager manager].moveVC.xMoveSlider setMinimumValue:0.0];
    [[ToolbarManager manager].moveVC.xMoveSlider setValue:(control ? control.controlCenter.x : 0) animated:YES];
    [[ToolbarManager manager].moveVC.yMoveSlider setMaximumValue:self.skadiView.frame.size.height];
    [[ToolbarManager manager].moveVC.yMoveSlider setMinimumValue:0.0];
    [[ToolbarManager manager].moveVC.yMoveSlider setValue:(control ? control.controlCenter.y : 0) animated:YES];
}
- (void)setToolbarResizeValuesForControl:(SkadiControl *)control
{
    [[ToolbarManager manager].resizeVC.resizeSlider setMaximumValue:control.maxScale];
    [[ToolbarManager manager].resizeVC.resizeSlider setMinimumValue:control.minScale];
    [[ToolbarManager manager].resizeVC.resizeLabel setText:[NSString stringWithFormat:@"%d%%", control ? (int)(control.scale*100) : 0]];
    [[ToolbarManager manager].resizeVC.resizeSlider setValue:(control ? control.scale : 0) animated:YES];
}

- (void)setToolbarRotationValuesForControl:(SkadiControl *)control
{
    [[ToolbarManager manager].rotateVC.rotationLabel setText:[NSString stringWithFormat:@"%d°", control ? (int)RADIANS_TO_DEGREES(control.rotationAngle) : 0]];
    [[ToolbarManager manager].rotateVC.rotationSlider setValue:(control ? control.rotationAngle : 0) animated:YES];
}
- (void)setToolbarControlsThemeValuesForControl:(SkadiControl *)control
{
    [[ToolbarManager manager].controlsVC selectThemeNamed:(control ? control.controlsThemeName : CONTROL_THEME_DEFAULT)];
}

@end
