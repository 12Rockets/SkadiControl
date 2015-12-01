//
//  CanvasViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import "CanvasViewController.h"
#import "ToolbarManager.h"

@implementation CanvasViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ToolbarManager manager].canvasVC = self;
}

@end
