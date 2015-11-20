//
//  DevViewController.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/19/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "DevViewController.h"
#import "SkadiContainer.h"

@interface DevViewController ()
@property (nonatomic, strong)SkadiContainer *contariner;
@end

@implementation DevViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.contariner = [[SkadiContainer alloc] initWithDefaultFrame];
    
    [self.view addSubview:self.contariner];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.contariner setFrame:CGRectMake(20, 100, 300, 200)];
}

@end
