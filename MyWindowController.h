/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 PDFAnnotation Editor's custom subclass of NSWindowController. This is used to
         drive multiple open windows within one instance of PDFAnnotation Editor, along
         with assisting saving new PDF files and updating any annotation changes from the
         application. This file also helps drive the toggle between Edit mode and Test mode
         per window. Edit mode allows the user to actively move/edit any annotations in the
         PDF, while Test mode does not as it acts as purely a PDF 'viewer'; users can toggle
         between these modes via the NSSegmentedControl at the bottom of each window.
*/

// =====================================================================================================================
//  MyWindowController.h
// =====================================================================================================================


#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@class PDFViewEdit;


@interface MyWindowController : NSWindowController < PDFDocumentDelegate >
{
	IBOutlet PDFViewEdit			*_pdfView;
	IBOutlet NSProgressIndicator	*_saveProgressBar;			// Saving.
	IBOutlet NSPanel				*_saveWindow;
	IBOutlet NSSegmentedControl		*_editTestButton;
}

- (void) setupDocumentNotifications;
- (void) setEditTestMode: (id) sender;

@end
