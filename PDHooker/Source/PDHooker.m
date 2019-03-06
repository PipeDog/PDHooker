//
//  PDHooker.m
//  PDHooker
//
//  Created by liang on 2019/3/5.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import "PDHooker.h"
#import <objc/runtime.h>

void class_exchangeInstanceMethod(Class cls, SEL originalSEL, SEL replaceSEL) {
    Method originMethod = class_getInstanceMethod(cls, originalSEL);
    Method replaceMethod = class_getInstanceMethod(cls, replaceSEL);
    
    BOOL success = class_addMethod(cls,
                                   originalSEL,
                                   method_getImplementation(replaceMethod),
                                   method_getTypeEncoding(replaceMethod));
    if (success) {
        class_replaceMethod(cls,
                            replaceSEL,
                            method_getImplementation(originMethod),
                            method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}

void class_exchangeClassMethod(Class cls, SEL originalSEL, SEL replaceSEL) {
    Class metaClass = object_getClass(cls);
    class_exchangeInstanceMethod(metaClass, originalSEL, replaceSEL);
}

/*
 map:
 {
    Class1: {
        object0: [method0, method1, ...],
        object1: [method0, method1, ...],
        ...
    },
    Class2: {
        object0: [method0, method1, ...],
        object1: [method0, method1, ...],
    .   ..
    },
    ...
 }
 */
static NSMapTable<Class, NSMapTable<id<NSObject>, NSHashTable<NSString *> *> *> *__registeredMap(void) {
    static NSMapTable *__registeredMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __registeredMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                                                valueOptions:NSPointerFunctionsStrongMemory];
    });
    return __registeredMap;
}

static BOOL _object_objcHasRegistered(id objc, SEL sel) {
    // Get registered objectMap for [objc class].
    NSMapTable<id<NSObject>, NSHashTable<NSString *> *> *objectMap = [__registeredMap() objectForKey:[objc class]];
    // Get methodList for objc.
    NSHashTable<NSString *> *methodList = [objectMap objectForKey:objc];
    
    return [methodList containsObject:NSStringFromSelector(sel)];
}

void object_exchangeInstanceMethod(id objc, SEL originalSEL, SEL replaceSEL) {
    if (class_isMetaClass(object_getClass(objc))) {
        NSCAssert(NO, @"Do not support class objects.");
        return;
    }
    
    NSMapTable<id<NSObject>, NSHashTable<NSString *> *> *objectMap = [__registeredMap() objectForKey:[objc class]];
    if (!objectMap) {
        objectMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
                                          valueOptions:NSPointerFunctionsStrongMemory];
    }
    
    NSHashTable<NSString *> *methodList = [objectMap objectForKey:objc];
    if (!methodList) {
        methodList = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    }
    
    NSArray *objects = NSAllMapTableKeys(objectMap);
    NSString *methodName = NSStringFromSelector(replaceSEL); // Store replaceSEL method name into method list.
    
    if ([objects containsObject:objects] &&
        [methodList containsObject:methodName]) {
        return;
    }
    
    class_exchangeInstanceMethod([objc class], originalSEL, replaceSEL);
    
    [methodList addObject:methodName];
    [objectMap setObject:methodList forKey:objc];
    [__registeredMap() setObject:objectMap forKey:[objc class]];
}

void object_registeredObjcActionInvoke(id objc, SEL sel, dispatch_block_t originalSELBlock, dispatch_block_t replaceSELBlock) {
    BOOL hasRegistered = _object_objcHasRegistered(objc, sel);
    
    if (hasRegistered) {
        !replaceSELBlock ?: replaceSELBlock();
    } else {
        !originalSELBlock ?: originalSELBlock();
    }
}
