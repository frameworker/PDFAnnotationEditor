/*
 <samplecode>
    <abstract>
        The implementation file for AnnotationPanel.h. When a user begins to interact
        with the AnnotationPanel.nib, all of the model updates on the given PDFAnnotation
        take place here.
    </abstract>
 </samplecode>
 
*/

// =====================================================================================================================
//  AnnotationPanel.m
// =====================================================================================================================


#import "AnnotationPanel.h"


NSString *AnnotationPanelAnnotationDidChangeNotification = @"AnnotationPanelAnnotationDidChange";


@interface AnnotationPanel(AnnotationPanelPriv)
- (void) updateAnnotationSubtypeAndAttributes;
@end


@implementation AnnotationPanel
// ===================================================================================================== AnnotationPanel
// ----------------------------------------------------------------------------------------------- sharedAnnotationPanel

+ (AnnotationPanel *) sharedAnnotationPanel
{
    static dispatch_once_t once;
    static AnnotationPanel *gAnnotationPanel;
    
    dispatch_once(&once, ^{
        gAnnotationPanel = [[AnnotationPanel alloc] init];
    });
    
    return gAnnotationPanel;
}

// ---------------------------------------------------------------------------------------------------------------- init

- (id) init
{
	id			myself = NULL;
	
	// Super.
	[super init];
	
	// Lazily load the annotation panel.
	if (_annotationPanel == NULL)
	{
		BOOL		loaded;
		
        loaded = [[NSBundle mainBundle] loadNibNamed: @"AnnotationPanel" owner: self topLevelObjects: nil];
        if( loaded != YES )
            return NULL;
	}
	
	// Display.
	[_annotationPanel makeKeyAndOrderFront: self];
	
	// Set up UI.
	[self updateAnnotationSubtypeAndAttributes];
	
	// Success.
	myself = self;
	
	return myself;
}

// --------------------------------------------------------------------------------------------------------------- panel

- (NSPanel *) panel
{
	return _annotationPanel;
}

// ------------------------------------------------------------------------------------------------------- setAnnotation

- (void) setAnnotation: (PDFAnnotation *) annotation
{
	// Release old.
	if (_annotation != annotation)
		[_annotation release];
	
	// Assign.
	_annotation = [annotation retain];
	
	// Update.
	[self updateAnnotationSubtypeAndAttributes];
}

// -------------------------------------------------------------------------------------------------------- setFieldName

