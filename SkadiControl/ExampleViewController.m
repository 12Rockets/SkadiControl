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
#import "PagesContents.h"

@interface ExampleViewController() <SkadiControlDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerNames;
@property (weak, nonatomic) IBOutlet UIView *viewForControls;
@property (weak, nonatomic) IBOutlet UIView *skadiView;

@property (strong, nonatomic) SkadiControl *skadi;
@end


@implementation ExampleViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewControllerNames = [NSMutableArray arrayWithObjects: @"ImageVC", @"ScaleVC", @"RotationVC",@"CenterVC", @"SetVC", nil];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageVC"];
    self.pageViewController.dataSource = self;
    
    [self loadPageControllers];
   [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.view.frame = self.viewForControls.bounds;
    [self addChildViewController:_pageViewController];
    [self.viewForControls addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    self.skadi = [[SkadiControl alloc] initWithsuperview:self.view controlsDelegate:self imageNamed:@"12rockets-square"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self notifications];
    
    float xRange = self.skadiView.frame.size.width;
    float yRange = self.skadiView.frame.size.height;
    float initialScale = self.skadi.scale;
    float initialRotation = self.skadi.rotationAngle;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithFloat:xRange] forKey:@"xRange"];
    [dict setObject:[NSNumber numberWithFloat:yRange] forKey:@"yRange"];
    [dict setObject:[NSNumber numberWithFloat:initialScale] forKey:@"scale"];
    [dict setObject:[NSNumber numberWithFloat:initialRotation] forKey:@"rotation"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_INITIAL_DATA object:dict];
}

-(void)notifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onScaleChanged:) name:NOTIFICATION_ON_SCALE_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRotationChanged:) name:NOTIFICATION_ON_ROTATION_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCenterXChanged:) name:NOTIFICATION_ON_X_CENTER_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onCenterYChanged:) name:NOTIFICATION_ON_Y_CENTER_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onImageChanged:) name:NOTIFICATION_ON_IMAGE_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAssetsChanged:) name:NOTIFICATION_ON_ASSETS_CHANGED
                                               object:nil];
}
-(void)onScaleChanged: (NSNotification *)notification
{
    float scale = [[notification object] floatValue];
    [self.skadi setScale:scale];

}
-(void)onRotationChanged: (NSNotification *)notification
{
    float rotation = [[notification object] floatValue];
    [self.skadi setRotationAngle:rotation];
}
-(void)onCenterXChanged: (NSNotification *)notification
{
    float centerX = [[notification object] floatValue];
    //change centerX
}
-(void)onCenterYChanged: (NSNotification *)notification
{
    float centerY = [[notification object] floatValue];
    //change centerY
}
-(void)onImageChanged: (NSNotification *)notification
{
    NSString *imageName = [notification object];
    if ([imageName isEqualToString:@"Rect1"])
    {
          [self.skadi setCanvasImageNamed:@"12rockets-rect1"];
        
    }else if ([imageName isEqualToString:@"Rect2"]) {
        
        [self.skadi setCanvasImageNamed:@"12rockets-rect2"];
        
    }else if ([imageName isEqualToString:@"Square"])
    {
        [self.skadi setCanvasImageNamed:@"12rockets-square"];
    }

}
-(void)onAssetsChanged: (NSNotification *)notification
{
    NSString *assetsName = [notification object];
    
    if ([assetsName isEqualToString:@"Blue"])
    {
        [self.skadi setAssetsWithNameForConfirm:@"confirm-blue" forRotation:@"rotate-blue" forScaling:@"scale-blue" andForDeletion:@"delete-blue"];
        
    }else if ([assetsName isEqualToString:@"Yellow"]) {
        
        [self.skadi setAssetsWithNameForConfirm:@"confirm-yellow" forRotation:@"rotate-yellow" forScaling:@"scale-yellow" andForDeletion:@"delete-yellow"];
        
    }else if ([assetsName isEqualToString:@"Red"])
    {
        [self.skadi setAssetsWithNameForConfirm:@"confirm-red" forRotation:@"rotate-red" forScaling:@"scale-red" andForDeletion:@"delete-red"];
    }
}
- (void)skadiControlDidSelect:(id)sender
{
    NSLog(@"control selected");
}
- (void)skadiControlWillRemove:(id)sender
{
    NSLog(@"control removed");
}
- (void)skadiControlDidTranslate:(id)sender
{
    NSLog(@"control moved: %f, %f", self.skadi.center.x, self.skadi.center.y);
}

- (void)skadiControlDidScale:(id)sender
{
   // NSLog(@"control scale: %f", self.skadi.transformScale);
    for (PagesContents *pVC in self.viewControllerArray)
    {
        if ([pVC.restorationIdentifier isEqualToString:@"ScaleVC"])
        {
            [pVC.scaleSlider setValue:self.skadi.transformScale animated:YES];
        }
    }
}

- (void)skadiControlDidRotate:(id)sender
{
    NSLog(@"control rotate: %f", self.skadi.rotationAngle);
    for (PagesContents *pVC in self.viewControllerArray)
    {
        if ([pVC.restorationIdentifier isEqualToString:@"RotationVC"])
        {
            [pVC.rotationSlider setValue:self.skadi.rotationAngle animated:YES];
        }
    }
    
}

- (NSMutableArray *)viewControllerArray
{
    if (!_viewControllerArray)
    {
        _viewControllerArray = [[NSMutableArray alloc] init];
    }
    return _viewControllerArray;
}

-(void)loadPageControllers
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    for (NSString *name in self.viewControllerNames) {
        
        PagesContents *vc = [story instantiateViewControllerWithIdentifier:name];
        [self.viewControllerArray addObject:vc];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [self.viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.viewControllerArray count]) {
        return nil;
    }
    return [self.viewControllerArray objectAtIndex:index];
}

-(NSInteger)indexOfController:(UIViewController *)viewController
{
    for (int i = 0; i<[self.viewControllerArray count]; i++) {
        if (viewController == [self.viewControllerArray objectAtIndex:i])
        {
            return i;
        }
    }
    return NSNotFound;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.viewControllerNames count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
