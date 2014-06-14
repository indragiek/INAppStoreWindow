//
//	INWindowBackgroundView+CoreUIRendering.m
//
//  Copyright (c) 2014 Petroules Corporation. All rights reserved.
//
//  Licensed under the BSD 2-clause License. See LICENSE file distributed in the source
//  code of this project.
//

#import "INAppStoreWindow.h"
#import "INAppStoreWindowCompatibility.h"
#import "INAppStoreWindowSwizzling.h"
#import "INWindowBackgroundView+CoreUIRendering.h"

#if !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

typedef CFTypeRef CUIRendererRef;
typedef void (*_CUIDraw)(CUIRendererRef renderer, CGRect frame, CGContextRef context, CFDictionaryRef options, CFDictionaryRef *result);
static _CUIDraw CUIDraw = 0;

static const NSString *kCUIWidgetWindowFrame = @"kCUIWidgetWindowFrame";
static const NSString *kCUIWindowFrameBottomBarHeightKey = @"kCUIWindowFrameBottomBarHeightKey";
static const NSString *kCUIWindowFrameDrawBottomBarSeparatorKey = @"kCUIWindowFrameDrawBottomBarSeparatorKey";
static const NSString *kCUIWindowFrameDrawTitleSeparatorKey = @"kCUIWindowFrameDrawTitleSeparatorKey";
static const NSString *kCUIWindowFrameRoundedBottomCornersKey = @"kCUIWindowFrameRoundedBottomCornersKey";
static const NSString *kCUIWindowFrameRoundedTopCornersKey = @"kCUIWindowFrameRoundedTopCornersKey";
static const NSString *kCUIWindowFrameUnifiedTitleBarHeightKey = @"kCUIWindowFrameUnifiedTitleBarHeightKey";

@interface NSWindow (NSWindowPrivate)

+ (CUIRendererRef)coreUIRenderer;

@end

@interface INWindowBackgroundView ()

- (void)drawWindowBackgroundLayersInRect:(NSRect)drawingRect forEdge:(NSRectEdge)drawingEdge showsSeparator:(BOOL)showsSeparator clippingPath:(CGPathRef)clippingPath;

@end

#endif // !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

@implementation INWindowBackgroundView (CoreUIRendering)

#if !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

+ (void)load
{
	NSBundle *coreUIBundle = [NSBundle bundleWithIdentifier:@"com.apple.coreui"];
	CFBundleRef bundle = CFBundleCreate(kCFAllocatorDefault, (__bridge CFURLRef)coreUIBundle.bundleURL);
	if ((CUIDraw = CFBundleGetFunctionPointerForName(bundle, (__bridge CFStringRef)@"CUIDraw")) &&
		[NSWindow respondsToSelector:@selector(coreUIRenderer)]) {
		INAppStoreWindowSwizzle(self,
								@selector(drawWindowBackgroundLayersInRect:forEdge:showsSeparator:clippingPath:),
								@selector(drawCUIWindowBackgroundLayersInRect:forEdge:showsSeparator:clippingPath:));
	} else {
		NSLog(@"Failed to load CoreUI, falling back to custom drawing");
	}
	CFRelease(bundle);
}

- (void)drawCUIWindowBackgroundLayersInRect:(CGRect)drawingRect forEdge:(CGRectEdge)edge showsSeparator:(BOOL)showsSeparator clippingPath:(CGPathRef)clippingPath
{
	INAppStoreWindow *window = (INAppStoreWindow *)self.window;
	NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:
									@{@"state": (window.isMainWindow ? @"normal" : @"inactive"),
									  @"widget": kCUIWidgetWindowFrame,
									  @"windowtype": @"regularwin",
									  @"is.flipped": @(self.isFlipped)}];
	if (edge == CGRectMaxYEdge) {
		options[kCUIWindowFrameUnifiedTitleBarHeightKey] = @(window.titleBarHeight + window.toolbarHeight);
		options[kCUIWindowFrameDrawTitleSeparatorKey] = @(showsSeparator);
		options[kCUIWindowFrameRoundedBottomCornersKey] = @(NO);
		options[kCUIWindowFrameRoundedTopCornersKey] = @(YES);
	} else if (edge == CGRectMinYEdge) {
		// NOTE: While kCUIWidgetWindowBottomBar can be used to draw a bottom bar, this only allows
		// it to be drawn with the separator shown as kCUIWindowFrameDrawBottomBarSeparatorKey only
		// applies to the kCUIWidgetWindowFrame widget. So we use that instead; it produces
		// identical results.
		options[kCUIWindowFrameBottomBarHeightKey] = @(window.bottomBarHeight);
		options[kCUIWindowFrameDrawBottomBarSeparatorKey] = @(showsSeparator);
		options[kCUIWindowFrameRoundedBottomCornersKey] = @(YES);
		options[kCUIWindowFrameRoundedTopCornersKey] = @(NO);
	}
	CUIDraw([NSWindow coreUIRenderer], drawingRect, [[NSGraphicsContext currentContext] graphicsPort], (__bridge CFDictionaryRef) options, nil);
}

#endif // !defined(INAPPSTOREWINDOW_NO_COREUI) || !INAPPSTOREWINDOW_NO_COREUI

@end
