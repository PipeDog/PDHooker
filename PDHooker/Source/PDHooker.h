//
//  PDHooker.h
//  PDHooker
//
//  Created by liang on 2019/3/5.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT void
class_exchangeInstanceMethod(Class cls, SEL originalSEL, SEL replaceSEL);

FOUNDATION_EXPORT void
class_exchangeClassMethod(Class cls, SEL originalSEL, SEL replaceSEL);


/*
 
 @implementation Person
 
 - (void)say {
    NSLog(@"Person say something...");
 }
 
 - (void)eat:(NSString *)food {
    NSLog(@"Person eat %@.", food);
 }
 
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
 
 @implementation ViewController
 
 - (void)hookMethods {
    Person *male = [[Person alloc] init];
    Person *female = [[Person alloc] init];

    object_exchangeInstanceMethod(male, @selector(say), @selector(pd_say));
    object_exchangeInstanceMethod(female, @selector(say:), @selector(pd_say:));

    [male say]; // Person say something in new method...
    [female eat:@"bread"] // Person eat bread in new method.
 }
 
 @end
 */

// Exchange method, only param `objc` is affected, does not affect other objects.
FOUNDATION_EXPORT void
object_exchangeInstanceMethod(id objc, SEL originalSEL, SEL replaceSEL);

/*
 * @param sel  Replace method seletor.
 * @param originalSELBlock  Invoke replace method here.
 * @param replaceSELBlock   Perform total action here.
 */
FOUNDATION_EXPORT void
object_registeredObjcActionInvoke(id objc, SEL sel, dispatch_block_t originalSELBlock, dispatch_block_t replaceSELBlock);
