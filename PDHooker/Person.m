//
//  Person.m
//  PDHooker
//
//  Created by liang on 2019/3/5.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

- (void)say {
    NSLog(@"Person say something...");
}

- (void)eat:(NSString *)food {
    NSLog(@"Person eat %@.", food);
}

@end
