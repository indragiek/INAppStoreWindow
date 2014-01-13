//
//	INTitlebarView+CoreUIRendering.m
//
//  Created by Jake Petroules on 1/13/2014.
//  Copyright (c) 2011-2014 Indragie Karunaratne. All rights reserved.
//

#import "INAppStoreWindow.h"
#import "INAppStoreWindowSwizzling.h"
#import "INTitlebarView+CoreUIRendering.h"

#if !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

typedef CFTypeRef CUIRendererRef;
typedef void (*_CUIDraw)(CUIRendererRef renderer, CGRect frame, CGContextRef context, CFDictionaryRef options, CFDictionaryRef *result);
static _CUIDraw CUIDraw = 0;

@interface NSWindow (NSWindowPrivate)

+ (CUIRendererRef)coreUIRenderer;

@end

#endif // !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

@implementation INTitlebarView (CoreUIRendering)

#if !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

+ (void)load
{
    NSBundle *coreUIBundle = [NSBundle bundleWithIdentifier:@"com.apple.coreui"];
    CFBundleRef bundle = CFBundleCreate(kCFAllocatorDefault, (INAppStoreWindowBridge CFURLRef)coreUIBundle.bundleURL);
    if ((CUIDraw = CFBundleGetFunctionPointerForName(bundle, (INAppStoreWindowBridge CFStringRef)@"CUIDraw")) &&
        [NSWindow respondsToSelector:@selector(coreUIRenderer)]) {
        INAppStoreWindowSwizzle(self, @selector(drawWindowBackgroundGradient:showsBaselineSeparator:clippingPath:), @selector(drawCoreUIWindowBackgroundGradient:showsBaselineSeparator:clippingPath:));
    } else {
        NSLog(@"Failed to load CoreUI, falling back to custom drawing");
    }
    CFRelease(bundle);
}

- (void)drawCoreUIWindowBackgroundGradient:(NSRect)drawingRect showsBaselineSeparator:(BOOL)showsBaselineSeparator clippingPath:(CGPathRef)clippingPath
{
    INAppStoreWindow *window = (INAppStoreWindow *)self.window;
    NSDictionary *options = @{@"widget": @"kCUIWidgetWindowFrame",
                              @"state": (window.isMainWindow ? @"normal" : @"inactive"),
                              @"windowtype": @"regularwin",
                              @"kCUIWindowFrameUnifiedTitleBarHeightKey": @(window.titleBarHeight),
                              @"kCUIWindowFrameDrawTitleSeparatorKey": @(window.showsBaselineSeparator),
                              @"is.flipped": @(self.isFlipped)};
    CUIDraw([NSWindow coreUIRenderer], drawingRect, [[NSGraphicsContext currentContext] graphicsPort], (INAppStoreWindowBridge CFDictionaryRef) options, nil);
}

#endif // !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

@end
