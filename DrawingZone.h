#import <Cocoa/Cocoa.h>

@class VoronoiAppDelegate;
@class SetOfPt2f;
@class DCEL;

@interface DrawingZone : NSView
{
    SetOfPt2f* ptsToDraw;
    SetOfPt2f* segmentsToDraw;
    DCEL*      dataFromDCEL;
    SetOfPt2f* boundingBoxtoDraw;
    SetOfPt2f* polygonizeMonoToDraw;
    SetOfPt2f* angularSortingtoDraw;
    SetOfPt2f* convexHullToDraw;
    SetOfPt2f* angularTriangulationToDraw;
    SetOfPt2f* delaunayTriangulationToDraw;
    SetOfPt2f* voronoiDiagramToDraw;

    VoronoiAppDelegate* pointerOnAppDelegate; // this property is necessary because the mouseDown can't (I can't actually ^_^) send it's event to the AppDelegate! Once this problem is resolved, this property should be deleted.
    NSTextField*        totalNumberOfPointsBis;
    double              sizeOfPointsToDraw;
    float               pointAndSegmentColors[8];
    BOOL                firstTimePts;
    BOOL                firstTimeSegments;

    BOOL drawPts;
    BOOL drawBoundingBox;
    BOOL drawPolygonMono;
    BOOL drawAngularSortingFromBottom;
    BOOL drawConvexHull;
    BOOL drawAngularTriangulation;
    BOOL drawDelaunayTriangulation;
    BOOL drawVoronoiDiagram;
}

#pragma mark -
#pragma mark Properties: pointers on data to be drawn

@property (readwrite, retain) SetOfPt2f* ptsToDraw;
@property (readwrite, retain) SetOfPt2f* segmentsToDraw;
@property (readwrite, retain) DCEL*      dataFromDCEL;
@property (readwrite, retain) SetOfPt2f* boundingBoxtoDraw;
@property (readwrite, retain) SetOfPt2f* polygonizeMonoToDraw;
@property (readwrite, retain) SetOfPt2f* angularSortingtoDraw;
@property (readwrite, retain) SetOfPt2f* convexHullToDraw;
@property (readwrite, retain) SetOfPt2f* angularTriangulationToDraw;
@property (readwrite, retain) SetOfPt2f* delaunayTriangulationToDraw;
@property (readwrite, retain) SetOfPt2f* voronoiDiagramToDraw;

#pragma mark -
#pragma mark Properties

@property (readwrite, weak  ) VoronoiAppDelegate*   pointerOnAppDelegate;
@property (readwrite, retain) NSTextField*          totalNumberOfPointsBis;
@property (readwrite, assign) double                sizeOfPointsToDraw;
@property (readwrite, assign) BOOL                  firstTimePts;
@property (readwrite, assign) BOOL                  firstTimeSegments;

#pragma mark -
#pragma mark Properties: active draw in drawRect

@property (readwrite, assign) BOOL drawPts;
@property (readwrite, assign) BOOL drawBoundingBox;
@property (readwrite, assign) BOOL drawPolygonMono;
@property (readwrite, assign) BOOL drawAngularSortingFromBottom;
@property (readwrite, assign) BOOL drawConvexHull;
@property (readwrite, assign) BOOL drawAngularTriangulation;
@property (readwrite, assign) BOOL drawDelaunayTriangulation;
@property (readwrite, assign) BOOL drawVoronoiDiagram;

#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id)initWithFrame:(NSRect)frame;

/// Free memory
- (void) dealloc;

#pragma mark -
#pragma mark Drawing "callback"

/// Main drawing function
- (void) drawRect:(NSRect)dirtyRect;

#pragma mark -
#pragma mark Functionality methods

/// Redifine method
- (BOOL) acceptsFirstResponder;

/// WARNING!!!! this method should not be implemented here but in appdelegate!
- (void) mouseDown:(NSEvent *)theEvent;

/// Set the color of the points and the segments
- (void) setColor:(double)pColorValue atIndex:(unsigned int)pIndex;

/// Set the specific draw... property to YES
- (void) redrawActiveGraph:(char) pGraphId;

@end
