#import "VoronoiAppDelegate.h"
#import "SetOfPt2f+BasicFunctions.h"
#import "SetOfPt2f+AdvancedFunctions.h"
#import "DrawingZone.h"
#import "DCEL.h"

@implementation VoronoiAppDelegate

#pragma mark -
#pragma mark Properties

@synthesize allPts;
@synthesize dcel;
@synthesize maxNumberOfPoints;
@synthesize maxIterationToComputeDelaunay;
@synthesize currentGraphId;
@synthesize autoRedraw;

#pragma mark -
#pragma mark IB outlet properties

@synthesize window;
@synthesize drawingZone;
@synthesize numberOfPointsFromUser;
@synthesize totalNumberOfPoints;
@synthesize shakeValue;

#pragma mark -
#pragma mark Basic methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Init the set of points which will keep track of all the points
    allPts = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [allPts setName:@"all points"];
    NSLog(@"init %@",allPts.name);
#endif

    // Init a DCEL
    dcel = [[DCEL alloc] init];

    // Define the limit number of points the user can generate or add before creating a graph
    maxNumberOfPoints = 10000;

    // Define the maximum number of iteration over the faces of the DCEL to flip edges to get the delaunay triangulation;
    maxIterationToComputeDelaunay = 20;

    // Save a pointer on all the points in the drawing area for the display operations
    [drawingZone setPtsToDraw:allPts];

    // Save a pointer on the DCEL for the drawing area
    [drawingZone setDataFromDCEL:dcel];

    // Save a pointer on the textField to allow update on mouse event
    [drawingZone setTotalNumberOfPointsBis:totalNumberOfPoints];

    ///
    [drawingZone setPointerOnAppDelegate:self];

}

- (void) dealloc
{
    [dcel release];
    [allPts release];
//    if (allPts) {
//        if ([allPts nbOfPts]>0) {
//            [allPts removeAllPts];
//            [allPts release];
//        }
//    }

    [super dealloc];
}

- (void)displayPoints
{
    [drawingZone setDrawPts:YES];
    [drawingZone setNeedsDisplay:YES];
}

- (void) recalculateGraph;
{
    switch (currentGraphId) {
        case 1:
            [self boundingBox:nil];
            break;

        case 2:
            [self PolygonizeMono:nil];
            break;

        case 3:
            [self angularSortingFromBottom:nil];
            break;

        case 4:
            [self convexHull:nil];
            break;

        case 5:
            [self angularTriangulation:nil];
            break;

        case 6:
            [self delaunayTriangulation:nil];
            break;

        case 7:
            [self voronoiDiagram:nil];
            break;

        case 0:
        default:
            // do nothing
            break;

    }

}

#pragma mark -
#pragma mark IB actions

- (IBAction)generatePoints:(id)sender
{
    // Remove all previous points
    if ([allPts nbOfPts] > 0) {
        [allPts removeAllPts];
    }

    [allPts release];
    allPts = nil;

    // Create a new set of points
    allPts = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [allPts setName:@"all points from generate points"];
    NSLog(@"init %@",allPts.name);
#endif

    [drawingZone setPtsToDraw:allPts];

    // Get dimensions of the viewing region
    double lDrawingZoneWidth = (double) drawingZone.frame.size.width;
    double lDrawingZoneHeight = (double) drawingZone.frame.size.height;

    // Generate new points and add them to the set of points
    NSUInteger lNumberOfPointsToGenerate = [numberOfPointsFromUser integerValue];
    if ((lNumberOfPointsToGenerate) > maxNumberOfPoints) {
        lNumberOfPointsToGenerate = maxNumberOfPoints;
    }

    for (NSUInteger i = 0; i < lNumberOfPointsToGenerate; i++) {
        double lX = lDrawingZoneWidth/(-2.0)  + 10  + (arc4random()/(double)UINT32_MAX)*(lDrawingZoneWidth - 20);
        double lY = lDrawingZoneHeight/(-2.0) + 10 + (arc4random()/(double)UINT32_MAX)*(lDrawingZoneHeight - 20);

        IdxPt2f* lTmpPt = [[IdxPt2f alloc] init];
        [lTmpPt setWithX:lX Y:lY];

        [allPts addPt:lTmpPt andUpdateIndex:YES];

        [lTmpPt release];
    }

    // Refresh display
    [self displayPoints];

    // Display the total number of point (count)
    [totalNumberOfPoints setStringValue:[NSString stringWithFormat:@"%lu",[allPts nbOfPts]]];

}

