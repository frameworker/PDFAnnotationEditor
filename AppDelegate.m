/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 PDFAnnotation Editor's AppDelegate.m.
*/ 

// =====================================================================================================================
//  AppDelegate.m
// =====================================================================================================================


#import "AppDelegate.h"


@implementation AppDelegate


- (BOOL) applicationShouldOpenUntitledFile: (NSApplication *) application
{
    
#ifdef DEBUG
    NSLog(@"DEBUG INFO");
#endif
    
    return NO;
}

@end
