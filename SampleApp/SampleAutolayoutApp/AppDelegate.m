//
//  AppDelegate.m
//  SampleAutolayoutApp
//
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.window.titleBarView = self.autoLayoutView;
}

- (void)changeLayoutConstraints:(id)sender
{
    if (self.constraint.constant == 20) {
        [self.constraint.animator setConstant:8];
        self.titleBarLabel.stringValue = @"This is an auto-layout Titlebar";
    } else {
        self.constraint.constant = 20;
        self.titleBarLabel.stringValue = @"This is an awesome auto-layout Titlebar";
    }
}

@end
