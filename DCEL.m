#import "DCEL.h"
#import "IdxPt2f.h"
#import "SetOfPt2f.h"
#import "Vertex.h"
#import "Face.h"
#import "HalfEdge.h"


@interface DCEL () // Anonymous category for "kind of private" methods

/// Create all the triangles related to the bottom point
- (void) firstPhaseWith:(SetOfPt2f*)pAngularlySortedSet;

/// Orientation of 3 points
- (int) orientationOfRandomPtA:(IdxPt2f*)pPt1 PtB:(IdxPt2f*)pPt2 andPtC:(IdxPt2f*)pPt3;

/// Create all the other ones
- (void) addExternalFaces;

@end

@implementation DCEL

#pragma mark -
#pragma mark Properties

@synthesize arrayOfVertices;
@synthesize arrayOfFaces;
@synthesize arrayOfHalfEdges;
@synthesize numberOfVertices;
@synthesize numberOfFaces;
@synthesize numberOfHalfEdges;

#pragma mark -
#pragma mark Basic methods

- (id) init
{
    self = [super init];
    if (self) {
        arrayOfVertices = [[NSMutableArray alloc] init];

        Face* lAllPlan = [[Face alloc] init];
        [lAllPlan setFaceId:0];
        [lAllPlan setInCmpId:-1];
        [lAllPlan setOutCmpId:-1];

        arrayOfFaces = [[NSMutableArray alloc] init];
        [arrayOfFaces addObject:lAllPlan];

        [lAllPlan release];

        arrayOfHalfEdges = [[NSMutableArray alloc] init];

        numberOfVertices = 0;
        numberOfFaces = 1;
        numberOfHalfEdges = 0;

    }

    return self;
}


- (void) dealloc
{
    [arrayOfVertices removeAllObjects];
    [arrayOfFaces removeAllObjects];
    [arrayOfHalfEdges removeAllObjects];

    [arrayOfVertices release];
    [arrayOfFaces release];
    [arrayOfHalfEdges release];
    [super dealloc];
}

- (void) reset
{
    // Clear all the previous elements
    [arrayOfVertices removeAllObjects];
    [arrayOfFaces removeAllObjects];
    [arrayOfHalfEdges removeAllObjects];


    // Restore the initial situation: the whole plan
    Face* lAllPlan = [[Face alloc] init];
    [lAllPlan setFaceId:0];
    [lAllPlan setInCmpId:-1];
    [lAllPlan setOutCmpId:-1];

    [arrayOfFaces addObject:lAllPlan];

    [lAllPlan release];

    numberOfVertices = 0;
    numberOfFaces = 1;
    numberOfHalfEdges = 0;
}

#pragma mark -
#pragma mark Interaction with the DCEL

- (void) addVertex:(Vertex *)pV
{
    [arrayOfVertices addObject:pV];
    numberOfVertices++;
}

- (void) addFace:(Face *)pF
{
    [arrayOfFaces addObject:pF];
    numberOfFaces++;
}

- (void) addHalfEdge:(HalfEdge *)pHE
{
    [arrayOfHalfEdges addObject:pHE];
    numberOfHalfEdges++;
}

- (Vertex*) vertexFromId:(NSUInteger)pValue
{
//    NSEnumerator* lEnumerator = [arrayOfVertices objectEnumerator];
//    id lVertex;
//    while (lVertex = [lEnumerator nextObject]) {
//        if ([lVertex vertexId] == pValue) {
//            return lVertex;
//        }
//    }

    return [arrayOfVertices objectAtIndex:pValue];

    NSAssert(false, @"Impossible to arrive here");
    return nil;
}

- (Face*) faceFromId:(NSUInteger)pValue
{
//    NSEnumerator* lEnumerator = [arrayOfFaces objectEnumerator];
//    id lFace;
//    while (lFace = [lEnumerator nextObject]) {
//        if ([lFace faceId] == pValue) {
//            return lFace;
//        }
//    }

    return [arrayOfFaces objectAtIndex:pValue];

    NSAssert(false, @"Impossible to arrive here");
    return nil;
}

- (HalfEdge*) halfEdgeFromId:(NSUInteger)pValue
{
//    NSEnumerator* lEnumerator = [arrayOfHalfEdges objectEnumerator];
//    id lHalfEdge;
//    while (lHalfEdge = [lEnumerator nextObject]) {
//        if ([lHalfEdge halfEdgeId] == pValue) {
//            return lHalfEdge;
//        }
//    }

    return [arrayOfHalfEdges objectAtIndex:pValue];

    NSAssert(false, @"Impossible to arrive here");
    return nil;
}

