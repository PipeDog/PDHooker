//
//  PDHKTool.h
//  PDHooker
//
//  Created by liang on 2021/1/19.
//  Copyright © 2021 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void
class_exchangeInstanceMethod(Class cls, SEL originalSEL, SEL replaceSEL);

FOUNDATION_EXPORT void
class_exchangeClassMethod(Class cls, SEL originalSEL, SEL replaceSEL);

NS_ASSUME_NONNULL_END
