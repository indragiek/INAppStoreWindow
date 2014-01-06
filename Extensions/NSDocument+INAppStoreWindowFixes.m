//
//  NSDocument+INAppStoreWindowFixes.m
//  SampleApp
//
//  Created by Indragie Karunaratne on 1/5/2014.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

#import "NSDocument+INAppStoreWindowFixes.h"
#import "INAppStoreWindow.h"
#import <objc/runtime.h>

@interface INAppStoreWindow (Private)
- (void)_layoutTrafficLightsAndContent;
@end

static void INAppStoreWindowSwizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation NSDocument (INAppStoreWindowFixes)

+ (void)load
{
    INAppStoreWindowSwizzle(self, @selector(updateChangeCount:), @selector(ind_updateChangeCount:));
}

- (void)ind_updateChangeCount:(NSDocumentChangeType)changeType
{
    [self ind_updateChangeCount:changeType]; // Original implementation
    NSArray *windowControllers = self.windowControllers;
    for (NSWindowController *wc in windowControllers) {
        if ([wc.window isKindOfClass:INAppStoreWindow.class]) {
            [(INAppStoreWindow *)wc.window _layoutTrafficLightsAndContent];
        }
    }
}

@end