- (void)flipHalfEdge:(NSUInteger)pHalfEdgeId
{
    // Get the half edge to flip and his twin
    HalfEdge* lHETF = [arrayOfHalfEdges objectAtIndex:pHalfEdgeId]; //Half Edge To Filp
    HalfEdge* lT = [arrayOfHalfEdges objectAtIndex:[lHETF twinId]]; // Twin

    // Get the next and next of next of the two previous half edges
    HalfEdge* lNHETF = [arrayOfHalfEdges objectAtIndex:[lHETF nextId]];     //Next of Half Edge To Filp
	HalfEdge* lNNHETF = [arrayOfHalfEdges objectAtIndex:[lNHETF nextId]];	//Next of Next of Half Edge To Filp
	HalfEdge* lNT = [arrayOfHalfEdges objectAtIndex:[lT nextId]];           //Next of Twin
	HalfEdge* lNNT = [arrayOfHalfEdges objectAtIndex:[lNT nextId]];         //Next of Next ofTwin

    //// Upper face
    // Update the principal half edge
    [lHETF setOriginId:[lNNT originId]];
    [lHETF setPreviousId:[lNT halfEdgeId]];
    [lHETF setNextId:[lNNHETF halfEdgeId]];

    // Update the previous and the next
    [lNNHETF setPreviousId:[lHETF halfEdgeId]];
    [lNT setNextId:[lNNHETF previousId]];
    [lNNHETF setNextId:[lNT halfEdgeId]];
    [lNT setPreviousId:[lNNHETF halfEdgeId]];

    //// Down face
    // Update the twin half edge
    [lT setOriginId:[lNNHETF originId]];
    [lT setPreviousId:[lNHETF halfEdgeId]];
    [lT setNextId:[lNNT halfEdgeId]];

    // Update the previous and the next
    [lNNT setPreviousId:[lT halfEdgeId]];
    [lNHETF setNextId:[lNNT previousId]];
    [lNHETF setPreviousId:[lNNT halfEdgeId]];
    [lNNT setNextId:[lNHETF halfEdgeId]];

    //Update the faces and the vertices
	//The fliped halfedge is pointed into the table of faces
    Face* lTmpFace1 = [self faceFromId:[lHETF incidentFaceId]];
    [lTmpFace1 setOutCmpId:[lHETF halfEdgeId]];
    [lNHETF setIncidentFaceId:[lT incidentFaceId]];

    Face* lTmpFace2 = [self faceFromId:[lT incidentFaceId]];
    [lTmpFace2 setOutCmpId:[lT halfEdgeId]];
    [lNT setIncidentFaceId:[lHETF incidentFaceId]];

    // Update all the vertices
    lNHETF = [arrayOfHalfEdges objectAtIndex:[lHETF nextId]];
	lNNHETF = [arrayOfHalfEdges objectAtIndex:[lNHETF nextId]];
	lNT = [arrayOfHalfEdges objectAtIndex:[lT nextId]];
	lNNT = [arrayOfHalfEdges objectAtIndex:[lNT nextId]];

    Vertex* lTmpVertex1 = [self vertexFromId:[lNHETF originId]];
    [lTmpVertex1 setIncidentEdgeId:[lNHETF halfEdgeId]];

    Vertex* lTmpVertex2 = [self vertexFromId:[lNNHETF originId]];
    [lTmpVertex2 setIncidentEdgeId:[lNNHETF halfEdgeId]];

    Vertex* lTmpVertex3 = [self vertexFromId:[lNT originId]];
    [lTmpVertex3 setIncidentEdgeId:[lNT halfEdgeId]];

    Vertex* lTmpVertex4 = [self vertexFromId:[lNNT originId]];
    [lTmpVertex4 setIncidentEdgeId:[lNNT halfEdgeId]];

    // Fliped edges
    Vertex* lTmpVertex5 = [self vertexFromId:[lHETF originId]];
    [lTmpVertex5 setIncidentEdgeId:[lHETF halfEdgeId]];

    Vertex* lTmpVertex6 = [self vertexFromId:[lT originId]];
    [lTmpVertex6 setIncidentEdgeId:[lT halfEdgeId]];


}

- (void) circumcircleOfFace:(Face *)pF
{
    // Do not take into account the whole plan
    if ([pF faceId] > 0) {
        // Get the coordinates of the vertices of the face
        HalfEdge* lHE1 = [arrayOfHalfEdges objectAtIndex:[pF outCmpId]];
        Vertex* lPtA = [arrayOfVertices objectAtIndex:[lHE1 originId]];
        double lAx = [[lPtA coordinates] x];
        double lAy = [[lPtA coordinates] y];

        HalfEdge* lHE2 = [arrayOfHalfEdges objectAtIndex:[lHE1 nextId]];
        Vertex* lPtB = [arrayOfVertices objectAtIndex:[lHE2 originId]];
        double lBx = [[lPtB coordinates] x];
        double lBy = [[lPtB coordinates] y];

        HalfEdge* lHE3 = [arrayOfHalfEdges objectAtIndex:[lHE2 nextId]];
        Vertex* lPtC = [arrayOfVertices objectAtIndex:[lHE3 originId]];
        double lCx = [[lPtC coordinates] x];
        double lCy = [[lPtC coordinates] y];

        // Calculate the center
        double lMa = (lBy - lAy)/(lBx - lAx);
        double lMb = (lCy - lBy)/(lCx - lBx);
        double lX = ((lMa*lMb*(lAy - lCy) + lMb*(lAx + lBx) - lMa*(lBx + lCx))/(2*(lMb - lMa)));
        double lY = (((lAx + lBx)/2.0 - lX)/lMa + (lAy + lBy)/2.0);

        [pF setCircumcircleCenterWithX:(lX) Y:(lY)];

        // Calculate the radius as the distance between the center and ptA
        double lRadius = sqrt((lX - lBx)*(lX - lBx) + (lY - lBy)*(lY - lBy));
        [pF setCircumcircleRadius:lRadius];

    }

}

