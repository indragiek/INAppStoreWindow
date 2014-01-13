//
//  INAppStoreWindowSwizzling.c
//
//  Created by Jake Petroules on 1/13/2014.
//  Copyright (c) 2011-2014 Indragie Karunaratne. All rights reserved.
//

#import "INAppStoreWindowSwizzling.h"

void INAppStoreWindowSwizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}
