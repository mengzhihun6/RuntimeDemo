//
//  JGPerson.h
//  RuntimeDemo
//
//  Created by 郭军 on 2019/4/3.
//  Copyright © 2019 guojun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JGPerson : NSObject

@property (nonatomic, copy) NSString *name; //属性变量

@property (nonatomic, assign) int age;

-(void)func1;
-(void)func2;

@end

NS_ASSUME_NONNULL_END