- (IdxPt2f*) oppositePointOfHalfEdgeWith:(HalfEdge*)pHE
{
    HalfEdge* lTmpHE = [self halfEdgeFromId:[pHE twinId]];
    lTmpHE = [self halfEdgeFromId:[lTmpHE previousId]];

    IdxPt2f* oppositePt = [[self vertexFromId:[lTmpHE originId]] coordinates];
    return oppositePt;
}

- (NSInteger)isAlreadyInWith:(IdxPt2f *)pPt
{
    NSEnumerator* lEn = [arrayOfVertices objectEnumerator];

    id lV = nil;
    while (lV = [lEn nextObject]) {
        if ([[lV coordinates] x] == [pPt x] && [[lV coordinates] y] == [pPt y]) {
            return [lV vertexId];
        }
    }

    return (-2);
}

- (NSArray*) incidentHalfEdgesOfVertexWith:(Vertex*) pV
{
    NSMutableArray* lResult = [[NSMutableArray alloc] init];

    // The incident edge of the current vertex is in the list
    HalfEdge* lFirstHE = [arrayOfHalfEdges objectAtIndex:[pV incidentEdgeId]];
    [lResult addObject:lFirstHE];
//    [lFirstHE release];

    // Pointer on a half edge for the loop
    HalfEdge* lHE = nil;

    // Initialize to first one
    lHE = lFirstHE;

    BOOL lLoop = YES;
    while (lLoop) {
        // Take the previous
        HalfEdge* lPrevious = [self halfEdgeFromId:[lHE previousId]];

        // Take the twin
        HalfEdge* lTwin = [self halfEdgeFromId:[lPrevious twinId]];

        // Check if it is lFirstHE's twin
        if ([lTwin halfEdgeId] == [lFirstHE halfEdgeId]) {
            lLoop = NO;
        } else {
            // Add to the result
            [lResult addObject:lTwin];
//            [lTwin release];

            // Update the half edge in the loop
            lHE = lTwin;
        }
    }


    NSSortDescriptor* lHalfEdgeIdDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vertexId" ascending:YES];

    NSArray* lDescriptors = [NSArray arrayWithObjects:lHalfEdgeIdDescriptor, nil];
    NSArray* lSortedArray = [lResult sortedArrayUsingDescriptors:lDescriptors];

    [lHalfEdgeIdDescriptor release];
    [lResult removeAllObjects];
    [lResult release];

    return lSortedArray;
}

- (NSArray*) halfEdgesOfFaceWith:(Face*)pF
{
    NSMutableArray* lResult = [[NSMutableArray alloc] init];
    HalfEdge* lFirst = nil;

    if ([pF outCmpId] != -1) {
        // First add the half edge which is the outer component
        lFirst = [arrayOfHalfEdges objectAtIndex:[pF outCmpId]];
        [lResult addObject:lFirst];
    } else if([pF inCmpId] == -1) {
        // First add the half edge which is the inner component
        lFirst = [arrayOfHalfEdges objectAtIndex:[pF inCmpId]];
        [lResult addObject:lFirst];
    } else {
        [lResult release];
        return nil;
    }

    // Initialize half edge for the loop
    HalfEdge* lHE = nil;
    lHE = lFirst;

    BOOL lLoop = YES;
    while (lLoop) {
        // Take the next one
        HalfEdge* lNext = nil;
        lNext = [arrayOfHalfEdges objectAtIndex:[lHE nextId]];

        // Check if it is the first half edge of the face
        if ([lNext halfEdgeId] == [lFirst halfEdgeId]) {
            lLoop = NO;
        } else {
            // Add to result
            [lResult addObject:lNext];

            // Update half edge in the loop
            lHE = lNext;
        }
    }

    NSSortDescriptor* lHalfEdgeIdDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vertexId" ascending:YES];

    NSArray* lDescriptors = [NSArray arrayWithObjects:lHalfEdgeIdDescriptor, nil];
    NSArray* lSortedArray = [lResult sortedArrayUsingDescriptors:lDescriptors];

    [lHalfEdgeIdDescriptor release];
    [lResult removeAllObjects];
    [lResult release];

    return lSortedArray;

}

