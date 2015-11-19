//
//  SkadiContainer.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/19/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "SkadiContainer.h"

#define CONTROL_WIDTH  30.0
#define CONTROL_HEIGHT 30.0
@interface SkadiContainer()

@property (strong,nonatomic) UIView *superview;
@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UIView *canvasView;

@end
@implementation SkadiContainer

-(instancetype)initWithSuperview: (UIView *)superview
{
    
    
    self = [super initWithFrame:CGRectMake( 0, 0, 1, 1)];
    if (self) {
        
        self.superview =superview;
        [self updateFrame];
        self.backgroundColor = [UIColor redColor];
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(CONTROL_WIDTH/2, CONTROL_HEIGHT/2, self.frame.size.height - CONTROL_HEIGHT, self.frame.size.width - CONTROL_WIDTH)];
        self.contentView.backgroundColor = [UIColor blueColor];
        
        [self addSubview:self.contentView];
        [self loadCommands];
        
        self.canvasView = [[UIView alloc] initWithFrame:CGRectMake(CONTROL_WIDTH/2, CONTROL_HEIGHT/2, self.contentView.frame.size.height - CONTROL_HEIGHT, self.contentView.frame.size.width - CONTROL_WIDTH)];
        [self.contentView addSubview:self.canvasView];
        
    }
    
    return self;
}

-(void)updateFrame
{
    float heightSuperView = self.superview.frame.size.height;
    float widthSuperView = self. superview.frame.size.width;
    
    float width = widthSuperView/2;
    
    float xCenter = width/2;
    float yCenter = heightSuperView/2 - xCenter;
    
    CGRect newFrame = CGRectMake( xCenter, yCenter ,width , width);
    self.frame = newFrame;
    
}

- (void)loadCommands
{
    self.confirmComamnd = [[UIButton  alloc] initWithFrame:CGRectMake(-CONTROL_WIDTH/2, -CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
    
    self.deleteCommand = [[UIButton  alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-CONTROL_WIDTH/2, -CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
    
    self.rotateCommand = [[UIButton alloc] initWithFrame:CGRectMake(-CONTROL_WIDTH/2,  self.contentView.frame.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
    
    self.resizeCommand = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - CONTROL_WIDTH/2, self.frame.size.height - CONTROL_HEIGHT/2, CONTROL_WIDTH, CONTROL_HEIGHT)];
    
    [self setImagesForCommands];
    
    [self.contentView addSubview:self.confirmComamnd];
    [self.contentView addSubview:self.deleteCommand];
    [self.contentView addSubview:self.rotateCommand];
    [self.contentView addSubview:self.resizeCommand];
}
-(void)setImagesForCommands
{
    [self.rotateCommand setBackgroundImage:[UIImage imageNamed:@"textbox_rotate"] forState:UIControlStateNormal];
    [self.resizeCommand setBackgroundImage:[UIImage imageNamed:@"textbox_resize"] forState:UIControlStateNormal];
    [self.deleteCommand setBackgroundImage:[UIImage imageNamed:@"textbox_close"] forState:UIControlStateNormal];
    [self.confirmComamnd setBackgroundImage:[UIImage imageNamed:@"textbox_duplicate"] forState:UIControlStateNormal];
}
@end
