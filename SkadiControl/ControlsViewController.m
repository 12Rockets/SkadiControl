//
//  ControlsViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import "ControlsViewController.h"
#import "ToolbarManager.h"

@implementation ControlsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ToolbarManager manager].controlsVC = self;
}

//-(void)onAssetsChanged: (NSNotification *)notification
//{
//    NSString *assetsName = [notification object];
//    SkadiControl *control = [self selectedSkadiControl];
//    
//    
//    if ([assetsName isEqualToString:@"Green"])
//    {
//        [control setAssetsWithNameForConfirm:@"skadi-confirm-green" forRotation:@"skadi-rotate-green" forScaling:@"skadi-scale-green" andForDeletion:@"skadi-delete-green"];;
//        
//    }else if ([assetsName isEqualToString:@"Default"]) {
//        
//        [control setAssetsWithNameForConfirm:@"skadi-confirm-default" forRotation:@"skadi-rotate-default" forScaling:@"skadi-scale-default" andForDeletion:@"skadi-delete-default"];
//        
//    }else if ([assetsName isEqualToString:@"Purple"])
//    {
//        [control setAssetsWithNameForConfirm:@"skadi-confirm-purple" forRotation:@"skadi-rotate-purple" forScaling:@"skadi-scale-purple" andForDeletion:@"skadi-delete-purple"];
//    }
//}


@end
