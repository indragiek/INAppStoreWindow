//
//  SampleWindowController.m
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011 PCWiz Computer. All rights reserved.
//

#import "SampleWindowController.h"
#import "INAppStoreWindow.h"

@implementation SampleWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    // The class of the window has been set in INAppStoreWindow in Interface Builder
    INAppStoreWindow *aWindow = (INAppStoreWindow*)[self window];
    aWindow.titleBarHeight = 40.0;
	aWindow.trafficLightButtonsLeftMargin = 13.0;
}

@end
