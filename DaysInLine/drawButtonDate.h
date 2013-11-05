//
//  drawButtonDate.h
//  DaysInLine
//
//  Created by 张力 on 13-11-4.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface drawButtonDate : NSObject{

    NSNumber *startTimeNum;
    NSNumber *endTimeNum;
    BOOL areaFlag[18];
    
}

@property (nonatomic,strong) NSNumber *startTimeNum;
@property (nonatomic,strong) NSNumber *endTimeNum;

@end
