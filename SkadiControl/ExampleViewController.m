//
//  ExampleViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 20.11.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import "ExampleViewController.h"
#import "SkadiControl.h"

@interface ExampleViewController() <SkadiControlDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerNames;
@property (weak, nonatomic) IBOutlet UIView *viewForControls;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) SkadiControl *container;
@end


@implementation ExampleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.viewControllerNames = [NSMutableArray arrayWithObjects: @"PageOne", @"PageTwo", @"PageThree",@"PageFour", @"PageFive", nil];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageVC"];
    self.pageViewController.dataSource = self;
    
    [self loadPageControllers];
   [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.view.frame = self.viewForControls.bounds;
    [self addChildViewController:_pageViewController];
    [self.viewForControls addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    self.container = [[SkadiControl alloc] initWithFrame:CGRectZero superview:self.view controlsDelegate:self startPosition:CGPointMake(200, 200) imageNamed:@"12rockets"];
}

- (void)skadiControlDidSelect:(id)sender
{
    NSLog(@"Sticker selected");
}
- (void)skadiControlWillRemove:(id)sender
{
    NSLog(@"Sticker removed");
}

-(void)viewWillLayoutSubviews
{
    float xRange = self.containerView.frame.size.width;
    float yRange = self.containerView.frame.size.height;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithFloat:xRange] forKey:@"xRange"];
    [dict setObject:[NSNumber numberWithFloat:yRange] forKey:@"yRange"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenterRange" object:dict];
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
        
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:name];
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
