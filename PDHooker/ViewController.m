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
        NSLog(@"----- object = %@, pd_say", self);
    });
}

- (void)pd_say:(NSString *)str {
    object_registeredObjcActionInvoke(self, @selector(pd_say:), ^{
        [self pd_say:str];
    }, ^{
        NSLog(@"object = %@, pd_say %@", self, str);
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
    
    NSLog(@"male = %@", male);
    NSLog(@"female = %@", female);
    NSLog(@"shemale = %@", shemale);

    object_exchangeInstanceMethod(male, @selector(say), @selector(pd_say));
    object_exchangeInstanceMethod(female, @selector(say:), @selector(pd_say:));
    
    [male say];
    [female say];
    [shemale say];
    
    [male say:@"I'm male"];
    [female say:@"I'm female"];
    [shemale say:@"I'm shemale"];
    
    
    NSLog(@"===============================================");
    NSLog(@"===============================================");
    
    object_exchangeInstanceMethod(male, @selector(say), @selector(pd_say));
    object_exchangeInstanceMethod(female, @selector(say:), @selector(pd_say:));
    
    [male say];
    [female say];
    [shemale say];
    
    [male say:@"I'm male"];
    [female say:@"I'm female"];
    [shemale say:@"I'm shemale"];
}


@end
