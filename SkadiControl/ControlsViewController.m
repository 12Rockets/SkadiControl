//
//  ControlsViewController.m
//  SkadiControl
//
//  Created by Marko Čančar on 1.12.15..
//  Copyright © 2015. Aleksandra Stevović. All rights reserved.
//

#import "ControlsViewController.h"
#import "ToolbarManager.h"
#import "Themes.h"

@interface ControlsViewController()

@property (nonatomic, strong)NSArray *controlsArray;

@end

@implementation ControlsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ToolbarManager manager].controlsVC = self;
    
    _controlsPicker.delegate = self;
    
    _controlsArray = [[NSArray alloc] initWithObjects:CONTROL_THEME_GREEN, CONTROL_THEME_DEFAULT, CONTROL_THEME_PURPLE, nil];
    
    [[ToolbarManager manager].delegate setInitialControlsThemeValues];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.controlsArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row)
    {
        case 0:
            return @"Green";
            break;
        case 1:
            return @"Default";
            break;
        case 2:
            return @"Purple";
            break;
        default:
            return @"Undefined";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *themeName = self.controlsArray[row];
    [[ToolbarManager manager].delegate controlsThemeChanged:themeName];
}

- (void)selectThemeNamed:(NSString *)name
{
    for (int i=0; i<self.controlsArray.count; i++)
    {
        if ([name isEqualToString:self.controlsArray[i]])
        {
            [self.controlsPicker selectRow:i inComponent:0 animated:YES];
        }
    }
}

@end
