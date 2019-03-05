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
