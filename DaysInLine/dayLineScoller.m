//
//  dayLineScoller.m
//  DaysInLine
//
//  Created by 张力 on 13-10-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "dayLineScoller.h"
#import "buttonInScroll.h"

@interface dayLineScoller ()



@end

@implementation dayLineScoller


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        CGSize newSize = CGSizeMake(self.frame.size.width-85, self.frame.size.height+320);
        [self setContentSize:newSize];
        
        self.btnInScroll = [[buttonInScroll alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 3*self.frame.size.height)];
        [self addSubview:self.btnInScroll];


        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int t=6;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); //设置线的颜色为灰色
    
    CGContextSetLineWidth(context, 1.5f); //设置线的宽度 为1.5个像素
    CGContextMoveToPoint(context, self.frame.size.width/2+18, 0);
    CGContextAddLineToPoint(context, self.frame.size.width/2+18, self.frame.size.height);
    CGContextStrokePath(context);
    
    
    for (int i=0; i<self.frame.size.height+310;i=i+30) {
       
/*        UIButton *buttonWorks1 = [[UIButton alloc]initWithFrame:CGRectMake(0, i+10, self.frame.size.width/2, 30)];
        buttonWorks1.backgroundColor = [UIColor blueColor];
        buttonWorks1.layer.borderWidth = 1.0;

        buttonWorks1.layer.borderColor = [UIColor blackColor].CGColor;
        [buttonWorks1 setTitle:@"11111" forState:UIControlStateNormal];
*/
        UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(0, i, 36, 20)];
        NSString *time = [NSString stringWithFormat:@"%d:00",t];
        t++;
        labelTime.font = [UIFont systemFontOfSize:14.0];
        labelTime.text = time;

        [self addSubview:labelTime];
//        [self addSubview:buttonWorks1];
    }

 
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
