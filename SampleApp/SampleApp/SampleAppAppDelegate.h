//
//  SampleAppAppDelegate.h
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011 PCWiz Computer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface SampleAppAppDelegate : NSObject <NSApplicationDelegate> {
    INAppStoreWindow *_window;
    NSMutableArray *_windowControllers;
    NSButton *_centerFullScreen;
    NSButton *_centerTrafficLight;
    NSSlider *_fullScreenRightMarginSlider;
    NSSlider *_trafficLightLeftMargin;
}

@property (assign) IBOutlet INAppStoreWindow *window;
@property (nonatomic, retain) NSMutableArray *windowControllers;
@property (assign) IBOutlet NSButton *centerFullScreen;
@property (assign) IBOutlet NSButton *centerTrafficLight;
@property (assign) IBOutlet NSSlider *fullScreenRightMarginSlider;
@property (assign) IBOutlet NSSlider *trafficLightLeftMargin;

- (IBAction)checkboxAction:(id)sender;
- (IBAction)sliderAction:(id)sender;

@end
