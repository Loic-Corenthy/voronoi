#import "DrawingZone.h"
#import "SetOfPt2f.h"
#import "Vertex.h"
#import "Face.h"
#import "HalfEdge.h"
#import "DCEL.h"



@implementation DrawingZone

#pragma mark -
#pragma mark Properties: pointers on data to be drawn

@synthesize ptsToDraw;
@synthesize segmentsToDraw;
@synthesize dataFromDCEL;
@synthesize boundingBoxtoDraw;
@synthesize polygonizeMonoToDraw;
@synthesize angularSortingtoDraw;
@synthesize convexHullToDraw;
@synthesize angularTriangulationToDraw;
@synthesize delaunayTriangulationToDraw;
@synthesize voronoiDiagramToDraw;

#pragma mark -
#pragma mark Properties

@synthesize pointerOnAppDelegate;
@synthesize totalNumberOfPointsBis;
@synthesize sizeOfPointsToDraw;
@synthesize firstTimePts;
@synthesize firstTimeSegments;

#pragma mark -
#pragma mark Properties: active draw in drawRect

@synthesize drawPts;
@synthesize drawBoundingBox;
@synthesize drawPolygonMono;
@synthesize drawAngularSortingFromBottom;
@synthesize drawConvexHull;
@synthesize drawAngularTriangulation;
@synthesize drawDelaunayTriangulation;
@synthesize drawVoronoiDiagram;

#pragma mark -
#pragma mark Basic methods

- (id) initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        ptsToDraw                   = nil;
        segmentsToDraw              = nil;
        boundingBoxtoDraw           = nil;
        polygonizeMonoToDraw        = nil;
        angularSortingtoDraw        = nil;
        convexHullToDraw            = nil;
        angularTriangulationToDraw  = nil;
        delaunayTriangulationToDraw = nil;
        voronoiDiagramToDraw        = nil;

        dataFromDCEL                = nil;

        totalNumberOfPointsBis      = nil;
        sizeOfPointsToDraw          = 1.0;

        for (unsigned int i = 0; i < 8; i++) {
            pointAndSegmentColors[i] = 0.0;
        }
        firstTimePts        = YES;
        firstTimeSegments   = YES;

        drawPts                         = NO;
        drawBoundingBox                 = NO;
        drawPolygonMono                 = NO;
        drawAngularSortingFromBottom    = NO;
        drawConvexHull                  = NO;
        drawAngularTriangulation        = NO;
        drawDelaunayTriangulation       = NO;
        drawVoronoiDiagram              = NO;
    }

    return self;
}

- (void) dealloc
{
    [self setPtsToDraw:nil];
    [self setSegmentsToDraw:nil];
    [self setBoundingBoxtoDraw:nil];
    [self setPolygonizeMonoToDraw:nil];
    [self setAngularSortingtoDraw:nil];
    [self setAngularTriangulationToDraw:nil];
    [self setConvexHullToDraw:nil];
    [self setDelaunayTriangulationToDraw:nil];
    [self setVoronoiDiagramToDraw:nil];

    [self setDataFromDCEL:nil];
    [self setTotalNumberOfPointsBis:nil];

    [super dealloc];
}

#pragma mark -
#pragma mark Drawing "callback"

