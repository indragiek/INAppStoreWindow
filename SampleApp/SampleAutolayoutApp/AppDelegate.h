//
//  AppDelegate.h
//  SampleAutolayoutApp
//
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet INAppStoreWindow *window;
@property (weak) IBOutlet NSView *autoLayoutView;

@property (weak) IBOutlet NSLayoutConstraint *constraint;
@property (weak) IBOutlet NSTextField *titleBarLabel;

- (IBAction)changeLayoutConstraints:(id)sender;

@end
