//
//  SkadiContainer.m
//  SkadiControl
//
//  Created by Aleksandra Stevović on 11/19/15.
//  Copyright © 2015 Aleksandra Stevović. All rights reserved.
//

#import "SkadiContainer.h"

#define CONTROL_SIZE            30.0

#define DEFAULT_SIZE            100.0
#define DEFAULT_ASPECT_RATIO    1 // width/height


@interface SkadiContainer()

@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UIView *canvasView;

@property (nonatomic, strong) UIButton * confirmComamnd;
@property (nonatomic, strong) UIButton * deleteCommand;
@property (nonatomic, strong) UIButton * rotateCommand;
@property (nonatomic, strong) UIButton * resizeCommand;

@end

@implementation SkadiContainer


-(instancetype)initWithDefaultFrame
{
    self.contentView = [[UIView alloc]init];
    self.canvasView = [[UIView alloc] init];
    [self loadCommands];
    [self.contentView addSubview:self.canvasView];

    self = [super initWithFrame:CGRectMake(0, 0, DEFAULT_SIZE*DEFAULT_ASPECT_RATIO, DEFAULT_SIZE)];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor blueColor];
        [self.canvasView setBackgroundColor:[UIColor yellowColor]];
        self.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.contentView];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [self updateFramesForFrame:self.frame];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateFramesForFrame:frame];
}


-(void)updateFramesForFrame:(CGRect)frame
{
    [self.contentView setFrame:CGRectMake(CONTROL_SIZE/2, CONTROL_SIZE/2, frame.size.width - CONTROL_SIZE, frame.size.height - CONTROL_SIZE)];
    [self.canvasView setFrame:CGRectMake(CONTROL_SIZE/2, CONTROL_SIZE/2, self.contentView.frame.size.width - CONTROL_SIZE, self.contentView.frame.size.height - CONTROL_SIZE)];
    self.confirmComamnd.frame = CGRectMake(-CONTROL_SIZE/2, -CONTROL_SIZE/2, CONTROL_SIZE, CONTROL_SIZE);
    self.deleteCommand.frame = CGRectMake(self.contentView.frame.size.width-CONTROL_SIZE/2, -CONTROL_SIZE/2, CONTROL_SIZE, CONTROL_SIZE);
    self.rotateCommand.frame = CGRectMake(-CONTROL_SIZE/2,  self.contentView.frame.size.height - CONTROL_SIZE/2, CONTROL_SIZE, CONTROL_SIZE);
    self.resizeCommand.frame = CGRectMake(self.contentView.frame.size.width - CONTROL_SIZE/2, self.contentView.frame.size.height - CONTROL_SIZE/2, CONTROL_SIZE, CONTROL_SIZE);
}


- (void)loadCommands
{
    self.confirmComamnd = [[UIButton  alloc] init];
    self.deleteCommand = [[UIButton  alloc] init];
    self.rotateCommand = [[UIButton alloc] init];
    self.resizeCommand = [[UIButton alloc] init];
    
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