- (NSMutableArray*) adjacentFacesOfFaceWith:(Face*)pF
{
//    NSMutableArray* lResult = [[NSMutableArray alloc] init];
    NSMutableArray* lResult = [[[NSMutableArray alloc] init] autorelease];

    HalfEdge* lFirst = nil;
    lFirst = [self halfEdgeFromId:[pF outCmpId]];

    // Case of a bounded face only!
    NSAssert([lFirst halfEdgeId] != -1,@"Case not taken into account!");


    HalfEdge* lCurrentHE = nil;
    HalfEdge* lNext = nil;
    HalfEdge* lTwin = nil;
    Face* lCurrentFace = nil;

    // Initialize current half edge
    lCurrentHE = lFirst;

    BOOL lLoop = YES;
    while (lLoop) {
        //Take the twin of the current
        lTwin = [self halfEdgeFromId:[lCurrentHE twinId]];

        // Take the face of the twin
        lCurrentFace = [self faceFromId:[lTwin incidentFaceId]];

        [lResult addObject:lCurrentFace];
        [lCurrentFace release];

        lNext = [self halfEdgeFromId:[lCurrentHE nextId]];

        // Check if it is the first
        if ([lNext halfEdgeId] == [lFirst halfEdgeId]) {
            lLoop = NO;
        } else {
            lCurrentHE = lNext;
        }
    }

    return lResult;

}

- (void) buildDCELFromSetOfPts:(SetOfPt2f *)pAllPts
{
    SetOfPt2f* lSortedAngularlySet = [[pAllPts sortAngularlyFromBottom] retain];

    [self firstPhaseWith:lSortedAngularlySet];
    [self addExternalFaces];

    [lSortedAngularlySet removeAllPts];
    [lSortedAngularlySet release];
}

#pragma mark -
#pragma mark Get specific graph from DCEL

- (void) transformToDelaunayTriangulationWithMaxIteration:(NSUInteger)pMax
{
    NSAssert(pMax > 0, @"Max number of iteration must be positive");

    double lDistance = 0.0;
    IdxPt2f* lExtPoint = nil;
    Face* lTmpFace = nil;
    HalfEdge* lTmpHE = nil;
    HalfEdge* lTmpHETwin = nil;
    //    unsigned int lLegalEdges = 0;

    BOOL lLoop = YES;
    NSUInteger lLoopIterations = 0;
    NSUInteger lNbOfFlipedEdges = 0;
    NSUInteger ltotalFacesOk = 0;

    while (lLoop && (lLoopIterations < pMax)) {

        lLoop = YES;
        ltotalFacesOk = 0;
        // For all the faces
        for (NSUInteger i = 1; i < [self numberOfFaces]; i++) { // Do not process the whole plan (face 0)
            lTmpFace = [self faceFromId:i];
            lTmpHE = [self halfEdgeFromId:[lTmpFace outCmpId]];

            lNbOfFlipedEdges = 0;

            // For the 3 edges of the current face
            for (NSUInteger lItEdgeFace = 0; lItEdgeFace <3; lItEdgeFace++) {
                // Check if the adjacent face is not the whole plan (face 0)
                lTmpHETwin = [self halfEdgeFromId:[lTmpHE twinId]];

                if ([lTmpHETwin incidentFaceId] != 0) {
                    // Calculate the circumcircle of the face passed in parameter
                    [self circumcircleOfFace:lTmpFace];

                    lExtPoint = [[self oppositePointOfHalfEdgeWith:lTmpHE] retain];

                    lDistance = sqrt(([[lTmpFace circumcircle] x]  - [lExtPoint x])*([[lTmpFace circumcircle] x] - [lExtPoint x]) + ([[lTmpFace circumcircle] y] - [lExtPoint y])*([[lTmpFace circumcircle] y] - [lExtPoint y]));

                    [lExtPoint release];

                    // Verify the circumcircle criteria
                    if (lDistance < [[lTmpFace circumcircle] parameter]) {
                        // If not, flip edge
                        [self flipHalfEdge:[lTmpHE halfEdgeId]];
                        lNbOfFlipedEdges++;

                        lTmpHE = [self halfEdgeFromId:[lTmpHE nextId]];

                    } else {
                        lTmpHE = [self halfEdgeFromId:[lTmpHE nextId]];
                    }
                } else {
                    lTmpHE = [self halfEdgeFromId:[lTmpHE nextId]];
                }

            } // for all edges of the current face

            if (lNbOfFlipedEdges==0) {
                ltotalFacesOk++;
            }

        } // for all faces

        if (ltotalFacesOk == [self numberOfFaces]-1) {
            lLoop = NO;
        }

        lLoopIterations++;
    } // while lLoop

}

- (SetOfPt2f*) voronoiFromDelaunayTriangulation
{
    double lInfinity = 100000.0;
    SetOfPt2f* lVoronoiSegments = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lVoronoiSegments setName:@"voroinoi segments"] ;
    NSLog(@"init %@",lVoronoiSegments.name);
