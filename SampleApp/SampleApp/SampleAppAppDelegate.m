//
//  SampleAppAppDelegate.m
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011 PCWiz Computer. All rights reserved.
//

#import "SampleAppAppDelegate.h"
#import "SampleWindowController.h"
#import "INAppStoreWindow.h"

@implementation SampleAppAppDelegate

@synthesize window, windowControllers;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.windowControllers = [NSMutableArray array];
    // The class of the window has been set in INAppStoreWindow in Interface Builder
    INAppStoreWindow *aWindow = (INAppStoreWindow*)self.window;
    aWindow.centerFullScreenButton = YES;
    aWindow.titleBarHeight = 40.0;
}

- (IBAction)createWindowController:(id)sender
{
    SampleWindowController *controller = [[SampleWindowController alloc] initWithWindowNibName:@"SampleWindow"];
    [controller showWindow:nil];
    [self.windowControllers addObject:controller];
    [controller release];
}

- (void)dealloc
{
    [windowControllers release];
    [super dealloc];
}
@end
