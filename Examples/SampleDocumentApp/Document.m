//
//  Document.m
//  SampleDocumentApp
//
//  Created by Indragie Karunaratne on 2012-08-29.
//  Copyright (c) 2012-2014 Indragie Karunaratne. All rights reserved.
//
//  Licensed under the BSD 2-clause License. See LICENSE file distributed in the source
//  code of this project.
//

#import "Document.h"
#import "INAppStoreWindow.h"

@implementation Document

- (id)init
{
	self = [super init];
	if (self) {
		// Add your subclass-specific initialization here.
	}
	return self;
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	NSWindowController *controller = [[self windowControllers] objectAtIndex:0];
	INAppStoreWindow *window = (INAppStoreWindow *) [controller window];
	window.titleBarHeight = 40.f;
	window.centerTrafficLightButtons = YES;
	window.bottomBarHeight = window.titleBarHeight;
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
	return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	return [NSData data];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	return YES;
}

@end