- (IBAction)addPointsToCurrentOnes:(id)sender
{
    // Get dimensions of the viewing region
    double lDrawingZoneWidth = (double) drawingZone.frame.size.width;
    double lDrawingZoneHeight = (double) drawingZone.frame.size.height;

    // Generate new points and add them to the set of points
    NSUInteger lNumberOfPointsToGenerate = [numberOfPointsFromUser integerValue];
    if ((lNumberOfPointsToGenerate+[allPts nbOfPts]) > maxNumberOfPoints) {
        if([allPts nbOfPts] < (maxNumberOfPoints+1)) {
            lNumberOfPointsToGenerate = (maxNumberOfPoints - [allPts nbOfPts]);
        } else {
            lNumberOfPointsToGenerate = 0;
        }
    }

    for (NSUInteger i = 0; i < lNumberOfPointsToGenerate; i++) {
        double lX = lDrawingZoneWidth/(-2.0)  + 10  + (arc4random()/(double)UINT32_MAX)*(lDrawingZoneWidth - 20);
        double lY = lDrawingZoneHeight/(-2.0) + 10 + (arc4random()/(double)UINT32_MAX)*(lDrawingZoneHeight - 20);

        IdxPt2f* lTmpPt = [[IdxPt2f alloc] init];
        [lTmpPt setWithX:lX Y:lY];

        [allPts addPt:lTmpPt andUpdateIndex:YES];

        [lTmpPt release];
    }


    // Automatically redraw the last drawn graph if there is not too many points
    if ([allPts nbOfPts] < 1000 && autoRedraw) {
        [self recalculateGraph];
        [drawingZone redrawActiveGraph:[self currentGraphId]];

    }

    // Refresh display
    [self displayPoints];

    // Display the total number of point (count)
    [totalNumberOfPoints setStringValue:[NSString stringWithFormat:@"%lu",[allPts nbOfPts]]];
}

- (IBAction)clearAllPoints:(id)sender
{
    [allPts removeAllPts];
    [allPts release];
    allPts = nil;
    [drawingZone setNeedsDisplay:YES];

    // Display the total number of point (count)
    [totalNumberOfPoints setStringValue:[NSString stringWithFormat:@"%lu",0]];

    allPts = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [allPts setName:@"all points from clear all points"];
    NSLog(@"init %@",allPts.name);
#endif

    [drawingZone setPtsToDraw:allPts];

    // Keep the "ID" of the last graph drawn
    [self setCurrentGraphId:0];
}

- (IBAction)shakeValueFromUser:(id)sender
{
    [shakeValue setStringValue:[NSString stringWithFormat:@"%.2f",[sender doubleValue]]];
}

- (IBAction)shakePoints:(id)sender
{
    double lRange = ([shakeValue doubleValue]/10.0);

    [allPts shakeWithinRange:lRange];

    if ([allPts nbOfPts] < 1000 && autoRedraw) {
        [self recalculateGraph];
        [drawingZone redrawActiveGraph:[self currentGraphId]];

    }
    [drawingZone setNeedsDisplay:YES];
}


- (IBAction)setAutomaticRedraw:(id)sender
{
    if ([sender state] == NSOnState) {
        autoRedraw = YES;
    } else {
        autoRedraw = NO;
    }
}


