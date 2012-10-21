//
//  SampleAppAppDelegate.m
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011 Indragie Karunaratne. All rights reserved.
//

#import "SampleAppAppDelegate.h"
#import "SampleWindowController.h"

@implementation SampleAppAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.windowControllers = [NSMutableArray array];
    // The class of the window has been set in INAppStoreWindow in Interface Builder
    self.window.trafficLightButtonsLeftMargin = 7.0;
    self.window.fullScreenButtonRightMargin = 7.0;   
    self.window.centerFullScreenButton = YES;
    self.window.titleBarHeight = 60.0;
    
    // set checkboxes
    self.centerFullScreen.state = self.window.centerFullScreenButton;
    self.centerTrafficLight.state = self.window.centerTrafficLightButtons;
    self.verticalTrafficLight.state = self.window.verticalTrafficLightButtons;
    self.showsBaselineSeparator.state = self.window.showsBaselineSeparator;
    self.fullScreenRightMarginSlider.doubleValue = self.window.fullScreenButtonRightMargin;
    self.trafficLightLeftMargin.doubleValue = self.window.trafficLightButtonsLeftMargin;
}

- (IBAction)showSheetAction:(id)sender
{
    [NSApp beginSheet:self.sheet modalForWindow:self.window
        modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)doneSheetAction:(id)sender
{
    [self.sheet orderOut:nil];
    [NSApp endSheet:self.sheet];
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
    } else if ( [sender isEqual:self.centerTrafficLight] ) {
        self.window.centerTrafficLightButtons = [sender state];
    } else if ( [sender isEqual:self.verticalTrafficLight] ) {
        self.window.verticalTrafficLightButtons = [sender state];
    } else {
        self.window.showsBaselineSeparator = [sender state];
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
