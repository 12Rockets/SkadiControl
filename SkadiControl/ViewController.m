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

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    SkadiContainer *contariner = [[SkadiContainer alloc]initWithSuperview:self.view];
    [self.view addSubview:contariner];
}


@end