- (void) drawRect:(NSRect)dirtyRect
{
    double lXTranslation = self.frame.size.width/(2.0);
    double lYTranslation = self.frame.size.height/(2.0);


    if (drawPts) {
        // Set points color WARNING !!! Why do I have to do the first time case???

        if ( firstTimePts) {
            [[NSColor blackColor] setStroke];
        } else {
            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[0])   green:(pointAndSegmentColors[1]) blue:(pointAndSegmentColors[2]) alpha:(pointAndSegmentColors[3])] setStroke];

            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[0])   green:(pointAndSegmentColors[1]) blue:(pointAndSegmentColors[2]) alpha:(pointAndSegmentColors[3])] setFill];

        }

        NSUInteger lNbOfPtsToDraw = [ptsToDraw nbOfPts];
        for (NSUInteger i = 0; i < lNbOfPtsToDraw; i++)
        {
            NSRect lTmpRect = NSMakeRect( [[ptsToDraw ptAtIndex:i] x] + lXTranslation - sizeOfPointsToDraw, [[ptsToDraw ptAtIndex:i] y] + lYTranslation - sizeOfPointsToDraw, 2*sizeOfPointsToDraw+1.0, 2*sizeOfPointsToDraw+1.0);

            NSBezierPath* thePath = [NSBezierPath bezierPath];
            [thePath appendBezierPathWithOvalInRect:lTmpRect];
            [thePath fill];
            [thePath stroke];
        }
    }

    if (drawBoundingBox) {
        if ( firstTimeSegments) {
            [[NSColor blackColor] setStroke];
        } else {
            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[4])   green:(pointAndSegmentColors[5]) blue:(pointAndSegmentColors[6]) alpha:(pointAndSegmentColors[7])] setStroke];
        }

        NSPoint lLDC = NSMakePoint([[boundingBoxtoDraw ptAtIndex:0] x] + lXTranslation, [[boundingBoxtoDraw ptAtIndex:0] y] + lYTranslation);
        NSPoint lLUC = NSMakePoint([[boundingBoxtoDraw ptAtIndex:1] x] + lXTranslation, [[boundingBoxtoDraw ptAtIndex:1] y] + lYTranslation);
        NSPoint lRUC = NSMakePoint([[boundingBoxtoDraw ptAtIndex:2] x] + lXTranslation, [[boundingBoxtoDraw ptAtIndex:2] y] + lYTranslation);
        NSPoint lRDC = NSMakePoint([[boundingBoxtoDraw ptAtIndex:3] x] + lXTranslation, [[boundingBoxtoDraw ptAtIndex:3] y] + lYTranslation);

        NSBezierPath* lPath1 = [NSBezierPath bezierPath];
        [lPath1 moveToPoint:lLDC];
        [lPath1 lineToPoint:lLUC];
        [lPath1 closePath];
        [lPath1 stroke];

        NSBezierPath* lPath2 = [NSBezierPath bezierPath];
        [lPath2 moveToPoint:lLUC];
        [lPath2 lineToPoint:lRUC];
        [lPath2 closePath];
        [lPath2 stroke];

        NSBezierPath* lPath3 = [NSBezierPath bezierPath];
        [lPath3 moveToPoint:lRUC];
        [lPath3 lineToPoint:lRDC];
        [lPath3 closePath];
        [lPath3 stroke];

        NSBezierPath* lPath4 = [NSBezierPath bezierPath];
        [lPath4 moveToPoint:lRDC];
        [lPath4 lineToPoint:lLDC];
        [lPath4 closePath];
        [lPath4 stroke];

        [boundingBoxtoDraw removeAllPts];
        [self setBoundingBoxtoDraw:nil];

    }

    if (drawPolygonMono) {
        if (  firstTimeSegments) {
            [[NSColor blackColor] setStroke];
        } else {
            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[4])   green:(pointAndSegmentColors[5]) blue:(pointAndSegmentColors[6]) alpha:(pointAndSegmentColors[7])] setStroke];
        }

        for (NSUInteger i = 0; i < ([polygonizeMonoToDraw nbOfPts] - 1); i++) {

            NSPoint lBegin = NSMakePoint([[polygonizeMonoToDraw ptAtIndex:i] x] + lXTranslation, [[polygonizeMonoToDraw ptAtIndex:i] y] + lYTranslation);
            NSPoint lEnd = NSMakePoint([[polygonizeMonoToDraw ptAtIndex:(i+1)] x] + lXTranslation, [[polygonizeMonoToDraw ptAtIndex:(i+1)] y] + lYTranslation);

            NSBezierPath* lPath= [NSBezierPath bezierPath];
            [lPath moveToPoint:lBegin];
            [lPath lineToPoint:lEnd];
            [lPath closePath];
            [lPath stroke];
        }

        // Close the polygon
        NSPoint lBegin = NSMakePoint([[polygonizeMonoToDraw ptAtIndex:([polygonizeMonoToDraw nbOfPts]-1)] x] + lXTranslation, [[polygonizeMonoToDraw ptAtIndex:([polygonizeMonoToDraw nbOfPts]-1)] y] + lYTranslation);
        NSPoint lEnd = NSMakePoint([[polygonizeMonoToDraw ptAtIndex:0] x] + lXTranslation, [[polygonizeMonoToDraw ptAtIndex:0] y] + lYTranslation);

        NSBezierPath* lPath= [NSBezierPath bezierPath];
        [lPath moveToPoint:lBegin];
        [lPath lineToPoint:lEnd];
        [lPath closePath];
        [lPath stroke];

        [polygonizeMonoToDraw removeAllPts];

        // When setting the value to nil, a release is sent to polygonizeMonoToDraw
        [self setPolygonizeMonoToDraw:nil];
        [self setDrawPolygonMono:NO];

    }

    if (drawConvexHull) {
        if (  firstTimeSegments) {
            [[NSColor blackColor] setStroke];
        } else {
            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[4])   green:(pointAndSegmentColors[5]) blue:(pointAndSegmentColors[6]) alpha:(pointAndSegmentColors[7])] setStroke];
        }


        for (NSUInteger i = 0; i < ([convexHullToDraw nbOfPts] - 1); i++) {

            NSPoint lBegin = NSMakePoint([[convexHullToDraw ptAtIndex:i] x] + lXTranslation, [[convexHullToDraw ptAtIndex:i] y] + lYTranslation);
            NSPoint lEnd = NSMakePoint([[convexHullToDraw ptAtIndex:(i+1)] x] + lXTranslation, [[convexHullToDraw ptAtIndex:(i+1)] y] + lYTranslation);

            NSBezierPath* lPath= [NSBezierPath bezierPath];
            [lPath moveToPoint:lBegin];
            [lPath lineToPoint:lEnd];
            [lPath closePath];
            [lPath stroke];
        }

        // Close the polygon
        NSPoint lBegin = NSMakePoint([[convexHullToDraw ptAtIndex:([convexHullToDraw nbOfPts]-1)] x] + lXTranslation, [[convexHullToDraw ptAtIndex:([convexHullToDraw nbOfPts]-1)] y] + lYTranslation);
        NSPoint lEnd = NSMakePoint([[convexHullToDraw ptAtIndex:0] x] + lXTranslation, [[convexHullToDraw ptAtIndex:0] y] + lYTranslation);

        NSBezierPath* lPath= [NSBezierPath bezierPath];
        [lPath moveToPoint:lBegin];
        [lPath lineToPoint:lEnd];
        [lPath closePath];
        [lPath stroke];

        [convexHullToDraw removeAllPts];


        [self setConvexHullToDraw:nil];
        [self setDrawConvexHull:NO];
    }

    if (drawAngularSortingFromBottom) {
        if (  firstTimeSegments) {
            [[NSColor blackColor] setStroke];
        } else {
            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[4])   green:(pointAndSegmentColors[5]) blue:(pointAndSegmentColors[6]) alpha:(pointAndSegmentColors[7])] setStroke];
        }


        NSPoint lBegin = NSMakePoint([[angularSortingtoDraw ptAtIndex:0] x] + lXTranslation, [[angularSortingtoDraw ptAtIndex:0] y] + lYTranslation);
        for (NSUInteger i = 1; i < ([angularSortingtoDraw nbOfPts]); i++) {

            NSPoint lEnd = NSMakePoint([[angularSortingtoDraw ptAtIndex:(i)] x] + lXTranslation, [[angularSortingtoDraw ptAtIndex:(i)] y] + lYTranslation);
            NSBezierPath* lPath= [NSBezierPath bezierPath];
            [lPath moveToPoint:lBegin];
            [lPath lineToPoint:lEnd];
            [lPath closePath];
            [lPath stroke];
        }

        [angularSortingtoDraw removeAllPts];

        [self setAngularSortingtoDraw:nil];
        [self setDrawAngularSortingFromBottom:NO];
    }


    if (drawAngularTriangulation) {
        if (  firstTimeSegments) {
            [[NSColor blackColor] setStroke];
        } else {
            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[4])   green:(pointAndSegmentColors[5]) blue:(pointAndSegmentColors[6]) alpha:(pointAndSegmentColors[7])] setStroke];
        }


        for (NSUInteger i = 0; i < ([angularTriangulationToDraw nbOfPts] - 1); i+=2) {

            NSPoint lBegin = NSMakePoint([[angularTriangulationToDraw ptAtIndex:i] x] + lXTranslation, [[angularTriangulationToDraw ptAtIndex:i] y] + lYTranslation);
            NSPoint lEnd = NSMakePoint([[angularTriangulationToDraw ptAtIndex:(i+1)] x] + lXTranslation, [[angularTriangulationToDraw ptAtIndex:(i+1)] y] + lYTranslation);
            NSBezierPath* lPath= [NSBezierPath bezierPath];
            [lPath moveToPoint:lBegin];
            [lPath lineToPoint:lEnd];
            [lPath closePath];
            [lPath stroke];
        }

        [angularTriangulationToDraw removeAllPts];
        [self setAngularTriangulationToDraw:nil];
        [self setDrawAngularTriangulation:NO];
    }

    if (drawDelaunayTriangulation) {
        if (  firstTimeSegments) {
            [[NSColor blackColor] setStroke];
        } else {
            [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[4])   green:(pointAndSegmentColors[5]) blue:(pointAndSegmentColors[6]) alpha:(pointAndSegmentColors[7])] setStroke];
        }

        Face* lF = nil;
        HalfEdge* lHE = nil;
        Vertex* lVBegin = nil;
        Vertex* lVEnd = nil;
        NSInteger lTmpHE = 0;

        for (NSUInteger i = 1; i < [dataFromDCEL numberOfFaces]; i++) {
            lF = [dataFromDCEL faceFromId:i];
            lTmpHE = [lF outCmpId];

            for (NSUInteger j = 0; j<3; j++) {
                // Draw one segment
                lHE = [dataFromDCEL halfEdgeFromId:lTmpHE];

                lVBegin = [dataFromDCEL vertexFromId:[lHE originId]];
                lVEnd = [dataFromDCEL vertexFromId:[[dataFromDCEL halfEdgeFromId:[lHE twinId]] originId]];

                NSPoint lBegin = NSMakePoint([[lVBegin coordinates] x] + lXTranslation, [[lVBegin coordinates] y] + lYTranslation);
                NSPoint lEnd = NSMakePoint([[lVEnd coordinates] x] + lXTranslation, [[lVEnd coordinates] y] + lYTranslation);
                NSBezierPath* lPath= [NSBezierPath bezierPath];
                [lPath moveToPoint:lBegin];
                [lPath lineToPoint:lEnd];
                [lPath closePath];
                [lPath stroke];

                lTmpHE = [lHE nextId];
            }

            BOOL displayCircumcicles = NO;
            if (displayCircumcicles) {
                // Create our circle path
                double lCenterX = [[[[dataFromDCEL arrayOfFaces] objectAtIndex:i] circumcircle] x];
                double lCenterY = [[[[dataFromDCEL arrayOfFaces] objectAtIndex:i] circumcircle] y];
                double lRadius  = [[[[dataFromDCEL arrayOfFaces] objectAtIndex:i] circumcircle] parameter];

                NSRect rect = NSMakeRect(lCenterX + lXTranslation - lRadius, lCenterY + lYTranslation - lRadius, 2.0*lRadius , 2.0*lRadius);
                NSBezierPath* circlePath = [NSBezierPath bezierPath];
                [circlePath appendBezierPathWithOvalInRect: rect];

                // Outline and fill the path
                [circlePath stroke];
            }

        }


        [dataFromDCEL reset];
        [self setDrawDelaunayTriangulation:NO];
    }

    if (drawVoronoiDiagram) {
        if (  firstTimeSegments) {
            [[NSColor blackColor] setStroke];
        } else {
             [[NSColor colorWithCalibratedRed:(pointAndSegmentColors[4])   green:(pointAndSegmentColors[5]) blue:(pointAndSegmentColors[6]) alpha:(pointAndSegmentColors[7])] setStroke];
        }


        for (NSUInteger i = 0; i < ([voronoiDiagramToDraw nbOfPts] - 1); i+=2) {

            NSPoint lBegin = NSMakePoint([[voronoiDiagramToDraw ptAtIndex:i] x] + lXTranslation, [[voronoiDiagramToDraw ptAtIndex:i] y] + lYTranslation);
            NSPoint lEnd = NSMakePoint([[voronoiDiagramToDraw ptAtIndex:(i+1)] x] + lXTranslation, [[voronoiDiagramToDraw ptAtIndex:(i+1)] y] + lYTranslation);
            NSBezierPath* lPath= [NSBezierPath bezierPath];
            [lPath moveToPoint:lBegin];
            [lPath lineToPoint:lEnd];
            [lPath closePath];
            [lPath stroke];
        }


        [voronoiDiagramToDraw removeAllPts];

        [self setVoronoiDiagramToDraw:nil];
        [dataFromDCEL reset];
        [self setDrawVoronoiDiagram:NO];
    }

}