#endif

    // For each face of the dcel
    for (NSUInteger i = 1; i < [self numberOfFaces]; i++) {
        // Get the out cmp of the current face
        HalfEdge* lCurrentHEInside = [self halfEdgeFromId:[[self faceFromId:i] outCmpId]];

        for (NSUInteger j=0; j<3; j++) {
            // Get Id of the face of its twin
            NSUInteger lAdjacentFaceId = [[self halfEdgeFromId:[lCurrentHEInside twinId]] incidentFaceId];

            if (lAdjacentFaceId != 0) {
                [lVoronoiSegments addPt:[[self faceFromId:i] circumcircle] andUpdateIndex:NO];
                [lVoronoiSegments addPt:[[self faceFromId:lAdjacentFaceId] circumcircle] andUpdateIndex:NO];
            } else {
                Vertex* lV1 = [self vertexFromId:[lCurrentHEInside originId]];
                Vertex* lV2 = [self vertexFromId:[[self halfEdgeFromId:[lCurrentHEInside twinId]] originId]];

                // Calculate a mean point
                IdxPt2f* lMeanV1V2 = [[IdxPt2f alloc] init];

                [lMeanV1V2 setX:(([[lV1 coordinates] x] + [[lV2 coordinates] x])/2.0)];
                [lMeanV1V2 setY:(([[lV1 coordinates] y] + [[lV2 coordinates] y])/2.0)];


                int lOrientation = [self orientationOfRandomPtA:[lV1 coordinates] PtB:[lV2 coordinates] andPtC:[[self faceFromId:i] circumcircle] ];

                Vec2f* lTranslation = [[Vec2f alloc] init];
                if (lOrientation == 1 ) {


                    [lTranslation setWithX:(([[[self faceFromId:i] circumcircle] x] - [lMeanV1V2 x])*lInfinity) Y:(([[[self faceFromId:i] circumcircle] y] - [lMeanV1V2 y])*lInfinity)];
                    [lMeanV1V2 translateWithVector:lTranslation];

                } else {
                    [lTranslation setWithX:(([lMeanV1V2 x] - [[[self faceFromId:i] circumcircle] x])*lInfinity) Y:(([lMeanV1V2 y] - [[[self faceFromId:i] circumcircle] y])*lInfinity)];
                    [lMeanV1V2 translateWithVector:lTranslation];
                }

                [lTranslation release];

                [lVoronoiSegments addPt:[[self faceFromId:i] circumcircle] andUpdateIndex:NO];
                [lVoronoiSegments addPt:lMeanV1V2 andUpdateIndex:NO];


                [lMeanV1V2 release];

            }

            lCurrentHEInside = [self halfEdgeFromId:[lCurrentHEInside nextId]];
        }
    }

    return lVoronoiSegments;
}

#pragma mark -
#pragma mark Category's methods