- (IBAction)sizeOfPointsFromUser:(id)sender
{
    double lSize = (double) [sender indexOfSelectedItem];
    if (lSize != -1) {
        [drawingZone setSizeOfPointsToDraw:(lSize+1.0)];
    }

    [drawingZone setNeedsDisplay:YES];
}

- (IBAction)colorOfPointsFromUser:(id)sender
{
    NSColor* lPointsColor = [sender color];

    [drawingZone setColor:[lPointsColor redComponent] atIndex:0];
    [drawingZone setColor:[lPointsColor greenComponent] atIndex:1];
    [drawingZone setColor:[lPointsColor blueComponent] atIndex:2];
    [drawingZone setColor:[lPointsColor alphaComponent] atIndex:3];

    [drawingZone setFirstTimePts:NO];
    [drawingZone setNeedsDisplay:YES];
}

- (IBAction)colorOfSegmentsFromUser:(id)sender
{
    NSColor* lPointsColor = [sender color];

    [drawingZone setColor:[lPointsColor redComponent] atIndex:4];
    [drawingZone setColor:[lPointsColor greenComponent] atIndex:5];
    [drawingZone setColor:[lPointsColor blueComponent] atIndex:6];
    [drawingZone setColor:[lPointsColor alphaComponent] atIndex:7];

    [drawingZone setFirstTimeSegments:NO];
    [drawingZone setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark IB actions: graphs

- (IBAction)boundingBox:(id)sender
{
    // Need at least one point to sort in boundingBoxWithLDC
    if ([allPts nbOfPts]>0) {
        IdxPt2f* lTmpPt1 = [[IdxPt2f alloc] init];
        IdxPt2f* lTmpPt2 = [[IdxPt2f alloc] init];
        IdxPt2f* lTmpPt3 = [[IdxPt2f alloc] init];
        IdxPt2f* lTmpPt4 = [[IdxPt2f alloc] init];

        [allPts boundingBoxWithLDC:lTmpPt1 LUC:lTmpPt2 RUC:lTmpPt3 RDC:lTmpPt4];

        SetOfPt2f* lBoundingBox = [[SetOfPt2f alloc] init];

#ifdef DEBUG
        [lBoundingBox setName:@"app delegate bounding box"];
        NSLog(@"init %@",lBoundingBox.name);
#endif

        [lBoundingBox addPt:lTmpPt1 andUpdateIndex:YES];
        [lBoundingBox addPt:lTmpPt2 andUpdateIndex:YES];
        [lBoundingBox addPt:lTmpPt3 andUpdateIndex:YES];
        [lBoundingBox addPt:lTmpPt4 andUpdateIndex:YES];

        [lTmpPt1 release];
        [lTmpPt2 release];
        [lTmpPt3 release];
        [lTmpPt4 release];

        [drawingZone setBoundingBoxtoDraw:lBoundingBox]; // retain done buy the set
        [lBoundingBox release];
        [drawingZone setDrawBoundingBox:YES];
        [drawingZone setNeedsDisplay:YES];

        [self setCurrentGraphId:1];
    }
}

- (IBAction)PolygonizeMono:(id)sender
{
    NSUInteger lNumberOfPoints = [allPts nbOfPts];

    // Set for specific cases (few points)
    SetOfPt2f* lSpecificCasesSet = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [lSpecificCasesSet setName:@"app delegate specific cases polygonize mono"];
    NSLog(@"init %@",lSpecificCasesSet.name);
#endif

    switch (lNumberOfPoints) {
        case 0:
            // Do nothing
            break;

        case 1:
            // Do nothing
            break;

        case 2:
            // Draw line between the 2 points
            [lSpecificCasesSet addPt:[allPts ptAtIndex:0]  andUpdateIndex:NO];
            [lSpecificCasesSet addPt:[allPts ptAtIndex:1]  andUpdateIndex:NO];

            [drawingZone setPolygonizeMonoToDraw:lSpecificCasesSet];

            // Actualize the view in drawing zone
            [drawingZone setDrawPolygonMono:YES];
            [drawingZone setNeedsDisplay:YES];
            break;

        case 3:
            // Draw the first 2 segments of the triangle (the closing segment is added by the drawing function)
            [lSpecificCasesSet addPt:[allPts ptAtIndex:0]  andUpdateIndex:NO];
            [lSpecificCasesSet addPt:[allPts ptAtIndex:1]  andUpdateIndex:NO];

            [lSpecificCasesSet addPt:[allPts ptAtIndex:1]  andUpdateIndex:NO];
            [lSpecificCasesSet addPt:[allPts ptAtIndex:2]  andUpdateIndex:NO];

            [drawingZone setPolygonizeMonoToDraw:lSpecificCasesSet];

            // Actualize the view in drawing zone
            [drawingZone setDrawPolygonMono:YES];
            [drawingZone setNeedsDisplay:YES];
            break;

        default:
            [drawingZone setPolygonizeMonoToDraw:[allPts polygonizeMono]];
            [drawingZone setDrawPolygonMono:YES];
            [drawingZone setNeedsDisplay:YES];
            break;
    }

    [self setCurrentGraphId:2];

    [lSpecificCasesSet release];
}

- (IBAction)angularSortingFromBottom:(id)sender
{
    NSUInteger lNumberOfPoints = [allPts nbOfPts];

    switch (lNumberOfPoints) {
        case 0:
            // Do nothing
            break;

        case 1:
            // Do nothing
            break;

        default:
            [drawingZone setAngularSortingtoDraw:[allPts sortAngularlyFromBottom]];

            [drawingZone setDrawAngularSortingFromBottom:YES];
            [drawingZone setNeedsDisplay:YES];
            break;
    }

    [self setCurrentGraphId:3];
}

- (IBAction)convexHull:(id)sender
{
    NSUInteger lNumberOfPoints = [allPts nbOfPts];

    // Set for specific cases (few points)
    SetOfPt2f* lSpecificCasesSet = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [lSpecificCasesSet setName:@"app delegate specific cases convex hull"];
    NSLog(@"init %@",lSpecificCasesSet.name);
#endif

    switch (lNumberOfPoints) {
        case 0:
            // Do nothing
            break;

        case 1:
            // Do nothing
            break;

        case 2:
            // Draw line between the 2 points
            [lSpecificCasesSet addPt:[allPts ptAtIndex:0]  andUpdateIndex:NO];
            [lSpecificCasesSet addPt:[allPts ptAtIndex:1]  andUpdateIndex:NO];

            [drawingZone setConvexHullToDraw:lSpecificCasesSet];

            // Actualize the view in drawing zone
            [drawingZone setDrawConvexHull:YES];
            [drawingZone setNeedsDisplay:YES];
            break;

        default:
            [drawingZone setConvexHullToDraw:[allPts convexHull]];

            [drawingZone setDrawConvexHull:YES];
            [drawingZone setNeedsDisplay:YES];
            break;
    }

    [self setCurrentGraphId:4];

    [lSpecificCasesSet release];
}

- (IBAction)angularTriangulation:(id)sender
{
    NSUInteger lNumberOfPoints = [allPts nbOfPts];

    // Set for specific cases (few points)
    SetOfPt2f* lSpecificCasesSet = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [lSpecificCasesSet setName:@"app delegate specific cases angular tri"];
    NSLog(@"init %@",lSpecificCasesSet.name);
#endif

    switch (lNumberOfPoints) {
        case 0:
            // Do nothing
            break;

        case 1:
            // Do nothing
            break;
        case 2:
            // Draw line between the 2 points
            [lSpecificCasesSet addPt:[allPts ptAtIndex:0]  andUpdateIndex:NO];
            [lSpecificCasesSet addPt:[allPts ptAtIndex:1]  andUpdateIndex:NO];

            [drawingZone setAngularTriangulationToDraw:lSpecificCasesSet];

            // Actualize the view in drawing zone
            [drawingZone setDrawAngularTriangulation:YES];
            [drawingZone setNeedsDisplay:YES];
            break;

        default:
            [drawingZone setAngularTriangulationToDraw:[allPts triangularizeAngular]];

            [drawingZone setDrawAngularTriangulation:YES];
            [drawingZone setNeedsDisplay:YES];
            break;
    }

    [self setCurrentGraphId:5];

    [lSpecificCasesSet release];
}

- (IBAction)delaunayTriangulation:(id)sender
{
    NSUInteger lNumberOfPoints = [allPts nbOfPts];

    // Set for specific cases (few points)
    SetOfPt2f* lSpecificCasesSet = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [lSpecificCasesSet setName:@"app delegate specific cases delaunay tri"];
    NSLog(@"init %@",lSpecificCasesSet.name);
#endif

    switch (lNumberOfPoints) {
        case 0:
            // Do nothing
            break;

        case 1:
            // Do nothing
            break;
        case 2:
            // Draw line between the 2 points
            [lSpecificCasesSet addPt:[allPts ptAtIndex:0]  andUpdateIndex:NO];
            [lSpecificCasesSet addPt:[allPts ptAtIndex:1]  andUpdateIndex:NO];

            [drawingZone setPolygonizeMonoToDraw:lSpecificCasesSet];

            // Actualize the view in drawing zone
            [drawingZone setDrawPolygonMono:YES];
            [drawingZone setNeedsDisplay:YES];
            break;

        default:
            [dcel buildDCELFromSetOfPts:allPts];

            [dcel transformToDelaunayTriangulationWithMaxIteration:maxIterationToComputeDelaunay];

            [drawingZone setDrawDelaunayTriangulation:YES];
            [drawingZone setNeedsDisplay:YES];
            break;

    }

    [self setCurrentGraphId:6];

    [lSpecificCasesSet release];
}

- (IBAction)voronoiDiagram:(id)sender
{
    NSUInteger lNumberOfPoints = [allPts nbOfPts];
    double lInfinity = 100000.0;

    // Set for specific cases (few points)
    SetOfPt2f* lSpecificCasesSet = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [lSpecificCasesSet setName:@"app delegate specific cases voronoi dia"];
    NSLog(@"init %@",lSpecificCasesSet.name);
#endif

    IdxPt2f* lMiddlePt1   = [[IdxPt2f alloc] init];
    IdxPt2f* lMiddlePt2   = [[IdxPt2f alloc] init];
    IdxPt2f* lMiddlePt3   = [[IdxPt2f alloc] init];
    IdxPt2f* lCenter      = [[IdxPt2f alloc] init];

    IdxPt2f* lSegmentPt11 = [[IdxPt2f alloc] init];
    IdxPt2f* lSegmentPt12 = [[IdxPt2f alloc] init];
    IdxPt2f* lSegmentPt21 = [[IdxPt2f alloc] init];
    IdxPt2f* lSegmentPt22 = [[IdxPt2f alloc] init];

    Vec2f* lTranslation = [[Vec2f alloc] init];

    switch (lNumberOfPoints) {
        case 0:
            // Do nothing
            break;

        case 1:
            // Do nothing
            break;
        case 2:
            // Calculate middle point
            [lMiddlePt1 setWithX:(([[allPts ptAtIndex:0] x] + [[allPts ptAtIndex:1] x])/2.0) Y:(([[allPts ptAtIndex:0] y] + [[allPts ptAtIndex:1] y])/2.0)];

            // Calculate translation vector (orthogonal to segment joining 2 points in the set)
            [lTranslation setWithX:([[allPts ptAtIndex:0] y] - [[allPts ptAtIndex:1] y]) Y:([[allPts ptAtIndex:1] x] - [[allPts ptAtIndex:0] x])];

            // First point of the Voronoi line (at the infinite)
            [lTranslation multiplyByScalar:lInfinity];
            [lMiddlePt1 translateWithVector:lTranslation];
            [lSegmentPt11 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

            // Second point (translate twice the first translation in opposite direction to compensate first translation
            [lTranslation multiplyByScalar:(-2.0)];
            [lMiddlePt1 translateWithVector:lTranslation];
            [lSegmentPt12 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

            [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
            [lSpecificCasesSet addPt:lSegmentPt12  andUpdateIndex:NO];

            [drawingZone setVoronoiDiagramToDraw:lSpecificCasesSet];

            // Actualize the view in drawing zone
            [drawingZone setDrawVoronoiDiagram:YES];
            [drawingZone setNeedsDisplay:YES];
            break;

            case 3:
            if ([allPts orientationOfPtA:0 PtB:1 andPtC:2] == 0) {
                // Calculate first middle point
                [lMiddlePt1 setWithX:(([[allPts ptAtIndex:0] x] + [[allPts ptAtIndex:1] x])/2.0) Y:(([[allPts ptAtIndex:0] y] + [[allPts ptAtIndex:1] y])/2.0)];

                // Calculate second middle point
                [lMiddlePt2 setWithX:(([[allPts ptAtIndex:1] x] + [[allPts ptAtIndex:2] x])/2.0) Y:(([[allPts ptAtIndex:1] y] + [[allPts ptAtIndex:2] y])/2.0)];

                // Calculate translation vector (orthogonal to segment joining 2 points in the set)
                [lTranslation setWithX:([[allPts ptAtIndex:0] y] - [[allPts ptAtIndex:1] y]) Y:([[allPts ptAtIndex:1] x] - [[allPts ptAtIndex:0] x])];

                // First point of the Voronoi line (at the infinite)
                [lTranslation multiplyByScalar:lInfinity];
                [lMiddlePt1 translateWithVector:lTranslation];
                [lSegmentPt11 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

                // First point of the second segment
                [lMiddlePt2 translateWithVector:lTranslation];
                [lSegmentPt12 setWithX:[lMiddlePt2 x] Y:[lMiddlePt2 y]];

                // Second point (translate twice the first translation in opposite direction to compensate first translation
                [lTranslation multiplyByScalar:(-2.0)];
                [lMiddlePt1 translateWithVector:lTranslation];
                [lSegmentPt12 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

                // Second point of the second segment
                [lMiddlePt2 translateWithVector:lTranslation];
                [lSegmentPt22 setWithX:[lMiddlePt2 x] Y:[lMiddlePt2 y]];

                // Add segments to the list
                [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
                [lSpecificCasesSet addPt:lSegmentPt12  andUpdateIndex:NO];
                [lSpecificCasesSet addPt:lSegmentPt21  andUpdateIndex:NO];
                [lSpecificCasesSet addPt:lSegmentPt22  andUpdateIndex:NO];

                [drawingZone setPolygonizeMonoToDraw:lSpecificCasesSet];

                // Actualize the view in drawing zone
                [drawingZone setDrawPolygonMono:YES];
                [drawingZone setNeedsDisplay:YES];
            } else {
                // Calculate the circumcircle
                double lAx = [[allPts ptAtIndex:0] x];
                double lAy = [[allPts ptAtIndex:0] y];

                double lBx = [[allPts ptAtIndex:1] x];
                double lBy = [[allPts ptAtIndex:1] y];

                double lCx = [[allPts ptAtIndex:2] x];
                double lCy = [[allPts ptAtIndex:2] y];

                // Calculate the center
                double lMa = (lBy - lAy)/(lBx - lAx);
                double lMb = (lCy - lBy)/(lCx - lBx);
                double lX = ((lMa*lMb*(lAy - lCy) + lMb*(lAx + lBx) - lMa*(lBx + lCx))/(2*(lMb - lMa)));
                double lY = (((lAx + lBx)/2.0 - lX)/lMa + (lAy + lBy)/2.0);

                [lCenter setWithX:lX Y:lY];

                // Add center to the list of point to be able to use its functionalities
                [allPts addPt:lCenter andUpdateIndex:NO];

                [lSegmentPt11 setWithX:[lCenter x] Y:[lCenter y]];


                [lMiddlePt1 setWithX:(([[allPts ptAtIndex:0] x] + [[allPts ptAtIndex:1] x])/2.0) Y:(([[allPts ptAtIndex:0] y] + [[allPts ptAtIndex:1] y])/2.0)];
                [lMiddlePt2 setWithX:(([[allPts ptAtIndex:1] x] + [[allPts ptAtIndex:2] x])/2.0) Y:(([[allPts ptAtIndex:1] y] + [[allPts ptAtIndex:2] y])/2.0)];
                [lMiddlePt3 setWithX:(([[allPts ptAtIndex:2] x] + [[allPts ptAtIndex:0] x])/2.0) Y:(([[allPts ptAtIndex:2] y] + [[allPts ptAtIndex:0] y])/2.0)];

                // if circumcircle is inside triangle
                if ([allPts isPtA:3 InTriangleBCDWithPtB:0 PtC:1 andPtD:2]) {
                    // Calculate first half line
                    [lTranslation setWithX:([lMiddlePt1 x] - [lCenter x]) Y:([lMiddlePt1 y] - [lCenter y])];
                    [lTranslation multiplyByScalar:lInfinity];
                    [lMiddlePt1 translateWithVector:lTranslation];
                    [lSegmentPt12 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

                    // Calculate second half line
                    [lTranslation setWithX:([lMiddlePt2 x] - [lCenter x]) Y:([lMiddlePt2 y] - [lCenter y])];
                    [lTranslation multiplyByScalar:lInfinity];
                    [lMiddlePt2 translateWithVector:lTranslation];
                    [lSegmentPt21 setWithX:[lMiddlePt2 x] Y:[lMiddlePt2 y]];


                    // Calculate third half line
                    [lTranslation setWithX:([lMiddlePt3 x] - [lCenter x]) Y:([lMiddlePt3 y] - [lCenter y])];
                    [lTranslation multiplyByScalar:lInfinity];
                    [lMiddlePt3 translateWithVector:lTranslation];
                    [lSegmentPt22 setWithX:[lMiddlePt3 x] Y:[lMiddlePt3 y]];

                    // add segments to the list
                    [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt12  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt21  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt22  andUpdateIndex:NO];

                } else { // if circumcircle outside triangle

                    double lSquareDist1 = ([lCenter x] - [lMiddlePt1 x])*([lCenter x] - [lMiddlePt1 x]) + ([lCenter y] - [lMiddlePt1 y])*([lCenter y] - [lMiddlePt1 y]);
                    double lSquareDist2 = ([lCenter x] - [lMiddlePt2 x])*([lCenter x] - [lMiddlePt2 x]) + ([lCenter y] - [lMiddlePt2 y])*([lCenter y] - [lMiddlePt2 y]);
                    double lSquareDist3 = ([lCenter x] - [lMiddlePt3 x])*([lCenter x] - [lMiddlePt3 x]) + ([lCenter y] - [lMiddlePt3 y])*([lCenter y] - [lMiddlePt3 y]);

                    if ((lSquareDist1 < lSquareDist2) && (lSquareDist1 < lSquareDist3)) {
                        // Calculate first half line
                        [lTranslation setWithX:([lMiddlePt1 x] - [lCenter x]) Y:([lMiddlePt1 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:((-1)*lInfinity)];
                        [lMiddlePt1 translateWithVector:lTranslation];
                        [lSegmentPt12 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

                        // Calculate second half line
                        [lTranslation setWithX:([lMiddlePt2 x] - [lCenter x]) Y:([lMiddlePt2 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:lInfinity];
                        [lMiddlePt2 translateWithVector:lTranslation];
                        [lSegmentPt21 setWithX:[lMiddlePt2 x] Y:[lMiddlePt2 y]];

                        // Calculate third half line
                        [lTranslation setWithX:([lMiddlePt3 x] - [lCenter x]) Y:([lMiddlePt3 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:lInfinity];
                        [lMiddlePt3 translateWithVector:lTranslation];
                        [lSegmentPt22 setWithX:[lMiddlePt3 x] Y:[lMiddlePt3 y]];

                    } else if ((lSquareDist2 < lSquareDist1) && (lSquareDist2 < lSquareDist3)) {
                        // Calculate first half line
                        [lTranslation setWithX:([lMiddlePt1 x] - [lCenter x]) Y:([lMiddlePt1 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:lInfinity];
                        [lMiddlePt1 translateWithVector:lTranslation];
                        [lSegmentPt12 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

                        // Calculate second half line
                        [lTranslation setWithX:([lMiddlePt2 x] - [lCenter x]) Y:([lMiddlePt2 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:((-1)*lInfinity)];
                        [lMiddlePt2 translateWithVector:lTranslation];
                        [lSegmentPt21 setWithX:[lMiddlePt2 x] Y:[lMiddlePt2 y]];

                        // Calculate third half line
                        [lTranslation setWithX:([lMiddlePt3 x] - [lCenter x]) Y:([lMiddlePt3 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:lInfinity];
                        [lMiddlePt3 translateWithVector:lTranslation];
                        [lSegmentPt22 setWithX:[lMiddlePt3 x] Y:[lMiddlePt3 y]];

                    } else if ((lSquareDist3 < lSquareDist1) && (lSquareDist3 < lSquareDist2)) {
                        // Calculate first half line
                        [lTranslation setWithX:([lMiddlePt1 x] - [lCenter x]) Y:([lMiddlePt1 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:lInfinity];
                        [lMiddlePt1 translateWithVector:lTranslation];
                        [lSegmentPt12 setWithX:[lMiddlePt1 x] Y:[lMiddlePt1 y]];

                        // Calculate second half line
                        [lTranslation setWithX:([lMiddlePt2 x] - [lCenter x]) Y:([lMiddlePt2 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:lInfinity];
                        [lMiddlePt2 translateWithVector:lTranslation];
                        [lSegmentPt21 setWithX:[lMiddlePt2 x] Y:[lMiddlePt2 y]];

                        // Calculate third half line
                        [lTranslation setWithX:([lMiddlePt3 x] - [lCenter x]) Y:([lMiddlePt3 y] - [lCenter y])];
                        [lTranslation multiplyByScalar:((-1)*lInfinity)];
                        [lMiddlePt3 translateWithVector:lTranslation];
                        [lSegmentPt22 setWithX:[lMiddlePt3 x] Y:[lMiddlePt3 y]];
                    }

                    // add segments to the list
                    [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt12  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt21  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt11  andUpdateIndex:NO];
                    [lSpecificCasesSet addPt:lSegmentPt22  andUpdateIndex:NO];
                }

                // Remove the center from the list of point
                [allPts removeLastPt];

            }

            [drawingZone setVoronoiDiagramToDraw:lSpecificCasesSet];

            // Actualize the view in drawing zone
            [drawingZone setDrawVoronoiDiagram:YES];
            [drawingZone setNeedsDisplay:YES];

            break;

        default:
            [dcel buildDCELFromSetOfPts:allPts];

            [dcel transformToDelaunayTriangulationWithMaxIteration:maxIterationToComputeDelaunay];

            [drawingZone setVoronoiDiagramToDraw:[dcel voronoiFromDelaunayTriangulation]];

            [drawingZone setDrawVoronoiDiagram:YES];
            [drawingZone setNeedsDisplay:YES];
            break;
    }

    [self setCurrentGraphId:7];

    [lSegmentPt22 release];
    [lSegmentPt21 release];
    [lSegmentPt12 release];
    [lSegmentPt11 release];
    [lCenter release];
    [lMiddlePt3 release];
    [lMiddlePt2 release];
    [lMiddlePt1 release];
    [lTranslation release];
    [lSpecificCasesSet release];
}

@end
