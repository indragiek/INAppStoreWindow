//
//  INAppStoreWindow.m
//
//  Copyright 2011 Indragie Karunaratne. All rights reserved.
//
//  Licensed under the BSD License <http://www.opensource.org/licenses/bsd-license>
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
//  SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
//  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
//  THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "INAppStoreWindow.h"

#define IN_RUNNING_LION (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_6)

/** -----------------------------------------
 - There are 2 sets of colors, one for an active (key) state and one for an inactivate state
 - Each set contains 3 colors. 2 colors for the start and end of the title gradient, and another color to draw the separator line on the bottom
 - These colors are meant to mimic the color of the default titlebar (taken from OS X 10.6), but are subject
 to change at any time
 ----------------------------------------- **/

#define COLOR_MAIN_START [NSColor colorWithDeviceWhite:0.659 alpha:1.0]
#define COLOR_MAIN_END [NSColor colorWithDeviceWhite:0.812 alpha:1.0]
#define COLOR_MAIN_BOTTOM [NSColor colorWithDeviceWhite:0.318 alpha:1.0]

#define COLOR_NOTMAIN_START [NSColor colorWithDeviceWhite:0.851 alpha:1.0]
#define COLOR_NOTMAIN_END [NSColor colorWithDeviceWhite:0.929 alpha:1.0]
#define COLOR_NOTMAIN_BOTTOM [NSColor colorWithDeviceWhite:0.600 alpha:1.0]

/** Lion */

#define COLOR_MAIN_START_L [NSColor colorWithDeviceWhite:0.66 alpha:1.0]
#define COLOR_MAIN_END_L [NSColor colorWithDeviceWhite:0.9 alpha:1.0]
#define COLOR_MAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.408 alpha:1.0]

#define COLOR_NOTMAIN_START_L [NSColor colorWithDeviceWhite:0.878 alpha:1.0]
#define COLOR_NOTMAIN_END_L [NSColor colorWithDeviceWhite:0.976 alpha:1.0]
#define COLOR_NOTMAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.655 alpha:1.0]

/** Corner clipping radius **/
#define CORNER_CLIP_RADIUS 4.0

@interface INAppStoreWindow ()
@property (INAppStoreWindowCopy) NSString *windowMenuTitle;
- (void)_doInitialWindowSetup;
- (void)_createTitlebarView;
- (void)_setupTrafficLightsTrackingArea;
- (void)_recalculateFrameForTitleBarView;
- (void)_layoutTrafficLightsAndContent;
- (float)_minimumTitlebarHeight;
- (void)_displayWindowAndTitlebar;
@end

@implementation INTitlebarView

- (void)drawRect:(NSRect)dirtyRect
{
    BOOL drawsAsMainWindow = ([[self window] isMainWindow] && [[NSApplication sharedApplication] isActive]);
    NSRect drawingRect = [self bounds];
    drawingRect.size.height -= 1.0; // Decrease the height by 1.0px to show the highlight line at the top
    NSColor *startColor = nil;
    NSColor *endColor = nil;
    if (IN_RUNNING_LION) {
        startColor = drawsAsMainWindow ? COLOR_MAIN_START_L : COLOR_NOTMAIN_START_L;
        endColor = drawsAsMainWindow ? COLOR_MAIN_END_L : COLOR_NOTMAIN_END_L;
    } else {
        startColor = drawsAsMainWindow ? COLOR_MAIN_START : COLOR_NOTMAIN_START;
        endColor = drawsAsMainWindow ? COLOR_MAIN_END : COLOR_NOTMAIN_END;
    }
    [NSGraphicsContext saveGraphicsState];
    [[self clippingPathWithRect:drawingRect cornerRadius:CORNER_CLIP_RADIUS] addClip];
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    [gradient drawInRect:drawingRect angle:90];
    #if !__has_feature(objc_arc)
    [gradient release];
    #endif
    if (IN_RUNNING_LION && drawsAsMainWindow) {
        static CIImage *noisePattern = nil;
        if (!noisePattern) {
            CIFilter *randomGenerator = [CIFilter filterWithName:@"CIColorMonochrome"];
            [randomGenerator setValue:[[CIFilter filterWithName:@"CIRandomGenerator"] valueForKey:@"outputImage"]
                               forKey:@"inputImage"];
            [randomGenerator setDefaults];
            #if __has_feature(objc_arc)
            noisePattern = [randomGenerator valueForKey:@"outputImage"];
            #else
            noisePattern = [[randomGenerator valueForKey:@"outputImage"] retain];
            #endif
        }
        [noisePattern drawAtPoint:NSZeroPoint fromRect:self.bounds operation:NSCompositePlusLighter fraction:0.04];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    NSColor *bottomColor = nil;
    if (IN_RUNNING_LION) {
        bottomColor = drawsAsMainWindow ? COLOR_MAIN_BOTTOM_L : COLOR_NOTMAIN_BOTTOM_L;
    } else {
        bottomColor = drawsAsMainWindow ? COLOR_MAIN_BOTTOM : COLOR_NOTMAIN_BOTTOM;
    }
    NSRect bottomRect = NSMakeRect(0.0, NSMinY(drawingRect), NSWidth(drawingRect), 1.0);
    [bottomColor set];
    NSRectFill(bottomRect);
    
    if (IN_RUNNING_LION) {
        bottomRect.origin.y += 1.0;
        [[NSColor colorWithDeviceWhite:1.0 alpha:0.12] setFill];
        [[NSBezierPath bezierPathWithRect:bottomRect] fill];
    }
}

// Uses code from NSBezierPath+PXRoundedRectangleAdditions by Andy Matuschak
// <http://code.andymatuschak.org/pixen/trunk/NSBezierPath+PXRoundedRectangleAdditions.m>

- (NSBezierPath*)clippingPathWithRect:(NSRect)aRect cornerRadius:(CGFloat)radius
{
    NSBezierPath *path = [NSBezierPath bezierPath];
	NSRect rect = NSInsetRect(aRect, radius, radius);
    NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
    // Create a rounded rectangle path, omitting the bottom left/right corners
    [path appendBezierPathWithPoints:&cornerPoint count:1];
    cornerPoint = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
    [path appendBezierPathWithPoints:&cornerPoint count:1];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
    [path closePath];
    return path;
}

- (void)mouseUp:(NSEvent *)theEvent {
    if ([theEvent clickCount] == 2) {
        // Get settings from "System Preferences" >  "Appearance" > "Double-click on windows title bar to minimize"
        NSString *const MDAppleMiniaturizeOnDoubleClickKey = @"AppleMiniaturizeOnDoubleClick";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults addSuiteNamed:NSGlobalDomain];
        BOOL shouldMiniaturize = [[userDefaults objectForKey:MDAppleMiniaturizeOnDoubleClickKey] boolValue];
        if (shouldMiniaturize) {
            [[self window] miniaturize:self];
        }
    }
}

