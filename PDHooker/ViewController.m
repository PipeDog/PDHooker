//
//  ViewController.m
//  PDHooker
//
//  Created by liang on 2019/3/5.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "PDHooker.h"

@interface Person (Hook)

@end

@implementation Person (Hook)

- (void)pd_say {
    object_registeredObjcActionInvoke(self, @selector(pd_say), ^{
        [self pd_say];
    }, ^{
        NSLog(@"Person say something in new method...");
    });
}

- (void)pd_eat:(NSString *)food {
    object_registeredObjcActionInvoke(self, @selector(pd_eat:), ^{
        [self pd_eat:food];
    }, ^{
        NSLog(@"Person eat %@ in new method.", food);
    });
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *male = [[Person alloc] init];
    Person *female = [[Person alloc] init];
    Person *shemale = [[Person alloc] init];
    
    object_exchangeInstanceMethod(male, @selector(say), @selector(pd_say));
    object_exchangeInstanceMethod(female, @selector(eat:), @selector(pd_eat:));
    
    [male say]; // Person say something in new method...
    [female say]; // Person say something...
    [shemale say]; // Person say something...
    
    [male eat:@"bread"]; // Person eat bread.
    [female eat:@"bread"]; // Person eat bread in new method.
    [shemale eat:@"bread"]; // Person eat bread.
}


@end
