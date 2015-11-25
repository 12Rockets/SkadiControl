//
//  PagesContents.h
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/23/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PagesContents : UIViewController
//Page1
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imagesForContainer;

//Page2
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;

//Page3
@property (weak, nonatomic) IBOutlet UISlider *rotationSlider;

//Page4
@property (weak, nonatomic) IBOutlet UISlider *centerXSlider;
@property (weak, nonatomic) IBOutlet UISlider *centerYSlider;

//Page5
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *setOfAssets;
@end
