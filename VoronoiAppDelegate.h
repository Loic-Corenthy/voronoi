#import <Cocoa/Cocoa.h>

@class SetOfPt2f;
@class DrawingZone;
@class DCEL;

@interface VoronoiAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow*       window;
    DrawingZone*    drawingZone;
    SetOfPt2f*      allPts;
    DCEL*           dcel;
    NSTextField*    numberOfPointsFromUser;
    NSTextField*    totalNumberOfPoints;
    NSTextField*    shakeValue;
    NSUInteger      maxNumberOfPoints;
    short           maxIterationToComputeDelaunay;
    char            currentGraphId;
    BOOL            autoRedraw;

}

#pragma mark -
#pragma mark Properties

@property (readwrite, retain) SetOfPt2f*    allPts;
@property (readwrite, retain) DCEL*         dcel;
@property (readonly,  assign) NSUInteger    maxNumberOfPoints;
@property (readwrite, assign) short         maxIterationToComputeDelaunay;
@property (readwrite, assign) char          currentGraphId;
@property (readwrite, assign) BOOL          autoRedraw;

#pragma mark -
#pragma mark IB outlet properties

@property (assign) IBOutlet NSWindow*    window;
@property (assign) IBOutlet DrawingZone* drawingZone;
@property (assign) IBOutlet NSTextField* numberOfPointsFromUser;
@property (assign) IBOutlet NSTextField* totalNumberOfPoints;
@property (assign) IBOutlet NSTextField* shakeValue;

#pragma mark -
#pragma mark Basic methods

/// Free memory
- (void) dealloc;

/// Tell the drawing zone to display the points
- (void) displayPoints;

/// Recalculate the last employed graph
- (void) recalculateGraph;

#pragma mark -
#pragma mark IB actions

- (IBAction)generatePoints:(id)sender;
- (IBAction)addPointsToCurrentOnes:(id)sender;
- (IBAction)clearAllPoints:(id)sender;
- (IBAction)shakeValueFromUser:(id)sender;
- (IBAction)shakePoints:(id)sender;
- (IBAction)setAutomaticRedraw:(id)sender;

- (IBAction)sizeOfPointsFromUser:(id)sender;
- (IBAction)colorOfPointsFromUser:(id)sender;
- (IBAction)colorOfSegmentsFromUser:(id)sender;

#pragma mark -
#pragma mark IB actions: graphs

- (IBAction)boundingBox:(id)sender;
- (IBAction)PolygonizeMono:(id)sender;
- (IBAction)angularSortingFromBottom:(id)sender;
- (IBAction)convexHull:(id)sender;
- (IBAction)angularTriangulation:(id)sender;
- (IBAction)delaunayTriangulation:(id)sender;
- (IBAction)voronoiDiagram:(id)sender;



@end
