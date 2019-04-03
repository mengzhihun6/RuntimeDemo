//
//  JGPerson.m
//  RuntimeDemo
//
//  Created by 郭军 on 2019/4/3.
//  Copyright © 2019 guojun. All rights reserved.
//

#import "JGPerson.h"

@implementation JGPerson {
    double _score; //实例变量
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.name = @"小明";
        self.age = 22;
        _score = 66.5;
    }
    return self;
}

//person的2个普通方法
-(void)func1
{
    NSLog(@"执行func1方法。");
}
-(void)func2
{
    NSLog(@"执行func2方法。");
}


- (NSString *)description {
    return [NSString stringWithFormat:@" %d岁的 %@考了%.1f分",self.age,  self.name, _score];
}


@end