- (void)firstPhaseWith:(SetOfPt2f *)pAngularlySortedSet
{
    // Create vertices for the first triangle
    for (NSUInteger i = 0; i < 3; i++) {
        Vertex* lTmpVertex = [[Vertex alloc] init];
        [lTmpVertex setVertexId:i];
        [lTmpVertex setCoordinates:[pAngularlySortedSet ptAtIndex:i]];

        [arrayOfVertices addObject:lTmpVertex];

        numberOfVertices++;

        [lTmpVertex release];
    }

    // Create the three internal edges of the face
    [[arrayOfVertices objectAtIndex:0] setIncidentEdgeId:2];
    [[arrayOfVertices objectAtIndex:1] setIncidentEdgeId:0];
    [[arrayOfVertices objectAtIndex:2] setIncidentEdgeId:4];

    // Create half edges for the first triangle
    for (NSUInteger i = 0; i < 6; i++) {
        HalfEdge* lTmpHE = [[HalfEdge alloc] init];
        [lTmpHE setHalfEdgeId:i];

        // Pair edges are incident at face,  and his twin is his id+1
        if ([lTmpHE halfEdgeId] % 2 == 0) {
            [lTmpHE setIncidentFaceId:1];
            [lTmpHE setTwinId:(i+1)];
        } else {
            [lTmpHE setIncidentFaceId:0];
            [lTmpHE setTwinId:(i-1)];
        }

        [arrayOfHalfEdges addObject:lTmpHE];

        numberOfHalfEdges++;

        [lTmpHE release];
    }

    [[arrayOfHalfEdges objectAtIndex:0] setOriginId:1];
    [[arrayOfHalfEdges objectAtIndex:0] setNextId:2];
    [[arrayOfHalfEdges objectAtIndex:0] setPreviousId:4];

    [[arrayOfHalfEdges objectAtIndex:1] setOriginId:0];
    [[arrayOfHalfEdges objectAtIndex:1] setNextId:5];
    [[arrayOfHalfEdges objectAtIndex:1] setPreviousId:3];

    [[arrayOfHalfEdges objectAtIndex:2] setOriginId:0];
    [[arrayOfHalfEdges objectAtIndex:2] setNextId:4];
    [[arrayOfHalfEdges objectAtIndex:2] setPreviousId:0];

    [[arrayOfHalfEdges objectAtIndex:3] setOriginId:2];
    [[arrayOfHalfEdges objectAtIndex:3] setNextId:1];
    [[arrayOfHalfEdges objectAtIndex:3] setPreviousId:5];

    [[arrayOfHalfEdges objectAtIndex:4] setOriginId:2];
    [[arrayOfHalfEdges objectAtIndex:4] setNextId:0];
    [[arrayOfHalfEdges objectAtIndex:4] setPreviousId:2];

    [[arrayOfHalfEdges objectAtIndex:5] setOriginId:1];
    [[arrayOfHalfEdges objectAtIndex:5] setNextId:3];
    [[arrayOfHalfEdges objectAtIndex:5] setPreviousId:1];

    // Create the face for the first triangle
    Face* lFirstFace = [[Face alloc] init];
    [arrayOfFaces addObject:lFirstFace];

    numberOfFaces++;

    [lFirstFace setFaceId:(numberOfFaces-1)];
    [lFirstFace setOutCmpId:0];
    [lFirstFace setInCmpId:(-1)];

    [lFirstFace release];

    // Update face 0 incmp
    [[arrayOfFaces objectAtIndex:0] setInCmpId:1];

    // Add the rest of the halfEdges two at two
    id lPtrOnHalfEdge = nil;

    for (NSUInteger i = 3; i < [pAngularlySortedSet nbOfPts] ; i++) {
        //Create the new vertex to connect with his 4 HalfEdges.
        Vertex* lTmpVertex = [[Vertex alloc] init];
        [lTmpVertex setVertexId:i];
        [lTmpVertex setCoordinates:[pAngularlySortedSet ptAtIndex:i]];
        [lTmpVertex setIncidentEdgeId:(numberOfHalfEdges+2)];

        [arrayOfVertices addObject:lTmpVertex];

        numberOfVertices++;

        [lTmpVertex release];

        // First half edge
        HalfEdge* lFirstHEIn = [[HalfEdge alloc] init];
        [arrayOfHalfEdges addObject:lFirstHEIn];
        numberOfHalfEdges++;

        [lFirstHEIn setHalfEdgeId:(numberOfHalfEdges-1)];
        [lFirstHEIn setTwinId:([lFirstHEIn halfEdgeId]+1)];
        [lFirstHEIn setIncidentFaceId:numberOfFaces];
        [lFirstHEIn setNextId:([lFirstHEIn halfEdgeId]+2)];
        [lFirstHEIn setOriginId:0];
        [lFirstHEIn setPreviousId:([lFirstHEIn halfEdgeId] - 3)];

        // Updates for the first half edge
        lPtrOnHalfEdge = [self halfEdgeFromId:[lFirstHEIn previousId]];

        [lPtrOnHalfEdge setNextId:[lFirstHEIn halfEdgeId]];
        [lPtrOnHalfEdge setPreviousId:[lFirstHEIn nextId]];
        [lPtrOnHalfEdge setIncidentFaceId:numberOfFaces];

        [lFirstHEIn release];

        // Second half edge
        HalfEdge* lSecondHEExt = [[HalfEdge alloc] init];
        [arrayOfHalfEdges addObject:lSecondHEExt];
        numberOfHalfEdges++;

        [lSecondHEExt setHalfEdgeId:(numberOfHalfEdges-1)];
        [lSecondHEExt setTwinId:([lSecondHEExt halfEdgeId]-1)];
        [lSecondHEExt setIncidentFaceId:0];
        [lSecondHEExt setNextId:1];
        [lSecondHEExt setOriginId:(numberOfVertices-1)];
        [lSecondHEExt setPreviousId:([lSecondHEExt halfEdgeId] + 2)];

        // Update for second half edge
        lPtrOnHalfEdge = [self halfEdgeFromId:[lSecondHEExt nextId]];
        [lPtrOnHalfEdge setPreviousId:[lSecondHEExt halfEdgeId]];

        [lSecondHEExt release];

        // Third half edge
        HalfEdge* lThirdHEIn = [[HalfEdge alloc] init];
        [arrayOfHalfEdges addObject:lThirdHEIn];
        numberOfHalfEdges++;

        [lThirdHEIn setHalfEdgeId:(numberOfHalfEdges-1)];
        [lThirdHEIn setTwinId:([lThirdHEIn halfEdgeId]+1)];
        [lThirdHEIn setIncidentFaceId:numberOfFaces];
        [lThirdHEIn setNextId:([lThirdHEIn halfEdgeId]-5)];
        [lThirdHEIn setOriginId:(numberOfVertices-1)];
        [lThirdHEIn setPreviousId:([lThirdHEIn halfEdgeId]-2)];

        // No Updates for third halfEdge, already done by lFirstHEIn
        [lThirdHEIn release];

        // Fourth half edge
        HalfEdge* lFourthHEExt = [[HalfEdge alloc] init];
        [arrayOfHalfEdges addObject:lFourthHEExt];
        numberOfHalfEdges++;

        [lFourthHEExt setHalfEdgeId:(numberOfHalfEdges-1)];
        [lFourthHEExt setTwinId:([lFourthHEExt halfEdgeId]-1)];
        [lFourthHEExt setIncidentFaceId:0];
        [lFourthHEExt setNextId:([lFourthHEExt halfEdgeId]-2)];
        [lFourthHEExt setOriginId:(numberOfVertices-2)];
        [lFourthHEExt setPreviousId:([lFourthHEExt halfEdgeId]-4)];

        //Updates for second halfEdge
        lPtrOnHalfEdge = [self halfEdgeFromId:[lFourthHEExt previousId]];
        [lPtrOnHalfEdge setNextId:[lFourthHEExt halfEdgeId]];

        [lFourthHEExt release];

        //Add a new Face for this new vertex added and his half edges
        Face* lTmpFace = [[Face alloc] init];
        [arrayOfFaces addObject:lTmpFace];
        numberOfFaces++;

        [lTmpFace setFaceId:(numberOfFaces-1)];
        [lTmpFace setOutCmpId:(numberOfHalfEdges-7)];
        [lTmpFace setInCmpId:(-1)];

        [lTmpFace release];

    }
}

