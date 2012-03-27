//
//  SampleAppAppDelegate.h
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011 PCWiz Computer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface SampleAppAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSPanel *_sheet;
    INAppStoreWindow *_window;
    NSButton *_centerFullScreen;
    NSButton *_centerTrafficLight;
    NSSlider *_fullScreenRightMarginSlider;
    NSSlider *_trafficLightLeftMargin;
    NSButton *_showsBaselineSeparator;
    NSMutableArray *_windowControllers;    
}

@property (assign) IBOutlet NSPanel *sheet;
@property (assign) IBOutlet INAppStoreWindow *window;
@property (assign) IBOutlet NSButton *centerFullScreen;
@property (assign) IBOutlet NSButton *centerTrafficLight;
@property (assign) IBOutlet NSSlider *fullScreenRightMarginSlider;
@property (assign) IBOutlet NSSlider *trafficLightLeftMargin;
@property (assign) IBOutlet NSButton *showsBaselineSeparator;
@property (nonatomic, retain) NSMutableArray *windowControllers;

- (IBAction)createWindowController:(id)sender;
- (IBAction)checkboxAction:(id)sender;
- (IBAction)sliderAction:(id)sender;

- (IBAction)showSheetAction:(id)sender;
- (IBAction)doneSheetAction:(id)sender;

@end
