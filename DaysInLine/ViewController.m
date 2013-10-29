//
//  ViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "ViewController.h"
#import "homeView.h"
#import "daylineView.h"
#import "dayLineScoller.h"
#import "buttonInScroll.h"
#import "editingViewController.h"


@interface ViewController ()

@property (nonatomic,weak) UIImageView *background;
@property (nonatomic,weak) homeView *homePage;
@property (nonatomic,strong) daylineView *my_dayline ;
@property (nonatomic,strong) dayLineScoller *my_scoller;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    homeView *my_homeView = [[homeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:my_homeView];
    self.homePage = my_homeView;

    
    [my_homeView.todayButton addTarget:self action:@selector(todayTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    NSLog(@"x:%f,y:%f\nwidth%f,height%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
      
       
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)todayTapped
{
    CGRect frame = CGRectMake(85,0, self.view.bounds.size.width-85, self.view.bounds.size.height );
    self.my_dayline = [[daylineView alloc] initWithFrame:frame];
    [self.homePage addSubview:self.my_dayline];
    
     self.my_scoller = [[dayLineScoller alloc] initWithFrame:CGRectMake(86,110, self.view.bounds.size.width-86.4, self.view.bounds.size.height-220)];

    [self.homePage addSubview:self.my_scoller];
    
    for (int i = 0; i<10; i++) {
        [[self.my_dayline.starArray objectAtIndex:i] addTarget:self action:@selector(starTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.my_dayline.addMoreLife addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.my_dayline.addMoreWork addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)starTapped:(UIButton*)sender
{
    if (sender.tag <100) {
        
        for (int i = 0; i<=sender.tag; i++) {
            [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
        }
        for (int j = sender.tag+1; j<5; j++) {
        [[self.my_dayline.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
        }
       
    }
    else
    {
        for (int i = 0; i<=sender.tag-100; i++) {
            [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
        }
        for (int j = sender.tag-99; j<5; j++) {
            [[self.my_dayline.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)eventTapped:(UIButton *)sender
{
   editingViewController *my_editingViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    
    [self presentViewController:my_editingViewController animated:YES completion:Nil ];

    
}

@end