@end

@implementation INAppStoreWindow

@synthesize windowMenuTitle = _windowMenuTitle;

#pragma mark -
#pragma mark Initialization

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
        [self _doInitialWindowSetup];
    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
    if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen])) {
        [self _doInitialWindowSetup];
    }
    return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    #if !__has_feature(objc_arc)
    [_titleBarView release];
	[_windowMenuTitle release];
    [super dealloc];    
    #endif
}

#pragma mark -
#pragma mark NSWindow Overrides

// Disable window titles

- (NSString*)title
{
    return @"";
}

- (void)setTitle:(NSString*)title
{
	self.windowMenuTitle = title;
	if ( ![self isExcludedFromWindowsMenu] )
		[NSApp changeWindowsItem:self title:self.windowMenuTitle filename:NO];
}

- (void)setRepresentedURL:(NSURL *)url
{
	// do nothing, don't want to show document icon in menu bar
}

- (void)makeKeyAndOrderFront:(id)sender
{
	[super makeKeyAndOrderFront:sender];
	if (![self isExcludedFromWindowsMenu]) {
		[NSApp addWindowsItem:self title:self.windowMenuTitle filename:NO];	
    }
}

- (void)becomeKeyWindow
{
    [super becomeKeyWindow];
    [_titleBarView setNeedsDisplay:YES];
}

- (void)resignKeyWindow
{
    [super resignKeyWindow];
    [_titleBarView setNeedsDisplay:YES];
}

- (void)orderFront:(id)sender
{
	[super orderFront:sender];
	if (![self isExcludedFromWindowsMenu]) {
		[NSApp addWindowsItem:self title:self.windowMenuTitle filename:NO];
    }
}