- (void) setFieldName: (id) sender
{
	// Sanity check.
	if ((_annotation == NULL) || (_ignoreTextEnter))
		return;
    
    [_annotation setFieldName:[sender stringValue]];
    
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setButtonType

- (void) setButtonType: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
    [_annotation setWidgetControlType:[sender selectedRow]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ---------------------------------------------------------------------------------------------------------- setOnValue

- (void) setOnValue: (id) sender
{
	// Sanity check.
	if ((_annotation == NULL) || (_ignoreTextEnter))
		return;
	
    [_annotation setButtonWidgetStateString:[sender stringValue]];
    
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ----------------------------------------------------------------------------------------------- setHasBackgroundColor

- (void) setHasBackgroundColor: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
	{
        [_annotation setBackgroundColor:[NSColor blackColor]];
	}
	else
	{
        [_annotation setBackgroundColor:NULL];
	}
	[self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ---------------------------------------------------------------------------------------------------------- setBGColor

- (void) setBGColor: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
    [_annotation setBackgroundColor:[sender color]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// --------------------------------------------------------------------------------------------------------- setContents

- (void) setContents: (id) sender
{
	// Sanity check.
	if ((_annotation == NULL) || (_ignoreTextEnter))
		return;
	
	[_annotation setContents: [sender stringValue]];
//    [self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// --------------------------------------------------------------------------------------------------------- setHasColor

- (void) setHasColor: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
		[_annotation setColor: [NSColor blackColor]];
	else
		[_annotation removeValueForAnnotationKey:PDFAnnotationKeyColor];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------------ setColor

- (void) setColor: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	[_annotation setColor: [sender color]];
//    [self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------- setHasInteriorColor

- (void) setHasInteriorColor: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
	{
        [_annotation setValue:[NSColor blackColor] forAnnotationKey:PDFAnnotationKeyInteriorColor];
	}
	else
	{
        [_annotation removeValueForAnnotationKey:PDFAnnotationKeyInteriorColor];
	}
	[self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ---------------------------------------------------------------------------------------------------- setInteriorColor

- (void) setInteriorColor: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
    
    [_annotation setValue:[sender color] forAnnotationKey:PDFAnnotationKeyInteriorColor];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// -------------------------------------------------------------------------------------------------------- setFontColor

- (void) setFontColor: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
    [_annotation setFontColor:[sender color]];
//    [self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setStartStyle

- (void) setStartStyle: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender indexOfSelectedItem] < 0)
		return;
    
    [_annotation setStartLineStyle:[sender indexOfSelectedItem]];
//    [self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// --------------------------------------------------------------------------------------------------------- setEndStyle

- (void) setEndStyle: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender indexOfSelectedItem] < 0)
		return;
	
    [_annotation setEndLineStyle:[sender indexOfSelectedItem]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ----------------------------------------------------------------------------------------------- setLinkHasDestination

- (void) setLinkHasDestination: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
	{
		PDFDestination	*destination;
		
		destination = [[PDFDestination alloc] initWithPage: [_annotation page] atPoint: NSMakePoint(0.0, 0.0)];
        
        [_annotation setDestination:destination];
	}
	else
	{
        [_annotation setDestination:NULL];
	}
	
	[self updateAnnotationSubtypeAndAttributes];

	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// --------------------------------------------------------------------------------------------------------- setLinkPage

- (void) setLinkPage: (id) sender
{
	int		pageIndex;
	
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	pageIndex = [sender intValue];
	if ((pageIndex < 0) || (pageIndex >= [[[_annotation page] document] pageCount]))
	{
		PDFDestination	*destination;
		
		// Wrong, restore.
		NSBeep();
        destination = [_annotation destination];
		[sender setIntegerValue: [[[_annotation page] document] indexForPage: [destination page]] + 1];
		return;
	}
	else
	{
		PDFDestination	*wasDestination;
		PDFDestination	*newDestination;
		
        wasDestination = [_annotation destination];
		newDestination = [[PDFDestination alloc] initWithPage:
				[[[_annotation page] document] pageAtIndex: pageIndex - 1] 
				atPoint: [wasDestination point]];
        [_annotation setDestination:newDestination];
	}
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setLinkPointX

- (void) setLinkPointX: (id) sender
{
	PDFDestination	*wasDestination;
	PDFDestination	*newDestination;
	float			newPoint;
	
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	newPoint = [sender floatValue];
	
    wasDestination = [_annotation destination];
	newDestination = [[PDFDestination alloc] initWithPage: [wasDestination page]
			atPoint: NSMakePoint(newPoint, [wasDestination point].y)];
    [_annotation setDestination: newDestination];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setLinkPointY

- (void) setLinkPointY: (id) sender
{
	PDFDestination	*wasDestination;
	PDFDestination	*newDestination;
	float			newPoint;
	
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	newPoint = [sender floatValue];
	
    wasDestination = [_annotation destination];
	newDestination = [[PDFDestination alloc] initWithPage: [wasDestination page]
			atPoint: NSMakePoint([wasDestination point].x, newPoint)];
    [_annotation setDestination: newDestination];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setMarkupType

- (void) setMarkupType: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender indexOfSelectedItem] < 0)
		return;
	
    [_annotation setMarkupType: [sender indexOfSelectedItem]];
//    [self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// -------------------------------------------------------------------------------------------------------- setStampName

- (void) setStampName: (id) sender
{
	// Sanity check.
	if ((_annotation == NULL) || (_ignoreTextEnter))
		return;
	
    [_annotation setValue:[sender stringValue] forAnnotationKey:PDFAnnotationKeyIconName];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// --------------------------------------------------------------------------------------------------------- setTextIcon

- (void) setTextIcon: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender indexOfSelectedItem] < 0)
		return;
	
	// Set.
    [_annotation setIconType:[sender indexOfSelectedItem]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ----------------------------------------------------------------------------------------------------------- setIsOpen

- (void) setIsOpen: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	// Set.
    [[_annotation popup] setIsOpen:[sender state]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ----------------------------------------------------------------------------------------------------------- setMaxLen

- (void) setMaxLen: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	// Set.
    [_annotation setMaximumLength: [sender intValue]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// -------------------------------------------------------------------------------------------------------- setAlignment

- (void) setAlignment: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender indexOfSelectedItem] < 0)
		return;
	
	// Set.
    [_annotation setAlignment: [sender indexOfSelectedItem]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------------ setPrint

- (void) setPrint: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	// Toggle printing of annotation.
	[_annotation setShouldPrint: [sender intValue]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ---------------------------------------------------------------------------------------------------------- setDisplay

- (void) setDisplay: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	// Toggle display of annotation.
	[_annotation setShouldDisplay: [sender intValue]];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setActionType

- (void) setActionType: (id) sender
{
	PDFAction	*action = NULL;
	
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender indexOfSelectedItem] < 0)
		return;
	
	// Create action.
	switch ([sender indexOfSelectedItem])
	{
		case 0:		// None.
		break;
		
		case 1:		// Go To
		action = [[PDFActionGoTo alloc] initWithDestination: 
				[[[PDFDestination alloc] initWithPage: [_annotation page] atPoint: NSMakePoint(0.0, 0.0)] autorelease]];
		break;
		
		case 2:		// Named
		action = [(PDFActionNamed *)[PDFActionNamed alloc] initWithName: kPDFActionNamedNextPage];
		break;
		
		case 3:		// Reset
		action = [[PDFActionResetForm alloc] init];
		break;
		
		case 4:		// URL
		action = [[PDFActionURL alloc] initWithURL: [NSURL URLWithString: @"http://www.apple.com"]];
		break;
		
		default:	// None.
		break;
	}
	
	// Set, release action.
    [_annotation setAction: action];
	[action release];
	
	[self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setActionPage

- (void) setActionPage: (id) sender
{
	int		pageIndex;
	
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	pageIndex = [sender intValue];
	if ((pageIndex < 0) || (pageIndex > [[[_annotation page] document] pageCount]))
	{
		PDFDestination	*destination;
		
		// Wrong, restore.
		NSBeep();
        destination = [(PDFActionGoTo *)[_annotation action] destination];
		[sender setIntegerValue: [[[_annotation page] document] indexForPage: [destination page]] + 1];
		return;
	}
	else
	{
		PDFDestination	*wasDestination;
		PDFDestination	*newDestination;
		
        wasDestination = [(PDFActionGoTo *)[_annotation action] destination];
		newDestination = [[PDFDestination alloc] initWithPage:
				[[[_annotation page] document] pageAtIndex: pageIndex - 1] 
				atPoint: [wasDestination point]];
        [(PDFActionGoTo *)[_annotation action] setDestination: newDestination];
	}
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// -------------------------------------------------------------------------------------------------- setHasActionPointX

- (void) setHasActionPointX: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
	{
		[self setActionPointX: _gotoPointX];
	}
	else
	{
		PDFDestination	*wasDestination;
		PDFDestination	*newDestination;
		
        wasDestination = [(PDFActionGoTo *)[_annotation action] destination];
		newDestination = [[PDFDestination alloc] initWithPage: [wasDestination page]
				atPoint: NSMakePoint(kPDFDestinationUnspecifiedValue, [wasDestination point].y)];
        
        [(PDFActionGoTo *)[_annotation action] setDestination: newDestination];
		
		// Notification.
		[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
				object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
	}
	
	// Update UI.
	[self updateAnnotationSubtypeAndAttributes];
}

// -------------------------------------------------------------------------------------------------- setHasActionPointY

- (void) setHasActionPointY: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
	{
		[self setActionPointY: _gotoPointY];
	}
	else
	{
		PDFDestination	*wasDestination;
		PDFDestination	*newDestination;
		
        wasDestination = [(PDFActionGoTo *)[_annotation action] destination];
		newDestination = [[PDFDestination alloc] initWithPage: [wasDestination page]
				atPoint: NSMakePoint([wasDestination point].x, kPDFDestinationUnspecifiedValue)];
        
        [(PDFActionGoTo *)[_annotation action] setDestination: newDestination];
		
		// Notification.
		[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
				object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
	}
	
	// Update UI.
	[self updateAnnotationSubtypeAndAttributes];
}

// ----------------------------------------------------------------------------------------------------- setActionPointX

- (void) setActionPointX: (id) sender
{
	PDFDestination	*wasDestination;
	PDFDestination	*newDestination;
	float			newPoint;
	
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	newPoint = [sender floatValue];
	
    wasDestination = [(PDFActionGoTo *)[_annotation action] destination];
	newDestination = [[PDFDestination alloc] initWithPage: [wasDestination page]
			atPoint: NSMakePoint(newPoint, [wasDestination point].y)];
    
    [(PDFActionGoTo *)[_annotation action] setDestination: newDestination];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ----------------------------------------------------------------------------------------------------- setActionPointY

- (void) setActionPointY: (id) sender
{
	PDFDestination	*wasDestination;
	PDFDestination	*newDestination;
	float			newPoint;
	
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	newPoint = [sender floatValue];
	
    wasDestination = [(PDFActionGoTo *)[_annotation action] destination];
	newDestination = [[PDFDestination alloc] initWithPage: [wasDestination page]
			atPoint: NSMakePoint([wasDestination point].x, newPoint)];
    
    [(PDFActionGoTo *)[_annotation action] setDestination: newDestination];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------- setActionName

- (void) setActionName: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender indexOfSelectedItem] < 0)
		return;
	
	// Set.
    [(PDFActionNamed *)[_annotation action] setName: [sender indexOfSelectedItem] + 1];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ----------------------------------------------------------------------------------------------------- setResetExclude

- (void) setResetExclude: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
    {
        [(PDFActionResetForm *)[_annotation action] setFieldsIncludedAreCleared: NO];
    }
	else
    {
        [(PDFActionResetForm *)[_annotation action] setFieldsIncludedAreCleared: YES];
    }
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ------------------------------------------------------------------------------------------------------ setResetFields

- (void) setResetFields: (id) sender
{
	NSArray	*fieldArray;
	
	// Sanity check.
	if ((_annotation == NULL) || (_ignoreTextEnter))
		return;
	
	// I'm lazy Ñ require user to enter fields manually with comma-space seperators.
	fieldArray = [[sender stringValue] componentsSeparatedByString: @", "];
    [(PDFActionResetForm *)[_annotation action] setFields: fieldArray];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// -------------------------------------------------------------------------------------------------------- setActionURL

- (void) setActionURL: (id) sender
{
	PDFActionURL	*action;
	
	// Sanity check.
	if ((_annotation == NULL) || (_ignoreTextEnter))
		return;
	
	// Set.
	action = [[PDFActionURL alloc] initWithURL: [NSURL URLWithString: [sender stringValue]]];
    [_annotation setAction: action];
	[action release];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// -------------------------------------------------------------------------------------------------------- setHasBorder

- (void) setHasBorder: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
		[_annotation setBorder: [[PDFBorder alloc] init]];
	else
		[_annotation setBorder: NULL];
	[self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// -------------------------------------------------------------------------------------------------------- setThickness

- (void) setThickness: (id) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	[[_annotation border] setLineWidth: [sender floatValue]];
//    [self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

// ----------------------------------------------------------------------------------------------------------- setDashed

- (void) setDashed: (NSButton*) sender
{
	// Sanity check.
	if (_annotation == NULL)
		return;
	
	if ([sender state] == NSOnState)
		[[_annotation border] setStyle: kPDFBorderStyleDashed];
	else
		[[_annotation border] setStyle: kPDFBorderStyleSolid];
//    [self updateAnnotationSubtypeAndAttributes];
	
	// Notification.
	[[NSNotificationCenter defaultCenter] postNotificationName: AnnotationPanelAnnotationDidChangeNotification 
			object: self userInfo: [NSDictionary dictionaryWithObject: _annotation forKey: @"PDFAnnotation"]];
}

@end

@implementation AnnotationPanel(AnnotationPanelPriv)
// ================================================================================================= AnnotationPanelPriv
// -------------------------------------------------------------------------------- updateAnnotationSubtypeAndAttributes

- (void) updateAnnotationSubtypeAndAttributes
{
	PDFAction	*action;
	PDFBorder	*border;
	BOOL		canHaveBorder = YES;
    NSString    *type;
	
	_ignoreTextEnter = YES;
	
	if (_annotation == NULL)
	{
		[_subtypeLabel setStringValue: @""];
		[_attributesView selectTabViewItemAtIndex: 12];
		
		[_actionType selectItemAtIndex: 0];
		[_actionView selectTabViewItemAtIndex: 4];
		
		[_displayFlag setEnabled: NO];
		[_printFlag setEnabled: NO];
		
		return;
	}
    
    // Get and set the annotation subtype.
    type = [_annotation valueForAnnotationKey:PDFAnnotationKeySubtype];
    [_subtypeLabel setStringValue: type];
	
    if ([type isEqualToString:PDFAnnotationSubtypeWidget])
	{
        // Get widget field type. Update subtype label.
        NSString* fieldType = [_annotation widgetFieldType];
        [_subtypeLabel setStringValue: [type stringByAppendingFormat:@" (%@)", fieldType]];
        
        if( [fieldType isEqualToString:PDFAnnotationWidgetSubtypeButton] )
        {
            PDFWidgetControlType    controlType;
            NSString                *string;
            NSColor                    *color;
            
            [_attributesView selectTabViewItemAtIndex: 0];
            
            // Attributes.
            // Field name.
            string = [_annotation fieldName];
            if (string)
                [_buttonFieldName setStringValue: string];
            else
                [_buttonFieldName setStringValue: @""];
            
            // Control type.
            controlType = [_annotation widgetControlType];
            [_controlType selectCellAtRow: controlType column: 0];
            
            // "On" value.
            string = [_annotation buttonWidgetStateString];
            if (string)
                [_onValue setStringValue: string];
            else
                [_onValue setStringValue: @""];
            
            // Background color.
            color = [_annotation backgroundColor];
            [_buttonHasBGColor setState: color != NULL];
            [_buttonBGColor setEnabled: color != NULL];
            if (color == NULL)
                [_buttonBGColor setColor: [NSColor blackColor]];
            else
                [_buttonBGColor setColor: color];
            
            // Color.
            color = [_annotation color];
            [_buttonHasColor setState: color != NULL];
            [_buttonColor setEnabled: color != NULL];
            if (color == NULL)
                [_buttonColor setColor: [NSColor blackColor]];
            else
                [_buttonColor setColor: color];
        }
    
        else if( [fieldType isEqualToString:PDFAnnotationWidgetSubtypeChoice] )
        {
            [_attributesView selectTabViewItemAtIndex: 1];
            
            // Attributes.
            [_choiceFieldName setStringValue: [_annotation fieldName]];
        }
        else if( [fieldType isEqualToString:PDFAnnotationWidgetSubtypeText] )
        {
            NSString        *string;
            NSColor            *color;
            
            [_attributesView selectTabViewItemAtIndex: 10];
            
            // Attributes.
            // Field name.
            string = [_annotation fieldName];
            if (string)
                [_textFieldName setStringValue: string];
            else
                [_textFieldName setStringValue: @""];
            
            // Max len.
            [_maxLen setIntegerValue: [_annotation maximumLength]];
            
            // Alignment.
            [_textAlignment selectItemAtIndex: [_annotation alignment]];
            
            // Background color.
            color = [_annotation backgroundColor];
            [_textHasBGColor setState: color != NULL];
            [_textBGColor setEnabled: color != NULL];
            if (color)
                [_textBGColor setColor: color];
            else
                [_textBGColor setColor: [NSColor blackColor]];
        }
    }
	else if ([type isEqualToString:PDFAnnotationSubtypeCircle] ||
			([type isEqualToString:PDFAnnotationSubtypeSquare]))
	{
		NSString	*string;
		NSColor		*color;
		
		[_attributesView selectTabViewItemAtIndex: 2];
		
		// Attributes.
		// Contents.
		string = [_annotation contents];
		if (string)
			[_circleContents setStringValue: string];
		else
			[_circleContents setStringValue: @""];
		
		// Border color.
		color = [_annotation color];
		if (color)
			[_circleColor setColor: color];
		else
			[_circleColor setColor: [NSColor blackColor]];
		
		// Interior color.
        color = [_annotation valueForAnnotationKey:PDFAnnotationKeyInteriorColor];
		[_circleHasInteriorColor setState: color != NULL];
		[_circleInteriorColor setEnabled: color != NULL];
		if (color)
			[_circleInteriorColor setColor: color];
		else
			[_circleInteriorColor setColor: [NSColor blackColor]];
	}
	else if ([type isEqualToString:PDFAnnotationSubtypeFreeText])
	{
		NSString	*string;
		NSColor		*color;
		
		[_attributesView selectTabViewItemAtIndex: 3];
		
		// Attributes.
		// Contents.
		string = [_annotation contents];
		if (string)
			[_freeTextContents setStringValue: string];
		else
			[_freeTextContents setStringValue: @""];
		
		// Fill color.
		color = [_annotation color];
		if (color)
			[_freeTextColor setColor: color];
		else
			[_freeTextColor setColor: [NSColor blackColor]];
		
		// Font color.
		color = [_annotation fontColor];
		if (color)
		{
//			[_freeTextFontColor setEnabled: YES];
			[_freeTextFontColor setColor: color];
		}
		else
		{
			[_freeTextFontColor setColor: [NSColor blackColor]];
//			[_freeTextFontColor setEnabled: NO];
		}
	}
	else if ([type isEqualToString:PDFAnnotationSubtypeInk])
	{
		NSString	*string;
		NSColor		*color;
		
		[_attributesView selectTabViewItemAtIndex: 4];
		
		// Attributes.
		// Contents.
		string = [_annotation contents];
		if (string)
			[_inkContents setStringValue: string];
		else
			[_inkContents setStringValue: @""];
		
		// Fill color.
		color = [_annotation color];
		if (color)
			[_inkColor setColor: color];
		else
			[_inkColor setColor: [NSColor blackColor]];
	}
	else if ([type isEqualToString:PDFAnnotationSubtypeLine])
	{
		NSString	*string;
		NSColor		*color;
		
		[_attributesView selectTabViewItemAtIndex: 5];
		
		// Attributes.
		// Contents.
		string = [_annotation contents];
		if (string)
			[_lineContents setStringValue: string];
		else
			[_lineContents setStringValue: @""];
		
		// Fill color.
		color = [_annotation color];
		if (color)
			[_lineColor setColor: color];
		else
			[_lineColor setColor: [NSColor blackColor]];

		// Interior color.
		color = [_annotation valueForAnnotationKey:PDFAnnotationKeyInteriorColor];
		[_lineHasInteriorColor setState: color != NULL];
		if (color)
		{
			[_lineInteriorColor setEnabled: YES];
			[_lineInteriorColor setColor: color];
		}
		else
		{
			[_lineInteriorColor setColor: [NSColor blackColor]];
			[_lineInteriorColor setEnabled: NO];
		}
		
		// Line styles.
		[_startStyle selectItemAtIndex: [_annotation startLineStyle]];
		[_endStyle selectItemAtIndex: [_annotation endLineStyle]];
	}
	else if ([type isEqualToString:PDFAnnotationSubtypeLink])
	{
		NSColor			*color;
		PDFDestination	*destination;
		
		[_attributesView selectTabViewItemAtIndex: 6];
		
		// Attributes.
		// Destination.
		destination = [_annotation destination];
		[_linkHasDestination setState: destination != NULL];
		[_linkPage setEnabled: destination != NULL];
		[_linkPointX setEnabled: destination != NULL];
		[_linkPointY setEnabled: destination != NULL];
		
		if (destination == NULL)
		{
			[_linkPage setStringValue: @""];
			[_linkPointX setStringValue: @""];
			[_linkPointY setStringValue: @""];
		}
		else
		{
			[_linkPage setIntegerValue: [[[_annotation page] document] indexForPage: [destination page]] + 1];
			[_linkPointX setFloatValue: [destination point].x];
			[_linkPointY setFloatValue: [destination point].y];
		}
		
		// Border color.
		color = [_annotation color];
		[_linkHasColor setState: color != NULL];
		[_linkColor setEnabled: color != NULL];
		if (color)
			[_linkColor setColor: color];
		else
			[_linkColor setColor: [NSColor blackColor]];
	}
	else if ([type isEqualToString:PDFAnnotationSubtypeHighlight] ||
             [type isEqualToString:PDFAnnotationSubtypeUnderline] ||
             [type isEqualToString:PDFAnnotationSubtypeStrikeOut])
	{
		NSString	*string;
		NSColor		*color;
		
		[_attributesView selectTabViewItemAtIndex: 7];
		
		// Attributes.
		// Contents.
		string = [_annotation contents];
		if (string)
			[_markupContents setStringValue: string];
		else
			[_markupContents setStringValue: @""];
		
		// Fill color.
		color = [_annotation color];
		if (color)
			[_markupColor setColor: color];
		else
			[_markupColor setColor: [NSColor blackColor]];
		
		// Type.
		[_markupType selectItemAtIndex: [_annotation markupType]];
		
		// No border.
		canHaveBorder = NO;
	}
	else if ([type isEqualToString:PDFAnnotationSubtypeStamp])
	{
		NSString	*string;
		
		[_attributesView selectTabViewItemAtIndex: 8];
		
		// Attributes.
		// Contents.
		string = [_annotation contents];
		if (string)
			[_stampContents setStringValue: string];
		else
			[_stampContents setStringValue: @""];
		
		// Name.
		string = [_annotation valueForAnnotationKey:PDFAnnotationKeyIconName];
		if (string)
			[_stampName setStringValue: string];
		else
			[_stampName setStringValue: @""];
		
		// No border.
		canHaveBorder = NO;
	}
	else if ([type isEqualToString:PDFAnnotationSubtypeText])
	{
		NSString	*string;
		NSColor		*color;
		
		[_attributesView selectTabViewItemAtIndex: 9];
		
		// Attributes.
		// Contents.
		string = [_annotation contents];
		if (string)
			[_textContents setStringValue: string];
		else
			[_textContents setStringValue: @""];
		
		// Note color.
		color = [_annotation color];
		if (color)
			[_textColor setColor: color];
		else
			[_textColor setColor: [NSColor blackColor]];
		
		// Icon type.
		[_textIcon selectItemAtIndex: [_annotation iconType]];
		
		// Is open.
		[_textIsOpen setState: [[_annotation popup] isOpen]];
		
		// No border.
		canHaveBorder = NO;
	}
	else if ([type isEqualToString:PDFAnnotationSubtypePopup])
	{
		[_attributesView selectTabViewItemAtIndex: 11];
		
		// No border.
		canHaveBorder = NO;
	}
	else
	{
		[_subtypeLabel setStringValue: @"Unknown"];
		[_attributesView selectTabViewItemAtIndex: 12];
		
		// No border.
		canHaveBorder = NO;
	}
	
	// Flags.
	[_displayFlag setEnabled: YES];
	[_displayFlag setState: [_annotation shouldDisplay]];
	[_printFlag setEnabled: YES];
	[_printFlag setState: [_annotation shouldPrint]];
	
	// Action
	// Action
	// Action
	// Action
	// Action
	action = [_annotation action];
	if (action == NULL)
	{
		[_actionType selectItemAtIndex: 0];
		[_actionView selectTabViewItemAtIndex: 4];
	}
	else if ([action isKindOfClass: [PDFActionGoTo class]])
	{
		// Skip if we have a destination.
        if ([_annotation destination] != NULL)
		{
			[_actionType selectItemAtIndex: 0];
			[_actionView selectTabViewItemAtIndex: 4];
		}
		else
		{
			PDFDestination	*destination;
			
			[_actionType selectItemAtIndex: 1];
			[_actionView selectTabViewItemAtIndex: 0];
			
			destination = [(PDFActionGoTo *)[_annotation action] destination];
			[_gotoPage setIntegerValue: [[[destination page] document] indexForPage: [destination page]] + 1];
			if ([destination point].x == kPDFDestinationUnspecifiedValue)
			{
				[_hasGotoPointX setState: NSOffState];
				[_gotoPointX setFloatValue: 0.0];
				[_gotoPointX setEnabled: NO];
			}
			else
			{
				[_hasGotoPointX setState: NSOnState];
				[_gotoPointX setFloatValue: [destination point].x];
				[_gotoPointX setEnabled: YES];
			}
			if ([destination point].y == kPDFDestinationUnspecifiedValue)
			{
				[_hasGotoPointY setState: NSOffState];
				[_gotoPointY setFloatValue: 0.0];
				[_gotoPointY setEnabled: NO];
			}
			else
			{
				[_hasGotoPointY setState: NSOnState];
				[_gotoPointY setFloatValue: [destination point].y];
				[_gotoPointY setEnabled: YES];
			}
		}
	}
	else if ([action isKindOfClass: [PDFActionNamed class]])
	{
		[_actionType selectItemAtIndex: 2];
		[_actionView selectTabViewItemAtIndex: 1];
		
		[_actionName selectItemAtIndex: [(PDFActionNamed *)action name] - 1];
	}
	else if ([action isKindOfClass: [PDFActionResetForm class]])
	{
		NSArray	*fields;
		
		[_actionType selectItemAtIndex: 3];
		[_actionView selectTabViewItemAtIndex: 2];
		
		[_resetExclude setState: [(PDFActionResetForm *)action fieldsIncludedAreCleared] == NO];
		fields = [(PDFActionResetForm *)action fields];
		if ((fields) && ([fields count] > 0))
			[_resetText setStringValue: [fields componentsJoinedByString: @", "]];
		else
			[_resetText setStringValue: @""];
	}
	else if ([action isKindOfClass: [PDFActionURL class]])
	{
		[_actionType selectItemAtIndex: 4];
		[_actionView selectTabViewItemAtIndex: 3];
		
		[_actionURL setStringValue: [[(PDFActionURL *)action URL] absoluteString]];
	}
	
	// Border.
	if (canHaveBorder)
	{
		[_hasBorder setEnabled: YES];
		
		border = [_annotation border];
		[_hasBorder setState: (border != NULL)];
		if (border)
		{
			[_thickness setEnabled: YES];
			[_thickness setStringValue: [NSString stringWithFormat: @"%.1f", [border lineWidth]]];
			
			[_dashed setEnabled: YES];
			[_dashed setState: [border style] == kPDFBorderStyleDashed];
		}
		else
		{
			[_thickness setStringValue: @""];
			[_thickness setEnabled: NO];
			
			[_dashed setState: NSOffState];
			[_dashed setEnabled: NO];
		}
	}
	else
	{
		[_hasBorder setEnabled: NO];
		[_hasBorder setState: NSOffState];
		[_thickness setStringValue: @""];
		[_thickness setEnabled: NO];
		[_dashed setState: NSOffState];
		[_dashed setEnabled: NO];
	}
	
	_ignoreTextEnter = NO;
}

@end
