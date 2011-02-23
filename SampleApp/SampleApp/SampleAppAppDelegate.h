//
//  SampleAppAppDelegate.h
//  SampleApp
//
//  Created by Indragie Karunaratne on 11-02-23.
//  Copyright 2011 PCWiz Computer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SampleAppAppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray *windowControllers;
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSMutableArray *windowControllers;
@end
