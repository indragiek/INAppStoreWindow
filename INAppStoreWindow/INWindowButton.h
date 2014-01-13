//
//  INWindowButton.h
//
//  Created by Vladislav Alexeev on 13.01.13.
//  Copyright (c) 2013-2014 Indragie Karunaratne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 A concrete NSButton subclass that allows to mimic standard window title bar "traffic light" buttons
 and replace their graphics with custom ones.
 */
@interface INWindowButton : NSButton

/**
 A group identifier the receiver was initialized with.
 */
@property (nonatomic, copy, readonly) NSString *groupIdentifier;

/**
 An image for the normal state.
 */
@property (nonatomic, strong) NSImage *activeImage;

/**
 An image for the normal state, but displayed when receiver's window in not a key.
 */
@property (nonatomic, strong) NSImage *activeNotKeyWindowImage;

/**
 An image used in disabled state.
 */
@property (nonatomic, strong) NSImage *inactiveImage;

/**
 An image used when user hovers receiver with mouse pointer.
 */
@property (nonatomic, strong) NSImage *rolloverImage;

/**
 An image for the pressed state.
 */
@property (nonatomic, strong) NSImage *pressedImage;

/**
 @param size Designated size of the button. System size is 14x16 and you are considered to use it.
 @param groupIdentifier ID of the group which will apply rollover effect to it's members. You may pass `nil`.
 @see initWithSize:groupIdentifier:
 */
+ (instancetype)windowButtonWithSize:(NSSize)size groupIdentifier:(NSString *)groupIdentifier;

/**
 @abstract Designated initializer.
 @discussion Initializes receiver with the given size and includes it to the group with the given identifier.
 Groups are used to apply rollover effect to all buttons that are inside the same group.
 E.g. close, minimize and zoom buttons should be inside the same group since they all get rollover effect
 when mouse pointer points to one of these buttons.
 @param size Designated size of the button. System size is 14x16 and you are considered to use it.
 @param groupIdentifier ID of the group which will apply rollover effect to it's members. You may pass `nil`.
 */
- (instancetype)initWithSize:(NSSize)size groupIdentifier:(NSString *)groupIdentifier;

@end
