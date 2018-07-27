/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This file is used to drive the interactions of the global AnnotationPanel.nib
         view in PDFAnnotation Editor. Depending on which annotation is currently in focus,
         AnnotationPanel.nib will be updated to display which types of values the user may
         change on the annotation. For example, when editing a circle annotation, the user
         can change properties such as the border color and interior color of the circle.
         In addition to color, when editing a line annotation, the user can change the
         starting and ending line styles. To see all of the different annotation editing views,
         look at the Attributes View UI which is part of the AnnotationPanel.nib file.
*/ 

// ======================================================================================================================
//  AnnotationPanel.h
// ======================================================================================================================


#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


// Notification.
extern NSString *AnnotationPanelAnnotationDidChangeNotification;


@interface AnnotationPanel : NSPanel
{
	PDFAnnotation			*_annotation;
	BOOL					_ignoreTextEnter;
	
	IBOutlet NSPanel		*_annotationPanel;
	IBOutlet NSTextField	*_subtypeLabel;
	IBOutlet NSTabView		*_attributesView;
	
	IBOutlet NSTextField	*_buttonFieldName;		// Widget (Button)
	IBOutlet NSMatrix		*_controlType;
	IBOutlet NSTextField	*_onValue;
	IBOutlet NSButton		*_buttonHasBGColor;
	IBOutlet NSColorWell	*_buttonBGColor;
	IBOutlet NSButton		*_buttonHasColor;
	IBOutlet NSColorWell	*_buttonColor;
	
	IBOutlet NSTextField	*_choiceFieldName;		// Widget (Choice)
	
	IBOutlet NSTextField	*_circleContents;		// Circle, Square
	IBOutlet NSColorWell	*_circleColor;
	IBOutlet NSButton		*_circleHasInteriorColor;
	IBOutlet NSColorWell	*_circleInteriorColor;
	
	IBOutlet NSTextField	*_freeTextContents;		// Free Text
	IBOutlet NSColorWell	*_freeTextColor;
	IBOutlet NSColorWell	*_freeTextFontColor;

	IBOutlet NSTextField	*_inkContents;			// Ink
	IBOutlet NSColorWell	*_inkColor;
	
	IBOutlet NSTextField	*_lineContents;			// Line
	IBOutlet NSColorWell	*_lineColor;
	IBOutlet NSButton		*_lineHasInteriorColor;
	IBOutlet NSColorWell	*_lineInteriorColor;
	IBOutlet NSPopUpButton	*_startStyle;
	IBOutlet NSPopUpButton	*_endStyle;
	
	IBOutlet NSButton		*_linkHasDestination;	// Link
	IBOutlet NSTextField	*_linkPage;
	IBOutlet NSTextField	*_linkPointX;
	IBOutlet NSTextField	*_linkPointY;
	IBOutlet NSButton		*_linkHasColor;
	IBOutlet NSColorWell	*_linkColor;
	
	IBOutlet NSTextField	*_markupContents;		// Markup
	IBOutlet NSColorWell	*_markupColor;
	IBOutlet NSPopUpButton	*_markupType;
	
	IBOutlet NSTextField	*_stampContents;		// Stamp
	IBOutlet NSTextField	*_stampName;
	
	IBOutlet NSTextField	*_textContents;			// Text
	IBOutlet NSColorWell	*_textColor;
	IBOutlet NSPopUpButton	*_textIcon;
	IBOutlet NSButton		*_textIsOpen;
	
	IBOutlet NSTextField	*_textFieldName;		// Widget (Text)
	IBOutlet NSTextField	*_maxLen;
	IBOutlet NSPopUpButton	*_textAlignment;
	IBOutlet NSButton		*_textHasBGColor;
	IBOutlet NSColorWell	*_textBGColor;
	
	IBOutlet NSButton		*_displayFlag;			// Flags
	IBOutlet NSButton		*_printFlag;
	
	IBOutlet NSPopUpButton	*_actionType;			// Actions
	IBOutlet NSTabView		*_actionView;
	
	IBOutlet NSTextField	*_gotoPage;				// Go To Action
	IBOutlet NSButton		*_hasGotoPointX;
	IBOutlet NSButton		*_hasGotoPointY;
	IBOutlet NSTextField	*_gotoPointX;
	IBOutlet NSTextField	*_gotoPointY;
	
	IBOutlet NSPopUpButton	*_actionName;			// Named Action
	
	IBOutlet NSButton		*_resetExclude;			// Reset Form Action
	IBOutlet NSTextField	*_resetText;
	
	IBOutlet NSTextField	*_actionURL;			// URL Action
	
	IBOutlet NSButton		*_hasBorder;			// Border
	IBOutlet NSTextField	*_thickness;
	IBOutlet NSButton		*_dashed;
}

+ (AnnotationPanel *) sharedAnnotationPanel;
- (void) setAnnotation: (PDFAnnotation *) annotation;

- (void) setFieldName: (id) sender;
- (void) setButtonType: (id) sender;
- (void) setOnValue: (id) sender;
- (void) setHasBackgroundColor: (id) sender;
- (void) setBGColor: (id) sender;
- (void) setContents: (id) sender;
- (void) setHasColor: (id) sender;
- (void) setColor: (id) sender;
- (void) setHasInteriorColor: (id) sender;
- (void) setInteriorColor: (id) sender;
- (void) setFontColor: (id) sender;
- (void) setStartStyle: (id) sender;
- (void) setEndStyle: (id) sender;
- (void) setLinkHasDestination: (id) sender;
- (void) setLinkPage: (id) sender;
- (void) setLinkPointX: (id) sender;
- (void) setLinkPointY: (id) sender;
- (void) setMarkupType: (id) sender;
- (void) setStampName: (id) sender;
- (void) setTextIcon: (id) sender;
- (void) setIsOpen: (id) sender;
- (void) setMaxLen: (id) sender;
- (void) setAlignment: (id) sender;

- (void) setPrint: (id) sender;
- (void) setDisplay: (id) sender;

- (void) setActionType: (id) sender;
- (void) setActionPage: (id) sender;
- (void) setHasActionPointX: (id) sender;
- (void) setHasActionPointY: (id) sender;
- (void) setActionPointX: (id) sender;
- (void) setActionPointY: (id) sender;
- (void) setActionName: (id) sender;
- (void) setResetExclude: (id) sender;
- (void) setResetFields: (id) sender;
- (void) setActionURL: (id) sender;

- (void) setHasBorder: (id) sender;
- (void) setThickness: (id) sender;
- (void) setDashed: (id) sender;

@end
