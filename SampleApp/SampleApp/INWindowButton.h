//
//  INWindowButton.h
//  SampleApp
//
//  Created by beefon on 13.01.13.
//  Copyright (c) 2013 Indragie Karunaratne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface INWindowButton : NSButton

@property (nonatomic, copy, readonly) NSString *groupIdentifier;

@property (nonatomic, strong) NSImage *active;
@property (nonatomic, strong) NSImage *activeNotKeyWindow;
@property (nonatomic, strong) NSImage *inactiveImage;
@property (nonatomic, strong) NSImage *rolloverImage;
@property (nonatomic, strong) NSImage *pressedImage;

+ (instancetype)windowButtonWithSize:(NSSize)size groupIdentifier:(NSString *)groupID;

@end
