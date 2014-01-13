//
//  INAppStoreWindowSwizzling.h
//
//  Created by Jake Petroules on 1/13/2014.
//  Copyright (c) 2011-2014 Indragie Karunaratne. All rights reserved.
//

#import <objc/runtime.h>

void INAppStoreWindowSwizzle(Class c, SEL orig, SEL new);