- (int)orientationOfRandomPtA:(IdxPt2f *)pPt1 PtB:(IdxPt2f *)pPt2 andPtC:(IdxPt2f *)pPt3
{
    double lTwiceSignedArea = 0.0;

    lTwiceSignedArea = (([pPt2 x] - [pPt1 x]) * ([pPt3 y] - [pPt1 y])) - (([pPt2 y] - [pPt1 y]) * ([pPt3 x] - [pPt1 x]));
    if (lTwiceSignedArea > 0.0) {
        return 1;
    } else if(lTwiceSignedArea < 0.0){
        return -1;
    } else if(lTwiceSignedArea == 0.0){
        return 0;
    }

    NSAssert(FALSE, @"Impossible to reach this point");
    return 42;

}

- (void) addExternalFaces
{
    // Edge to iterate
    NSUInteger lEdgeLimit = [[self halfEdgeFromId:1] previousId];

    // Start with the next of the last half edge
    HalfEdge* lStart = nil;
    lStart = [arrayOfHalfEdges objectAtIndex:5];

    // Current half edge for the loop
    HalfEdge* lCurrentHE = nil;

    // Initialization
    lCurrentHE = lStart;

    // 3 points to do Graham test
    IdxPt2f* lFirstPt = nil;
    IdxPt2f* lSecondPt = nil;
    IdxPt2f* lThirdPt = nil;

    // Utility parameters for the loop
    int lOrientation = 42;
    BOOL lLoop = YES;

    while (lLoop) {
        // First point: origin of the Start half edge
        lFirstPt = [[arrayOfVertices objectAtIndex:[lCurrentHE originId]] coordinates];

        // Second point: origin of the twin of Start half edge
        lSecondPt = [[arrayOfVertices objectAtIndex:[[arrayOfHalfEdges objectAtIndex:[lCurrentHE twinId]] originId]] coordinates];

        // Third point: origin of the twin of the next of Start half edge
        lThirdPt = [[arrayOfVertices objectAtIndex:[[arrayOfHalfEdges objectAtIndex:[[arrayOfHalfEdges objectAtIndex:[lCurrentHE nextId]] twinId]] originId]] coordinates];

        lOrientation = [self orientationOfRandomPtA:lFirstPt PtB:lSecondPt andPtC:lThirdPt];

//        // Artificially increase the position of the point to avoid aligned points
//        IdxPt2f* lFirstPtBigScale = [[IdxPt2f alloc] init];
//        IdxPt2f* lSecondPtBigScale = [[IdxPt2f alloc] init];
//        IdxPt2f* lThirdPtBigScale = [[IdxPt2f alloc] init];
//
//        [lFirstPtBigScale setWithX:([lFirstPt x]*100000.0) Y:([lFirstPt y]*100000.0)];
//        [lSecondPtBigScale setWithX:([lSecondPt x]*100000.0) Y:([lSecondPt y]*100000.0)];
//        [lThirdPtBigScale setWithX:([lThirdPt x]*100000.0) Y:([lThirdPt y]*100000.0)];
//
//        lOrientation = [self orientationOfRandomPtA:lFirstPtBigScale PtB:lSecondPtBigScale andPtC:lThirdPtBigScale];
//
//        [lFirstPtBigScale release];
//        [lSecondPtBigScale release];
//        [lThirdPtBigScale release];


        // Keep the last position of the previous of the current half edge
        NSUInteger lPreviousCurrentId = [lCurrentHE previousId];

        if (lOrientation == 1) {
            lCurrentHE = [arrayOfHalfEdges objectAtIndex:[lCurrentHE nextId]];
        } else {
            // Add the 2 half edges
            HalfEdge* lNewIn = [[HalfEdge alloc] init];
            [arrayOfHalfEdges addObject:lNewIn];

            [lNewIn setHalfEdgeId:numberOfHalfEdges];
            [lNewIn setOriginId:[[arrayOfHalfEdges objectAtIndex:[[arrayOfHalfEdges objectAtIndex:[lCurrentHE nextId]] twinId]] originId]];
            [lNewIn setIncidentFaceId:numberOfFaces];
            [lNewIn setTwinId:([lNewIn halfEdgeId]+1)];
            [lNewIn setNextId:[lCurrentHE halfEdgeId]];
            [lNewIn setPreviousId:[[arrayOfHalfEdges objectAtIndex:[lCurrentHE nextId]] halfEdgeId]];

            numberOfHalfEdges++;

            HalfEdge* lNewOut = [[HalfEdge alloc] init];
            [arrayOfHalfEdges addObject:lNewOut];

            [lNewOut setHalfEdgeId:numberOfHalfEdges];
            [lNewOut setOriginId:[lCurrentHE originId]];
            [lNewOut setIncidentFaceId:0];
            [lNewOut setTwinId:([lNewOut halfEdgeId]-1)];
            [lNewOut setNextId:[[arrayOfHalfEdges objectAtIndex:[lCurrentHE nextId]] nextId]];
            [lNewOut setPreviousId:[lCurrentHE previousId]];

            numberOfHalfEdges++;

            // Update the half edges
            [[arrayOfHalfEdges objectAtIndex:[lCurrentHE previousId]] setNextId:[lNewOut halfEdgeId]];

            [lCurrentHE setPreviousId:[lNewIn halfEdgeId]];
            [lCurrentHE setIncidentFaceId:numberOfFaces];


            [[arrayOfHalfEdges objectAtIndex:[lCurrentHE nextId]] setNextId:[lNewIn halfEdgeId]];
            [[arrayOfHalfEdges objectAtIndex:[lCurrentHE nextId]] setIncidentFaceId:numberOfFaces];

            [[arrayOfHalfEdges objectAtIndex:[lNewOut nextId]] setPreviousId:[lNewOut halfEdgeId]];

            [lNewOut release];
            [lNewIn release];

            // Add the new face
            Face* lNewFace = [[Face alloc] init];

            [lNewFace setFaceId:numberOfFaces];
            [lNewFace setOutCmpId:[lCurrentHE halfEdgeId]];
            [lNewFace setInCmpId:(-1)];

            [arrayOfFaces addObject:lNewFace];
            numberOfFaces++;

            [lNewFace release];

            lCurrentHE = [arrayOfHalfEdges objectAtIndex:lPreviousCurrentId];

        }

        if ([lCurrentHE halfEdgeId] == lEdgeLimit) {
            lLoop = NO;
        }

    }
}

