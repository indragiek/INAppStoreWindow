//
//  NSColor+INAdditions.m
//  SampleApp
//
//  Created by Ash Furrow on 2013-01-27.
//  Copyright (c) 2013 Indragie Karunaratne. All rights reserved.
//

#import "NSColor+INAdditions.h"


@implementation NSColor (INAdditions)
- (CGColorRef)IN_CGColorCreate
{
    NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat components[4];
    [rgbColor getComponents:components];
    
    CGColorSpaceRef theColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGColorRef theColor = CGColorCreate(theColorSpace, components);
    CGColorSpaceRelease(theColorSpace);
	return theColor;
}
@end
