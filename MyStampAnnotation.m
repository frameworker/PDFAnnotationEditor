/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This file demonstrates how to subclass -[PDFAnnotation drawWithBox:inContext]
         in order to render our own custom drawing for the MyStampAnnotation subclass
         of PDFAnnotation.
*/ 

// =====================================================================================================================
//  MyStampAnnotation.m
// =====================================================================================================================


#import "MyStampAnnotation.h"


@implementation MyStampAnnotation : PDFAnnotation
// =================================================================================================== MyStampAnnotation
// --------------------------------------------------------------------------------------------------------- drawWithBox

- (void) drawWithBox: (PDFDisplayBox) box
{
	NSImage		*stampImage;
	
	// Sanity check.
    if( (box < kPDFDisplayBoxMediaBox) || (box > kPDFDisplayBoxArtBox) )
        return;

	// Save.
	[NSGraphicsContext saveGraphicsState];
	
	// Tranform.
	[self transformContextForBox: box];
	
	[[NSBezierPath bezierPathWithRect: [self bounds]] setClip];
	
	// Draw image.
	stampImage = [NSImage imageNamed: @"MyStamp"];
	[[stampImage bestRepresentationForDevice: NULL] drawInRect: [self bounds]];
	
	// Restore.
	[NSGraphicsContext restoreGraphicsState];
}

// ---------------------------------------------------------------------------------------------- transformContextForBox

- (void) transformContextForBox: (PDFDisplayBox) box
{
	NSAffineTransform   *transform;
	NSRect              boxRect;
	NSInteger           rotation;
	
	if ([self page] == NULL)
		return;
	
	// Get the page bounds for box.
	boxRect = [[self page] boundsForBox: box];
	
	// Identity.
	transform = [NSAffineTransform transform];
	
	// Handle rotation.
	rotation = [[self page] rotation];
	switch (rotation)
	{
		case 90:
		[transform rotateByDegrees: -90];
		[transform translateXBy: -boxRect.size.width yBy: 0.0];
		break;
		
		case 180:
		[transform rotateByDegrees: 180];
		[transform translateXBy: -boxRect.size.height yBy: -boxRect.size.width];
		break;
		
		case 270:
		[transform rotateByDegrees: 90];
		[transform translateXBy: 0.0 yBy: -boxRect.size.height];
		break;
	}
	
	// Handle origin.
	[transform translateXBy: -boxRect.origin.x yBy: -boxRect.origin.y];
	
	// Concatenate.
	[transform concat];
}

@end
