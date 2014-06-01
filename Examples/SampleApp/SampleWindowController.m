//
//  SampleWindowController.m
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011-2014 Indragie Karunaratne. All rights reserved.
//
//  Licensed under the BSD 2-clause License. See LICENSE file distributed in the source
//  code of this project.
//

#import "SampleWindowController.h"
#import "INAppStoreWindow.h"

@implementation SampleWindowController

- (void)windowDidLoad
{
	[super windowDidLoad];
	// The class of the window has been set in INAppStoreWindow in Interface Builder
	INAppStoreWindow *aWindow = (INAppStoreWindow *) [self window];
	aWindow.titleBarHeight = 40.0;
	aWindow.trafficLightButtonsLeftMargin = 13.0;
	aWindow.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect drawingRect, CGRectEdge edge, CGPathRef clippingPath) {
		CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
		if (clippingPath) {
			CGContextAddPath(ctx, clippingPath);
			CGContextClip(ctx);
		}

		NSGradient *gradient = nil;
		if (drawsAsMainWindow) {
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0 green:0.319 blue:1 alpha:1]
													 endingColor:[NSColor colorWithCalibratedRed:0 green:0.627 blue:1 alpha:1]];
			[[NSColor darkGrayColor] setFill];
		} else {
			// set the default non-main window gradient colors
			gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.851f alpha:1]
													 endingColor:[NSColor colorWithCalibratedWhite:0.929f alpha:1]];
			[[NSColor colorWithCalibratedWhite:0.6f alpha:1] setFill];
		}
		[gradient drawInRect:drawingRect angle:90];
#if !__has_feature(objc_arc)
        [gradient release];
#endif
		NSRectFill(NSMakeRect(NSMinX(drawingRect), NSMinY(drawingRect), NSWidth(drawingRect), 1));
	};

	aWindow.bottomBarDrawingBlock = aWindow.titleBarDrawingBlock;
	aWindow.bottomBarHeight = aWindow.titleBarHeight;

	NSView *titleBarView = aWindow.titleBarView;
	NSSize segmentSize = NSMakeSize(104, 25);
	NSRect segmentFrame = NSMakeRect(NSMidX(titleBarView.bounds) - (segmentSize.width / 2.f),
			NSMidY(titleBarView.bounds) - (segmentSize.height / 2.f),
			segmentSize.width, segmentSize.height);
	NSSegmentedControl *segment = [[NSSegmentedControl alloc] initWithFrame:segmentFrame];
	[segment setSegmentCount:3];
	[segment setImage:[NSImage imageNamed:NSImageNameIconViewTemplate] forSegment:0];
	[segment setImage:[NSImage imageNamed:NSImageNameListViewTemplate] forSegment:1];
	[segment setImage:[NSImage imageNamed:NSImageNameFlowViewTemplate] forSegment:2];
	[segment setSelectedSegment:0];
	[segment setSegmentStyle:NSSegmentStyleTexturedRounded];
	[titleBarView addSubview:segment];
#if !__has_feature(objc_arc)
    [segment release];
#endif
}

@end
