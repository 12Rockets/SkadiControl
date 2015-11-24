//
//  DevViewController.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/19/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "DevViewController.h"
#import "SkadiControl.h"

@interface DevViewController () <SkadiControlDelegate>
@property (nonatomic, strong)SkadiControl *sticker;

@end

@implementation DevViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.sticker = [[SkadiControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)
                                                 superview:self.view
                                          controlsDelegate:self
                                             startPosition:CGPointMake(400.0, 400.0)
                                                imageNamed:@"textbox_duplicate"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)skadiControlDidSelect:(id)sender
{
    NSLog(@"Sticker selected");    
}
- (void)skadiControlWillRemove:(id)sender
{
    NSLog(@"Sticker removed");
}
@end