#pragma mark -
#pragma mark Functionality methods

- (BOOL) acceptsFirstResponder
{
    return YES;
}

- (void) mouseDown:(NSEvent *)theEvent
{
    NSPoint lEventLocation = [theEvent locationInWindow];
    NSPoint lCenter = [self convertPoint:lEventLocation fromView:nil];

    double lDrawingZoneWidth = (double) self.frame.size.width;
    double lDrawingZoneHeight = (double) self.frame.size.height;

    IdxPt2f* lTmpPt = [[IdxPt2f alloc] init];
    [lTmpPt setWithX:(lCenter.x - lDrawingZoneWidth/2.0) Y:(lCenter.y - lDrawingZoneHeight/2.0)];

    [ptsToDraw addPt:lTmpPt andUpdateIndex:YES];

    [lTmpPt release];

    [self setDrawPts:YES];

    // redraw last graph if not too many points
    if ([ptsToDraw nbOfPts] < 1000 && [pointerOnAppDelegate autoRedraw]) {
        [pointerOnAppDelegate recalculateGraph];
        [self redrawActiveGraph:[pointerOnAppDelegate currentGraphId]];
    }

    [self setNeedsDisplay:YES];

    // Update count display
    [totalNumberOfPointsBis setStringValue:[NSString stringWithFormat:@"%lu",[ptsToDraw nbOfPts]]];

}

