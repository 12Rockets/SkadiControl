//
//  ViewController.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/19/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "ViewController.h"
#import "SkadiContainer.h"

@interface ViewController ()
@property (nonatomic, strong)SkadiContainer *contariner;
@end

@implementation ViewController

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
