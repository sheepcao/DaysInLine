//
//  editingViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-10-22.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "editingViewController.h"

@interface editingViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) UILabel *startLabel;

@end

@implementation editingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.startTimeButton addTarget:self action:@selector(startTimeTapped) forControlEvents:UIControlEventTouchUpInside];

    self.startTimeButton.layer.borderWidth = 3.5;
    self.startTimeButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)startTimeTapped
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
	[actionSheet showInView:self.view];
    
	UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
	datePicker.tag = 101;
	datePicker.datePickerMode = UIDatePickerModeTime;
	[actionSheet addSubview:datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
	
		
    formatter.dateFormat = @"H:mm";
    NSString *timestart = [formatter stringFromDate:datePicker.date];
    self.startLabel = (UILabel *)[self.view viewWithTag:103];
	[(UILabel *)[self.view viewWithTag:103] setText:timestart];
    [self.startTimeButton setTitle:@"" forState:UIControlStateNormal];
    NSLog(@"%@\n",self.startLabel.text);
    NSLog(@"%@",timestart);
    NSArray *startTime = [timestart componentsSeparatedByString:@":"];
    int hour = [startTime[0] intValue];
    int minite = [startTime[1] intValue];
    NSLog(@"hour:%d,minite:%d",hour,minite);

    NSString *s = [NSString stringWithFormat:@"%i",minite];
    NSLog(@"%@",s);
    
    
 
	
}

@end
