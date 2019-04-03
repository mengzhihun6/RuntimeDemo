//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 郭军 on 2019/4/3.
//  Copyright © 2019 guojun. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "JGPerson.h"
#import "JGPerson+JGCategory.h"


@interface ViewController ()

@end

@implementation ViewController {
    JGPerson *_person;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _person = [[JGPerson alloc] init];
    
    
    /*
     //https://www.cnblogs.com/azuo/p/5505782.html
     我们通过继承于NSObject的person类，来对runtime进行学习。
     
     本文共有6个关于runtime机制方法的小例子，分别是：
     
      1、 获取person类的所有变量；
      2、获取person类的所有方法；
      3、改变person类的私有变量name的值；
      4、为person的category类增加一个新属性；
      5、为person类添加一个方法；
      6、交换person类的2个方法的功能；
     */
}

/*1.获取person所有的成员变量*/
- (IBAction)Func1:(id)sender {
    
    unsigned int count = 0;
    //获取类的一个包含所有变量的列表，IVar是runtime声明的一个宏，是实例变量的意思.
    Ivar *allIvariables = class_copyIvarList([JGPerson class], &count);
    
    for (int i = 0; i < count; i++) {
        //遍历每一个变量，包含名称和类型(此处没有星号“*”)
        Ivar ivar = allIvariables[i];
        //获取成员变量名称
        const char *VariableName = ivar_getName(ivar);
        //获取成员变量类型
        const char *VariableType = ivar_getTypeEncoding(ivar);
        
        NSLog(@"名称:%s => 类型:%s",VariableName, VariableType);
    }
    
    /*
     得到的输出如下：(i表示类型为int d表示类型为double)
     2019-04-03 15:59:17.415756+0800 RuntimeDemo[20661:192149] 名称:_score => 类型:d
     2019-04-03 15:59:17.415868+0800 RuntimeDemo[20661:192149] 名称:_age => 类型:i
     2019-04-03 15:59:17.415939+0800 RuntimeDemo[20661:192149] 名称:_name => 类型:@"NSString"
     */
}


/*2.获取person所有方法*/
- (IBAction)Func2:(id)sender {
    
    unsigned int count = 0;
    //获取方法列表，所有在.m文件显式实现的方法都会被找到，包括setter+getter方法；
    Method *allMethods = class_copyMethodList([JGPerson class], &count);
    
    for (int i = 0; i < count; i++) {
        //Method，为runtime声明的一个宏，表示对一个方法的描述
        Method md = allMethods[i];
        //获取SEL：SEL类型,即获取方法选择器@selector()
        SEL sel = method_getName(md);
        //得到sel的方法名：以字符串格式获取sel的name，也即@selector()中的方法名称
        const char *methodName = sel_getName(sel);
        
        NSLog(@"Method%d:%s",i+1, methodName);
    }
    
    /*
     控制台输出：
     2019-04-03 16:09:18.052985+0800 RuntimeDemo[20818:197062] Method1:eat
     2019-04-03 16:09:18.053088+0800 RuntimeDemo[20818:197062] Method2:.cxx_destruct
     2019-04-03 16:09:18.053154+0800 RuntimeDemo[20818:197062] Method3:description
     2019-04-03 16:09:18.053212+0800 RuntimeDemo[20818:197062] Method4:name
     2019-04-03 16:09:18.053273+0800 RuntimeDemo[20818:197062] Method5:setName:
     2019-04-03 16:09:18.053333+0800 RuntimeDemo[20818:197062] Method6:init
     2019-04-03 16:09:18.053389+0800 RuntimeDemo[20818:197062] Method7:run
     2019-04-03 16:09:18.053443+0800 RuntimeDemo[20818:197062] Method8:setAge:
     2019-04-03 16:09:18.053502+0800 RuntimeDemo[20818:197062] Method9:age
     */
    
}

/*3.改变person的name变量属性*/
- (IBAction)Func3:(id)sender {
    NSLog(@"改变之前的Penson:%@",_person);
    
    unsigned int count = 0;
    
    Ivar *allList = class_copyIvarList([JGPerson class], &count);
    
    Ivar ivar = allList[2];
    //从第一个例子getAllVariable中输出的控制台信息，我们可以看到name为第2个实例属性；
    // object_setIvar(<#id  _Nullable obj#>, <#Ivar  _Nonnull ivar#>, <#id  _Nullable value#>)
    object_setIvar(_person, ivar, @"小刚"); //name属性小明被强制改为小刚。
    
    NSLog(@"改变之后的Penson:%@",_person);
    
    /*
     控制台输出：
     2019-04-03 16:20:51.312155+0800 RuntimeDemo[20975:202727] 改变之前的Penson: 22岁的 小明考了66.5分
     2019-04-03 16:20:51.312235+0800 RuntimeDemo[20975:202727] 改变之后的Penson: 22岁的 小刚考了66.5分
     */
}

/* 4.添加新的属性*/
- (IBAction)Func4:(id)sender {
    
    /*
     如何在不改动某个类的前提下，添加一个新的属性呢？
     
     答：可以利用runtime为分类添加新属性。
     */
    //给新属性height赋值
    _person.height= 168; //给新属性height赋值
    //访问新属性值
    NSLog(@"%f",[_person height]);

}


/*5.添加新的方法试试(这种方法等价于对Father类添加Category对方法进行扩展)：*/
- (IBAction)Func5:(id)sender {
    
    class_addMethod([_person class], @selector(NewMethod),(IMP)myAddingFunction, 0);
    
    
    [_person performSelector:@selector(NewMethod)];
    
    /*
     控制台输出：
     2019-04-03 16:42:14.522734+0800 RuntimeDemo[21232:211364] 已新增方法:NewMethod
     */
}

//具体的实现（方法的内部都默认包含两个参数Class类和SEL方法，被称为隐式参数。）
int myAddingFunction(id self, SEL _cmd)
{
    NSLog(@"已新增方法:NewMethod");
    return 1;
}





/* 6.交换两种方法之后（功能对调*/
- (IBAction)Func6:(id)sender {
    
    Method method1 = class_getInstanceMethod([JGPerson class], @selector(func1));
    Method method2 = class_getInstanceMethod([JGPerson class], @selector(func2));
    
    method_exchangeImplementations(method1, method2);
    
    [_person func1];
    
    /*
     控制台输出：
     2019-04-03 16:48:14.902453+0800 RuntimeDemo[21328:214212] 执行func2方法。
     */
}



@end