#pragma mark -
#pragma mark Debug methods

- (void) displayWithVertices:(BOOL)pDispV andHalfEdges:(BOOL)pDispHE andFaces:(BOOL)pDispF
{
    if (pDispV) {
        NSLog(@"Vertices\n");
        NSEnumerator* lEnumerator = [arrayOfVertices objectEnumerator];
        id lV = nil;
        while (lV = [lEnumerator nextObject]) {
            NSLog(@"Vertex Id: %lu - coords: x:%f y:%f - incidentEdge: %lu \n", [lV vertexId],[[lV coordinates] x], [[lV coordinates] y], [lV incidentEdgeId]);
        }
    }

    if (pDispHE) {
        NSLog(@"Half edges\n");
        NSEnumerator* lEnumerator = [arrayOfHalfEdges objectEnumerator];
        id lHE = nil;
        while (lHE = [lEnumerator nextObject]) {
            NSLog(@"half edge:%lu - origin:%lu - twin:%lu - incidentFace:%lu - next:%lu - prev:%lu \n", [lHE halfEdgeId], [lHE originId], [lHE twinId], [lHE incidentFaceId], [lHE nextId], [lHE previousId]);
        }
    }

    if (pDispF) {
        NSLog(@"Faces\n");
        NSEnumerator* lEnumerator = [arrayOfFaces objectEnumerator];
        id lF = nil;
        while (lF = [lEnumerator nextObject]) {
            NSLog(@"face:%lu - out:%ld - in:%ld \n", [lF faceId], [lF outCmpId], [lF inCmpId]);
        }
    }
}

- (void) displayRetainCount
{
    NSLog(@"Faces: ");
    for (NSUInteger i = 0; i < [self numberOfFaces]; i++) {
        NSLog(@"retain count for face: %lu is %lu \n",i,[[arrayOfFaces objectAtIndex:i] retainCount]);
    }

    NSLog(@"Half edges: ");
    for (NSUInteger i = 0; i < [self numberOfHalfEdges]; i++) {
        NSLog(@"retain count for HE: %lu is %lu \n",i,[[arrayOfHalfEdges objectAtIndex:i] retainCount]);
    }

    NSLog(@"Vertices: ");
    for (NSUInteger i = 0; i < [self numberOfVertices]; i++) {
        NSLog(@"retain count for vertex: %lu is %lu \n",i,[[arrayOfVertices objectAtIndex:i] retainCount]);
    }

}

@end
