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
#import "globalVars.h"


@interface ViewController ()

@property (nonatomic,weak) UIImageView *background;
@property (nonatomic,weak) homeView *homePage;
@property (nonatomic,strong) daylineView *my_dayline ;
@property (nonatomic,strong) dayLineScoller *my_scoller;
@property (nonatomic,strong) NSString *today;
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
 

    
    
    //创建或打开数据库
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.sqlite"]];
    
 //   NSFileManager *filemanager = [NSFileManager defaultManager];
    
    NSLog(@"路径：%@",databasePath);
    
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
 /*           NSString *createsql = @"CREATE TABLE IF NOT EXISTS DAYTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,DATE TEXT UNIQUE,MOOD INTEGER,GROWTH INTEGER)";
 */
            NSString *createDayable = @"CREATE TABLE IF NOT EXISTS DAYTABLE (DATE TEXT PRIMARY KEY,MOOD INTEGER,GROWTH INTEGER)";
            NSString *createEvent = @"CREATE TABLE IF NOT EXISTS EVENT (eventID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE INTEGER,TITLE TEXT,mainText TEXT,income REAL,expend REAL,date TEXT,startTime TEXT,endTime TEXT,distance TEXT,label TEXT,remind INTEGER,startArea INTEGER,photoDir TEXT)";
            NSString *createRemind = @"CREATE TABLE IF NOT EXISTS REMIND (remindID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER,date TEXT,fromToday TEXT,time TEXT)";

            [self execSql:createDayable];
            [self execSql:createEvent];
            [self execSql:createRemind];
        }
        else {
            NSLog(@"数据库打开失败");
            
        }
    
    sqlite3_close(dataBase);
    

    
    
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
    for (int i=0; i<18; i++) {
        area[i] = 0;
    }
    
    CGRect frame = CGRectMake(85,0, self.view.bounds.size.width-85, self.view.bounds.size.height );
    self.my_dayline = [[daylineView alloc] initWithFrame:frame];
    [self.homePage addSubview:self.my_dayline];
    
     self.my_scoller = [[dayLineScoller alloc] initWithFrame:CGRectMake(86,110, self.view.bounds.size.width-86.4, self.view.bounds.size.height-220)];
    
    self.my_scoller.my_delegate = self;
    

    [self.homePage addSubview:self.my_scoller];
    
    for (int i = 0; i<10; i++) {
        [[self.my_dayline.starArray objectAtIndex:i] addTarget:self action:@selector(starTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.my_dayline.addMoreLife addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.my_dayline.addMoreWork addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd"];
    self.today= [formater stringFromDate:curDate];
    NSLog(@"!!!!!!!%@",self.today);
    sqlite3_stmt *statement;
    
    modifyDate = self.today;
    const char *dbpath = [databasePath UTF8String];
    //查看当天是否已经有数据
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE=\"%@\"",modifyDate];
        const char *querystatement = [querySQL UTF8String];
        if (sqlite3_prepare_v2(dataBase, querystatement, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //当天数据已经存在，则取出数据还原界面
                int moodNum = sqlite3_column_int(statement, 0);
                for (int i = 0; i<=moodNum-1; i++) {
                    [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                
             
                int growthNum = sqlite3_column_int(statement, 1);
                for (int i = 0; i<=growthNum-1; i++) {
                    [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                
            }
            else {
                 // 插入当天的数据
                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
                
                //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
                const char *insertsatement = [insertSql UTF8String];
                sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
                sqlite3_bind_text(statement, 1, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 2, 0);
                sqlite3_bind_int(statement, 3, 0);
                
                
                if (sqlite3_step(statement)==SQLITE_DONE) {
                    NSLog(@"innsert today ok");
                }
                else {
                    NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                }
                
            }
            
        }
        else{
            NSLog(@"Error in select:%s",sqlite3_errmsg(dataBase));

        }
        sqlite3_finalize(statement);
      
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
      sqlite3_close(dataBase);

    
    // 插入当天的数据
 
    
   /* if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
        
        //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
        const char *insertsatement = [insertSql UTF8String];
        sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
        sqlite3_bind_text(statement, 1, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, 0);
        sqlite3_bind_int(statement, 3, 0);
        
        
        if (sqlite3_step(statement)==SQLITE_DONE) {
            NSLog(@"innsert today ok");
        }
        else {
            NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    
    sqlite3_close(dataBase);
    
    */

    
    
}

-(void)starTapped:(UIButton*)sender
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        
        
        if (sender.tag <100) {
            
            for (int i = 0; i<=sender.tag; i++) {
                [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
            }
            for (int j = sender.tag+1; j<5; j++) {
                [[self.my_dayline.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
            }
            
            //数据库更新
            
            sqlite3_stmt *stmt;
            //如果已经存在并且已登陆，则修改状态值
            const char *Update="update DAYTABLE set MOOD=?where date=?";
            if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, sender.tag+1);
            sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            
        }
        else
        {
            for (int i = 0; i<=sender.tag-100; i++) {
                [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
            }
            for (int j = sender.tag-99; j<5; j++) {
                [[self.my_dayline.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
            }
            
            //数据库更新
            sqlite3_stmt *stmt;
            //如果已经存在并且已登陆，则修改状态值
            const char *Update="update DAYTABLE set growth=?where date=?";
            if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, sender.tag-99);
            sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
        }
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    
    sqlite3_close(dataBase);
    
}

-(void)eventTapped:(UIButton *)sender
{
   editingViewController *my_editingViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    my_editingViewController.eventType = [NSNumber numberWithInt:sender.tag];
    NSLog(@"type is:%@",my_editingViewController.eventType);
    my_editingViewController.delegate = self.my_scoller;

    
    my_editingViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:my_editingViewController animated:YES completion:Nil ];
    
}

//数据库操作方法
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSLog(@"数据库操作数据失败!");
    }
}

#pragma mark modify delegation

-(void)modifyEvent
{
    editingViewController *my_modifyViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    my_modifyViewController.delegate = self.my_scoller;
    
    my_modifyViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:my_modifyViewController animated:YES completion:Nil ];

}

@end
