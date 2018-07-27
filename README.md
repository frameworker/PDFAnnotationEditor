# PDFAnnotation Editor macOS Application

Version 2.1 adds tabbing between annotations in edit mode.

This sample demonstrates how to use [PDFKit](https://developer.apple.com/documentation/pdfkit) to examine, edit and create annotations – interactive UI elements – to your own PDF document.

## Overview

The PDF file format allows for annotations to be associated with a page and a location on that page.
PDFKit natively supports many different annotations types: circle, free text, ink, line, link, highlight/underline/strikethrough,
square, stamp, text, and widgets (interactive form elements). This example shows developers how to create new annotation
subtypes to add to a PDFView, how to examine the different types of properties per annotation subtype, and how to use
new PDFKit API methods to update such properties.

Note: widget annotation types are a little more complicated than the rest of PDFKit's native annotations.
For a more in-depth example on widgets, please take a look at the PDFAnnotationWidgetsAdvanced iOS sample code.

## Creating/Editing a PDFAnnotation Programmatically

### PDFAnnotation Creation

Before taking a look at the example code, it's important to understand how to create a PDFAnnotation.

All annotations are instantiated using the
[`PDFAnnotation`](https://developer.apple.com/documentation/pdfkit/pdfannotation) constructor with the appropriate
[`PDFAnnotationSubtype`](https://developer.apple.com/documentation/pdfkit/pdfannotationsubtype) or a custom subtype.
(For the sake of this example we will stick to PDFKit's native annotation subtypes, but for the record any string may
by used at PDFAnnotation creation.):

```Objective-C
// Create a circle annotation
circleAnnotation = [[PDFAnnotation alloc] initWithBounds:bounds forType:PDFAnnotationSubtypeCircle withProperties:nil];
```

After creating the annotation, the last thing we need to do is add it to a [`PDFPage`](https://developer.apple.com/documentation/pdfkit/pdfpage).
And as long as our PDFPage lives within a [`PDFView`](https://developer.apple.com/documentation/pdfkit/pdfview), the circle annotation will
automatically appear in the view:

```Objective-C
// Add our circle annotation to a PDFPage
[page addAnnotation: circleAnnotation];
```

### PDFAnnotation editing

Editing an annotation is just as easy as creating one. To see all of the different properties developers can modify on an annotation, please
take a look at  [`PDFAnnotation's`](https://developer.apple.com/documentation/pdfkit/pdfannotation) instance properties/instance methods
sections. Within this example, `AnnotationPanel` highlights a handful of these properties/methods.

## Interacting with PDFAnnotation Editor

### Opening a PDF File

After launching PDFAnnotation Editor, there are two ways to begin editing a PDF file with existing annotations, and/or to add new annotations to a PDF:

- 'File > Open', then choose the desired PDF file to open. The application will open a new editing window with the chosen PDF.
- 'File > New'. The application will open a new editing window that is blank, then drag & drop the desired PDF file into the PDFView.

Once you have a window open, you may drag & drop new PDFs into the PDFView as desired. (Note: PDFAnnotation Editor is designed so that there is only
one PDF file per PDFView/window. To have more than one PDF file open while running the application, you must repeat one of the methods above.)

### Creating/Editing Annotations in PDFAnnotation Editor

Once you have a PDF open, adding annotations is simple: select 'File > Annotation', then select whichever new annotation you would like to add to the view.
After adding an annotation, the AnnotationPanel will appear and you may modify the given annotation as available via the editor.

- To change any type of color property on an annotation: select 'File > Annotation > Show Colors'. This will then bring up the system color panel. Once you
have chosen a color, drag it ("it" being the square color well in the bottom left corner of the color panel next to the dropper icon) to the proper color well
in the AnnotationPanel. You will see the color update instantly on the annotation in the PDFView.
- To change any type of font property on an annotation: select 'File > Annotation > Show Fonts', and select the desired font. You will see the font update
instantly in the PDFView. Before you select the font, make sure the annotation you are trying to update is 'selected' according to the AnnotationPanel, else
PDFAnnotation Editor won't know which annotation you're attempting to edit.

### Printing a PDF File

To print the PDF file you have opened and/or edited in PDFAnnotation Editor: select 'File > Print...'.

### Saving a PDF File

To save the PDF file you have opened and/or edited in PDFAnnotation Editor: select 'File > Save' or 'File > Save As...'.

