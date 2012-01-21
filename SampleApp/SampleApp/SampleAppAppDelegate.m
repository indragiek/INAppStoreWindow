//
//  SampleAppAppDelegate.m
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011 PCWiz Computer. All rights reserved.
//

#import "SampleAppAppDelegate.h"
#import "SampleWindowController.h"

@implementation SampleAppAppDelegate

@synthesize window = _window;
@synthesize windowControllers = _windowControllers;
@synthesize centerFullScreen = _centerFullScreen;
@synthesize centerTrafficLight = _centerTrafficLight;
@synthesize fullScreenRightMarginSlider = _fullScreenRightMarginSlider;
@synthesize trafficLightLeftMargin = _trafficLightLeftMargin;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.windowControllers = [NSMutableArray array];
    // The class of the window has been set in INAppStoreWindow in Interface Builder
    self.window.trafficLightButtonsLeftMargin = 7.0;
    self.window.fullScreenButtonRightMargin = 7.0; 
    self.window.hideTitleBarInFullScreen = YES;    
    self.window.centerFullScreenButton = YES;    
    self.window.titleBarHeight = 40.0;
    
    // set checkboxes
    self.centerFullScreen.state = self.window.centerFullScreenButton;
    self.centerTrafficLight.state = self.window.centerTrafficLightButtons;
    self.fullScreenRightMarginSlider.doubleValue = self.window.fullScreenButtonRightMargin;
    self.trafficLightLeftMargin.doubleValue = self.window.trafficLightButtonsLeftMargin;
}

- (IBAction)createWindowController:(id)sender
{
    SampleWindowController *controller = [[SampleWindowController alloc] initWithWindowNibName:@"SampleWindow"];
    [controller showWindow:nil];
    [self.windowControllers addObject:controller];
    [controller release];
}

- (IBAction)checkboxAction:(id)sender
{
    if ( [sender isEqual:self.centerFullScreen] ) {
        self.window.centerFullScreenButton = [sender state];
    } else {
        self.window.centerTrafficLightButtons = [sender state];
    }
}

- (IBAction)sliderAction:(id)sender 
{
    if ( [sender isEqual:self.fullScreenRightMarginSlider] ) {
        self.window.fullScreenButtonRightMargin = [sender doubleValue];
    } else {
        self.window.trafficLightButtonsLeftMargin = [sender doubleValue];
    }    
}

- (void)dealloc
{
    [_windowControllers release];
    [super dealloc];
}
@end