- (void)setColor:(double)pColorValue atIndex:(unsigned int)pIndex
{
    NSAssert(0 <= pIndex && pIndex <= 8,@"Index out of bounds");

    pointAndSegmentColors[pIndex] = pColorValue;
}

- (void)redrawActiveGraph:(char)pGraphId
{
    switch (pGraphId) {
        case 1:
            drawBoundingBox                 = YES;
            drawPolygonMono                 = NO;
            drawAngularSortingFromBottom    = NO;
            drawConvexHull                  = NO;
            drawAngularTriangulation        = NO;
            drawDelaunayTriangulation       = NO;
            drawVoronoiDiagram              = NO;
            break;

        case 2:
            drawBoundingBox                 = NO;
            drawPolygonMono                 = YES;
            drawAngularSortingFromBottom    = NO;
            drawConvexHull                  = NO;
            drawAngularTriangulation        = NO;
            drawDelaunayTriangulation       = NO;
            drawVoronoiDiagram              = NO;
            break;

        case 3:
            drawBoundingBox                 = NO;
            drawPolygonMono                 = NO;
            drawAngularSortingFromBottom    = YES;
            drawConvexHull                  = NO;
            drawAngularTriangulation        = NO;
            drawDelaunayTriangulation       = NO;
            drawVoronoiDiagram              = NO;
            break;

        case 4:
            drawBoundingBox                 = NO;
            drawPolygonMono                 = NO;
            drawAngularSortingFromBottom    = NO;
            drawConvexHull                  = YES;
            drawAngularTriangulation        = NO;
            drawDelaunayTriangulation       = NO;
            drawVoronoiDiagram              = NO;
            break;

        case 5:
            drawBoundingBox                 = NO;
            drawPolygonMono                 = NO;
            drawAngularSortingFromBottom    = NO;
            drawConvexHull                  = NO;
            drawAngularTriangulation        = YES;
            drawDelaunayTriangulation       = NO;
            drawVoronoiDiagram              = NO;
            break;

        case 6:
            drawBoundingBox                 = NO;
            drawPolygonMono                 = NO;
            drawAngularSortingFromBottom    = NO;
            drawConvexHull                  = NO;
            drawAngularTriangulation        = NO;
            drawDelaunayTriangulation       = YES;
            drawVoronoiDiagram              = NO;
            break;

        case 7:
            drawBoundingBox                 = NO;
            drawPolygonMono                 = NO;
            drawAngularSortingFromBottom    = NO;
            drawConvexHull                  = NO;
            drawAngularTriangulation        = NO;
            drawDelaunayTriangulation       = NO;
            drawVoronoiDiagram              = YES;
            break;

        case 0:
        default:
            drawBoundingBox                 = NO;
            drawPolygonMono                 = NO;
            drawAngularSortingFromBottom    = NO;
            drawConvexHull                  = NO;
            drawAngularTriangulation        = NO;
            drawDelaunayTriangulation       = NO;
            drawVoronoiDiagram              = NO;
            break;

    }
}

@end
