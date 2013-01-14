//
//  INWindowButton.m
//  SampleApp
//
//  Created by beefon on 13.01.13.
//  Copyright (c) 2013 Indragie Karunaratne. All rights reserved.
//

#import "INWindowButton.h"

#pragma mark - Window Button Group

NSString *const INWindowButtonGroupDidUpdateRolloverStateNotification = @"INWindowButtonGroupDidUpdateRolloverStateNotification";
NSString *const kINWindowButtonGroupDefault = @"com.indragie.inappstorewindow.defaultWindowButtonGroup";

@interface INWindowButtonGroup : NSObject

+ (instancetype)groupWithIdentifier:(NSString *)identifier;
@property (nonatomic, copy, readonly) NSString *identifier;

- (void)didCaptureMousePointer;
- (void)didReleaseMousePointer;
- (BOOL)shouldDisplayRollOver;

- (void)resetMouseCaptures;

@end

@interface INWindowButtonGroup ()
@property (nonatomic, assign) NSInteger numberOfCaptures;
@end

@implementation INWindowButtonGroup

+ (instancetype)groupWithIdentifier:(NSString *)identifier {
    static NSMutableDictionary *groups = nil;
    if (groups == nil) {
        groups = [[NSMutableDictionary alloc] init];
    }
    
    if (identifier == nil) {
        identifier = kINWindowButtonGroupDefault;
    }
    
    INWindowButtonGroup *group = [groups objectForKey:identifier];
    if (group == nil) {
        group = [[[self class] alloc] initWithIdentifier:identifier];
        [groups setObject:group forKey:identifier];
    }
    return group;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
    }
    return self;
}

- (void)setNumberOfCaptures:(NSInteger)numberOfCaptures {
    if (_numberOfCaptures != numberOfCaptures) {
        _numberOfCaptures = numberOfCaptures;
        [[NSNotificationCenter defaultCenter] postNotificationName:INWindowButtonGroupDidUpdateRolloverStateNotification
                                                            object:self];
    }
}

- (void)didCaptureMousePointer {
    self.numberOfCaptures++;
}

- (void)didReleaseMousePointer {
    self.numberOfCaptures--;
}

- (BOOL)shouldDisplayRollOver {
    return (self.numberOfCaptures > 0);
}

- (void)resetMouseCaptures {
    self.numberOfCaptures = 0;
}

@end

#pragma mark - Window Button

@interface INWindowButton ()
@property (nonatomic, copy) NSString *groupIdentifier;
@property (nonatomic, strong, readonly) INWindowButtonGroup *group;
@property (nonatomic, strong) NSTrackingArea *mouseTrackingArea;

@end

@implementation INWindowButton

+ (instancetype)windowButtonWithSize:(NSSize)size groupIdentifier:(NSString *)groupID {
    INWindowButton *button = [[self alloc] initWithSize:size groupIdentifier:groupID];
    return button;
}

#pragma mark - Init and Dealloc

- (id)initWithSize:(NSSize)size groupIdentifier:(NSString *)groupIdentifier
{
    self = [super initWithFrame:NSMakeRect(0, 0, size.width, size.height)];
    if (self) {
        _groupIdentifier = [groupIdentifier copy];
        [self setButtonType:NSMomentaryChangeButton];
        [self setBordered:NO];
        [self setTitle:@""];
        [self.cell setHighlightsBy:NSContentsCellMask];
        [self.cell setImageDimsWhenDisabled:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowButtonGroupDidUpdateRolloverStateNotification:)
                                                     name:INWindowButtonGroupDidUpdateRolloverStateNotification
                                                   object:self.group];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:INWindowButtonGroupDidUpdateRolloverStateNotification
                                                  object:self.group];
    [super dealloc];
}

#pragma mark - Group

- (INWindowButtonGroup *)group {
    return [INWindowButtonGroup groupWithIdentifier:self.groupIdentifier];
}

- (void)windowButtonGroupDidUpdateRolloverStateNotification:(NSNotification *)n {
    [self updateRollOverImage];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    
    if (self.mouseTrackingArea) {
        [self removeTrackingArea:self.mouseTrackingArea];
    }
    
    self.mouseTrackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                          options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                            owner:self
                                                         userInfo:nil];
    
    [self addTrackingArea:self.mouseTrackingArea];
}

- (void)viewDidMoveToSuperview {
    if (self.superview) {
        [self updateImage];
    }
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    if (self.window) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:self.window];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:self.window];
    }
    if (newWindow != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidChangeFocus:)
                                                     name:NSWindowDidBecomeKeyNotification
                                                   object:newWindow];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidChangeFocus:)
                                                     name:NSWindowDidResignKeyNotification
                                                   object:newWindow];
    }
}

- (void)windowDidChangeFocus:(NSNotification *)n {
    [self updateImage];
}

- (void)setPressedImage:(NSImage *)pressedImage {
    self.alternateImage = pressedImage;
}

- (NSImage *)pressedImage {
    return self.alternateImage;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        self.image = self.activeImage;
    } else {
        self.image = self.inactiveImage;
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    [self.group didCaptureMousePointer];
    [self updateRollOverImage];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    [self.group didReleaseMousePointer];
    [self updateRollOverImage];
}

- (void)updateRollOverImage {
    if ([self.group shouldDisplayRollOver] && [self isEnabled]) {
        self.image = self.rolloverImage;
    } else {
        [self updateImage];
    }
}

- (void)updateImage {
    if ([self isEnabled]) {
        [self updateActiveImage];
    } else {
        self.image = self.inactiveImage;
    }
}

- (void)updateActiveImage {
    if ([self.window isKeyWindow]) {
        self.image = self.activeImage;
    } else {
        self.image = self.activeNotKeyWindowImage;
    }
}

@end
