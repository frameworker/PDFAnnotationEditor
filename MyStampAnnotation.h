/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 MyStampAnnotation represents a custom subclass of PDFAnnotation for the stamp
         annotation subtype. PDFKit does not support any native rendering for stamp
         annotations, but we can subclass PDFAnnotation in order to override
         -[PDFAnnotation drawWithBox:inContext:] to render the desired UI for
         this specific annotation subtype. See the implementation file of this class
         for more details.
*/ 

// =====================================================================================================================
//  MyStampAnnotation.h
// =====================================================================================================================


#import <Quartz/Quartz.h>


@interface MyStampAnnotation : PDFAnnotation
{
}

- (void) transformContextForBox: (PDFDisplayBox) box;
@end