- (void)orderOut:(id)sender
{
	[super orderOut:sender];
	[NSApp removeWindowsItem:self];
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleBarView:(NSView *)newTitleBarView
{
    if ((_titleBarView != newTitleBarView) && newTitleBarView) {
        [_titleBarView removeFromSuperview];
        #if __has_feature(objc_arc)
        _titleBarView = newTitleBarView;
        #else
        [_titleBarView release];
        _titleBarView = [newTitleBarView retain];
        #endif
        // Configure the view properties and add it as a subview of the theme frame
        NSView *contentView = [self contentView];
        NSView *themeFrame = [contentView superview];
        NSView *firstSubview = [[themeFrame subviews] objectAtIndex:0];
        [_titleBarView setAutoresizingMask:(NSViewMinYMargin | NSViewWidthSizable)];
        [self _recalculateFrameForTitleBarView];
        [themeFrame addSubview:_titleBarView positioned:NSWindowBelow relativeTo:firstSubview];
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
    }
}

- (NSView*)titleBarView
{
    return _titleBarView;
}

- (void)setTitleBarHeight:(CGFloat)newTitleBarHeight
{
    float minTitleHeight = [self _minimumTitlebarHeight];
    if (newTitleBarHeight < minTitleHeight) {
        newTitleBarHeight = minTitleHeight;
    }
	if (_titleBarHeight != newTitleBarHeight) {
		_titleBarHeight = newTitleBarHeight;
		[self _recalculateFrameForTitleBarView];
		[self _layoutTrafficLightsAndContent];
		[self _displayWindowAndTitlebar];
	}
}

- (CGFloat)titleBarHeight
{
    return _titleBarHeight;
}

#pragma mark -
#pragma mark Private

- (void)_doInitialWindowSetup
{
    // Calculate titlebar height
    _titleBarHeight = [self _minimumTitlebarHeight];
    [self setMovableByWindowBackground:YES];
    /** -----------------------------------------
     - The window automatically does layout every time its moved or resized, which means that the traffic lights and content view get reset at the original positions, so we need to put them back in place
     - NSWindow is hardcoded to redraw the traffic lights in a specific rect, so when they are moved down, only part of the buttons get redrawn, causing graphical artifacts. Therefore, the window must be force redrawn every time it becomes key/resigns key
     ----------------------------------------- **/
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidResizeNotification object:self];
    [nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidMoveNotification object:self];
    [nc addObserver:self selector:@selector(_displayWindowAndTitlebar) name:NSWindowDidResignKeyNotification object:self];
    [nc addObserver:self selector:@selector(_displayWindowAndTitlebar) name:NSWindowDidBecomeKeyNotification object:self];
    [nc addObserver:self selector:@selector(_setupTrafficLightsTrackingArea) name:NSWindowDidBecomeKeyNotification object:self];
    [nc addObserver:self selector:@selector(_displayWindowAndTitlebar) name:NSApplicationDidBecomeActiveNotification object:nil];
    [nc addObserver:self selector:@selector(_displayWindowAndTitlebar) name:NSApplicationDidResignActiveNotification object:nil];
    #if __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070
    if (IN_RUNNING_LION) {
        [nc addObserver:self selector:@selector(_setupTrafficLightsTrackingArea) name:NSWindowDidExitFullScreenNotification object:nil];
    }
    #endif
    [self _createTitlebarView];
    [self _layoutTrafficLightsAndContent];
    [self _setupTrafficLightsTrackingArea];
}

- (void)_layoutTrafficLightsAndContent
{
    NSView *contentView = [self contentView];
    NSButton *close = [self standardWindowButton:NSWindowCloseButton];
    NSButton *minimize = [self standardWindowButton:NSWindowMiniaturizeButton];
    NSButton *zoom = [self standardWindowButton:NSWindowZoomButton];
    
    // Set the frame of the window buttons
    NSRect closeFrame = [close frame];
    NSRect minimizeFrame = [minimize frame];
    NSRect zoomFrame = [zoom frame];
    float buttonOrigin = floor(NSMidY([_titleBarView frame]) - (closeFrame.size.height / 2.0));
    closeFrame.origin.y = buttonOrigin;
    minimizeFrame.origin.y = buttonOrigin;
    zoomFrame.origin.y = buttonOrigin;
    [close setFrame:closeFrame];
    [minimize setFrame:minimizeFrame];
    [zoom setFrame:zoomFrame];
    
    // Reposition the content view
    NSRect windowFrame = [self frame];
    NSRect newFrame = [contentView frame];
    float titleHeight = windowFrame.size.height - newFrame.size.height;
    float extraHeight = _titleBarHeight - titleHeight;
    newFrame.size.height -= extraHeight;
    [contentView setFrame:newFrame];
}

- (void)_createTitlebarView
{
    // Create the title bar view
    #if __has_feature(objc_arc)
    self.titleBarView = [[INTitlebarView alloc] initWithFrame:NSZeroRect];
    #else
    self.titleBarView = [[[INTitlebarView alloc] initWithFrame:NSZeroRect] autorelease];
    #endif
}

// Solution for tracking area issue thanks to @Perspx (Alex Rozanski) <https://gist.github.com/972958>
- (void)_setupTrafficLightsTrackingArea
{
    [[[self contentView] superview] viewWillStartLiveResize];
    [[[self contentView] superview] viewDidEndLiveResize];
}

- (void)_recalculateFrameForTitleBarView
{
    NSView *contentView = [self contentView];
    NSView *themeFrame = [contentView superview];
    NSRect themeFrameRect = [themeFrame frame];
    NSRect titleFrame = NSMakeRect(0.0, NSMaxY(themeFrameRect) - _titleBarHeight, themeFrameRect.size.width, _titleBarHeight);
    [_titleBarView setFrame:titleFrame];
}

- (float)_minimumTitlebarHeight
{
    static float minTitleHeight = 0.0;
    if (!minTitleHeight) {
        NSRect frameRect = [self frame];
        NSRect contentRect = [self contentRectForFrameRect:frameRect];
        minTitleHeight = (frameRect.size.height - contentRect.size.height);
    }
    return minTitleHeight;
}

- (void)_displayWindowAndTitlebar
{
    // Redraw the window and titlebar
    [_titleBarView setNeedsDisplay:YES];
}
@end
