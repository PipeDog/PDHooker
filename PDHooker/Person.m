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
    NSLog(@"---- object = %@, say", self);
}

- (void)say:(NSString *)str {
    NSLog(@"object = %@, say %@", self, str);
}

@end
