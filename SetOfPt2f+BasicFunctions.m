#import "SetOfPt2f+BasicFunctions.h"

@implementation SetOfPt2f (SetOfPt2f_BasicFunctions)

#pragma mark -
#pragma mark Basic geometry methods

- (double) distanceBetweenPtA:(NSUInteger) pIdx1 andPtB:(NSUInteger) pIdx2
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");

    IdxPt2f* lPtA = [mSetOfPts objectAtIndex:pIdx1];
    IdxPt2f* lPtB = [mSetOfPts objectAtIndex:pIdx2];

    return (sqrt(([lPtB x]-[lPtA x])*([lPtB x]-[lPtA x]) + ([lPtB y]-[lPtA y])*([lPtB y]-[lPtA y])));

}

- (double) signedAreaBetweenPtA:(NSUInteger) pIdx1 PtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");

    IdxPt2f* lPtA = [mSetOfPts objectAtIndex:pIdx1];
    IdxPt2f* lPtB = [mSetOfPts objectAtIndex:pIdx2];
    IdxPt2f* lPtC = [mSetOfPts objectAtIndex:pIdx3];

    return (0.5 * ( (([lPtB x] - [lPtA x]) * ([lPtC y] - [lPtA y])) - (([lPtB y] - [lPtA y]) * ([lPtC x] - [lPtA x]))));
}

- (int) orientationOfPtA:(NSUInteger) pIdx1 PtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");

    IdxPt2f* lPtA = [mSetOfPts objectAtIndex:pIdx1];
    IdxPt2f* lPtB = [mSetOfPts objectAtIndex:pIdx2];
    IdxPt2f* lPtC = [mSetOfPts objectAtIndex:pIdx3];

    double lTwiceSignedArea = 0.0;

    lTwiceSignedArea = (([lPtB x] - [lPtA x]) * ([lPtC y] - [lPtA y])) - (([lPtB y] - [lPtA y]) * ([lPtC x] - [lPtA x]));
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


- (BOOL) alignmentOfPtA:(NSUInteger) pIdx1 PtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");

    int lOrientation = 42;

	lOrientation = [self orientationOfPtA: pIdx1 PtB:pIdx2 andPtC:pIdx3];

    if (lOrientation == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (double) distanceBetweenPtA:(NSUInteger) pIdx1 AndLineBCwithPtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");

    IdxPt2f* lPtA = [mSetOfPts objectAtIndex:pIdx1];
    IdxPt2f* lPtB = [mSetOfPts objectAtIndex:pIdx2];
    IdxPt2f* lPtC = [mSetOfPts objectAtIndex:pIdx3];

    if ([lPtA isEqual:lPtB]) {
        return [self distanceBetweenPtA:pIdx1 andPtB:pIdx2];
    } else {
        return fabs( ((([lPtB x] - [lPtA x])*([lPtC y] - [lPtA y])) - (([lPtB y] - [lPtA y])*([lPtC x] - [lPtA x]))) / sqrt( (([lPtC x] - [lPtB x])*([lPtC x] - [lPtA x])) + (([lPtC y] - [lPtB y])*([lPtC y ] - [lPtB y]))) );
    }
}


- (double) distanceBetweenPtA:(NSUInteger) pIdx1 AndSegmentBCwithPtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");

    IdxPt2f* lPtA = [mSetOfPts objectAtIndex:pIdx1];
    IdxPt2f* lPtB = [mSetOfPts objectAtIndex:pIdx2];
    IdxPt2f* lPtC = [mSetOfPts objectAtIndex:pIdx3];

    if ([lPtB isEqual:lPtC]) {
        return [self distanceBetweenPtA: pIdx1 andPtB: pIdx2];
    }

    Vec2f* lVecBA = [[Vec2f alloc] init];
    [lVecBA setWithX:([lPtA x] - [lPtB x]) Y:([lPtA y] - [lPtB y])];


    Vec2f* lVecBC = [[Vec2f alloc] init];
    [lVecBC setWithX:([lPtC x] - [lPtB x]) Y:([lPtC y] - [lPtB y])];


    [lVecBC normalize];

    double lScalarProd = [lVecBC scalarProductWith:lVecBA];

    if (lScalarProd < 0.0) {
        [lVecBC release];
        [lVecBA release];
        return ([self distanceBetweenPtA:pIdx1 andPtB:pIdx2]);
    }

    // Calculate scalar product to see if the point is on the "left side" of the first point defining the segment

    Vec2f* lVecCB = [[Vec2f alloc] init];
    [lVecCB setWithX:([lPtB x] - [lPtC x]) Y:([lPtB y] - [lPtC y])];

    Vec2f* lVecCA = [[Vec2f alloc] init];
    [lVecCA setWithX:([lPtA x] - [lPtC x]) Y:([lPtA y] - [lPtC y])];

    [lVecCB normalize];

    double lScalarProd2 = [lVecCB scalarProductWith:lVecCA];

    if (lScalarProd2 < 0.0) {
        [lVecCA release];
        [lVecCB release];
        [lVecBC release];
        [lVecBA release];
        return [self distanceBetweenPtA:pIdx1 andPtB:pIdx3];
    }

    [lVecCA release];
    [lVecCB release];
    [lVecBC release];
    [lVecBA release];
    return [self distanceBetweenPtA:pIdx1 AndLineBCwithPtB:pIdx2 andPtC:pIdx3];
}

- (BOOL) isPtA:(NSUInteger) pIdx1 InSegmentBCWithPtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");

    IdxPt2f* lPtA = [mSetOfPts objectAtIndex:pIdx1];
    IdxPt2f* lPtB = [mSetOfPts objectAtIndex:pIdx2];
    IdxPt2f* lPtC = [mSetOfPts objectAtIndex:pIdx3];

    int lOrientation = [self orientationOfPtA:pIdx1 PtB:pIdx2 andPtC:pIdx3];

    if (lOrientation == 0) {
        if (([lPtA x] > [lPtB x] && [lPtA x] < [lPtC x]) || ([lPtA x] < [lPtB x] && [lPtA x] > [lPtC x])) {
            return YES;
        } else if(([lPtA y] > [lPtB y] && [lPtA y] < [lPtC y]) || ([lPtA y] < [lPtB y] && [lPtA y] > [lPtC y])){
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}


- (BOOL) isPtA:(NSUInteger) pIdx1 InTriangleBCDWithPtB:(NSUInteger) pIdx2 PtC:(NSUInteger) pIdx3 andPtD:(NSUInteger) pIdx4;
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx4 && pIdx4 < [mSetOfPts count] , @"Index out of range");

    int lSign1 = [self orientationOfPtA:pIdx2 PtB:pIdx3 andPtC:pIdx1];
    int lSign2 = [self orientationOfPtA:pIdx3 PtB:pIdx4 andPtC:pIdx1];
    int lSign3 = [self orientationOfPtA:pIdx4 PtB:pIdx2 andPtC:pIdx1];

    int lSum = abs(lSign1 + lSign2 + lSign3);

    if (lSum == 3) {
        return YES;
    } else if( (lSign1 == 0 || lSign2 == 0 || lSign3 == 0) && lSum == 2) {
        return YES;
    } else {
        return NO;
    }

}

- (BOOL) isSegmentABWithPtA:(NSUInteger) pIdx1 andPtB:(NSUInteger) pIdx2 IntersectingSegmentCDWithPtC:(NSUInteger) pIdx3 andPtD:(NSUInteger) pIdx4;
{
    NSAssert(0 <= pIdx1 && pIdx1 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx2 && pIdx2 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx3 && pIdx3 < [mSetOfPts count] , @"Index out of range");
    NSAssert(0 <= pIdx4 && pIdx4 < [mSetOfPts count] , @"Index out of range");

    int lSign1 = [self orientationOfPtA:pIdx1 PtB:pIdx2 andPtC:pIdx3];
    int lSign2 = [self orientationOfPtA:pIdx1 PtB:pIdx2 andPtC:pIdx4];
    int lSign3 = [self orientationOfPtA:pIdx3 PtB:pIdx4 andPtC:pIdx1];
    int lSign4 = [self orientationOfPtA:pIdx3 PtB:pIdx4 andPtC:pIdx2];

    int lProd1 = lSign1*lSign2;
    int lProd2 = lSign3*lSign4;

    if (lProd1 == -1 && lProd2 == -1) {
        return YES;
    } else if((lProd1 == 0 && lProd2 == -1) ||(lProd1 == -1 && lProd2 == 0) ) {
        return YES;
    } else if(lProd1 == 0 && lProd2 == 0) {
        /* finish to implement !!! be careful, the lProd1 == 0 does not mean each lSign == 0 !*/
        return NO;
    } else {
        return NO;
    }

}

#pragma mark -
#pragma mark Extreme points methods

- (IdxPt2f*) rightmostPt;
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    IdxPt2f* lRightmostPt = nil;

    // Initialize the rightmostpoint with the first point of the set
    lRightmostPt = [mSetOfPts objectAtIndex:0];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [mSetOfPts count]; i++) {
        if ([[mSetOfPts objectAtIndex:i] x] > [lRightmostPt x]) {
            if (lRightmostPt != [mSetOfPts objectAtIndex:i]) {
                lRightmostPt = [mSetOfPts objectAtIndex:i];
            }
        }
    }

    return lRightmostPt;
}

- (IdxPt2f*) leftmostPt
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    IdxPt2f* lLeftmostPt = nil;

    // Initialize the rightmostpoint with the first point of the set
    lLeftmostPt = [mSetOfPts objectAtIndex:0];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [mSetOfPts count]; i++) {
        if ([[mSetOfPts objectAtIndex:i] x] < [lLeftmostPt x]) {
            if (lLeftmostPt != [mSetOfPts objectAtIndex:i]) {
                lLeftmostPt = [mSetOfPts objectAtIndex:i];
            }

        }
    }

    return lLeftmostPt;
}

- (IdxPt2f*) uppermostPt
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    IdxPt2f* lUppermostPt = nil;

    // Initialize the rightmostpoint with the first point of the set
    lUppermostPt = [mSetOfPts objectAtIndex:0];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [mSetOfPts count]; i++) {
        if ([[mSetOfPts objectAtIndex:i] y] > [lUppermostPt y]) {
            if (lUppermostPt != [mSetOfPts objectAtIndex:i]) {
                lUppermostPt = [mSetOfPts objectAtIndex:i];
            }

        }
    }

    return lUppermostPt;
}


- (IdxPt2f*) lowestPt
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    IdxPt2f* lLowestPt = nil;

    // Initialize the rightmostpoint with the first point of the set
    lLowestPt = [mSetOfPts objectAtIndex:0];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [mSetOfPts count]; i++) {
        if ([[mSetOfPts objectAtIndex:i] y] < [lLowestPt y]) {
            if (lLowestPt != [mSetOfPts objectAtIndex:i]) {
                lLowestPt = [mSetOfPts objectAtIndex:i];
            }

        }
    }

    return lLowestPt;

}

- (IdxPt2f*) extremePtInDirection:(Vec2f*) pDirection
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");
    NSAssert([pDirection length] > 0.0, @"Direction can't be null vector");

    // Copy and normalize the direction vector
    Vec2f* lDirection = [[Vec2f alloc] init];
    [lDirection setWithX:[pDirection x] Y:[pDirection y]];
    [lDirection normalize];

    // Set x axis vector
    Vec2f* lAxisX = [[Vec2f alloc] init];
    [lAxisX setWithX:1.0 Y:0.0];

    double lCosAngle = [lAxisX scalarProductWith:lDirection];

    double lSinAngle = 0.0;
    if ([pDirection y] >= 0.0) {
        lSinAngle = sqrt(1-lCosAngle*lCosAngle);
    } else {
        lSinAngle = (-1.0)*sqrt(1-lCosAngle*lCosAngle);
    }

    [lAxisX release];
    [lDirection release];

    // Apply a rotation of angle -Angle (Angle between X axis and direction vector) to all the points in the set
    SetOfPt2f* lSet = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [lSet setName:@"tmp set in extreme direction"];
    NSLog(@"init %@",lSet.name);
#endif

    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        IdxPt2f* lTmp = [[IdxPt2f alloc] init];
        [lTmp setX:([[mSetOfPts objectAtIndex:i] x]*lCosAngle        + [[mSetOfPts objectAtIndex:i] y]*lSinAngle)];
        [lTmp setY:([[mSetOfPts objectAtIndex:i] x]*lSinAngle*(-1.0) + [[mSetOfPts objectAtIndex:i] y]*lCosAngle)];
        [lSet addPt:lTmp andUpdateIndex:YES];
        [lTmp release];
    }

    IdxPt2f* lExtremePt = [lSet rightmostPt];
    NSUInteger lIndex = [lExtremePt idx];

    [lSet removeAllPts];
    [lSet release];

    return [mSetOfPts objectAtIndex:lIndex];

}

- (IdxPt2f*) furthestFromOrigin
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    SetOfPt2f* lSet = [[SetOfPt2f alloc] init];

#ifdef DEBUG
    [lSet setName:@"tmp set in furthestFromOrigin"];
    NSLog(@"init %@",lSet.name);
#endif

    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        IdxPt2f* lTmp = [[IdxPt2f alloc] init];
        [lTmp setX: ([[mSetOfPts objectAtIndex:i] x]*[[mSetOfPts objectAtIndex:i] x] + [[mSetOfPts objectAtIndex:i] y]*[[mSetOfPts objectAtIndex:i] y])];
        [lSet addPt:lTmp andUpdateIndex:YES];
        [lTmp release];
    }

    IdxPt2f* lExtremePt = [lSet rightmostPt];
    NSUInteger lIndex = [lSet indexFromPt:lExtremePt];

    [lSet removeAllPts];
    [lSet release];

    return [mSetOfPts objectAtIndex:lIndex];
}

- (IdxPt2f*) minimumAngle
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    Vec2f* lX  = [[Vec2f alloc] init];
    [lX setWithX:1.0 Y:0.0];
    Vec2f* lMinusX  = [[Vec2f alloc] init];
    [lMinusX setWithX:-1.0 Y:0.0];
    double lCosAngle = 0.0;
    double lCosAngle2 = 0.0;
    double lMaxCosAngle = -2.0;
    double lMaxCosAngle2 = -2.0;
    NSUInteger lPtIdx = 0;
    NSUInteger lPtIdx2 = 0;

    Vec2f* lTmpVec = [[Vec2f alloc] init];

    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {

        // Create a vector corresponding to the current point and normalize it.
        [lTmpVec setX: [[mSetOfPts objectAtIndex:i] x]];
        [lTmpVec setY:[[mSetOfPts objectAtIndex:i] y]];
        [lTmpVec normalize];

        // Calculate the cosinus of this vector with the x axis with a scalar product 2 cases: Points upper the x axis and the other ones
        // if Y>0, scalar product with the vector (1,0)
        // if Y<0, scalar product with the vector (-1,0)
        if ([lTmpVec y] >= 0.0) {
            lCosAngle = [lTmpVec scalarProductWith:lX];
        } else {
            lCosAngle2 = [lTmpVec scalarProductWith:lMinusX];
        }

        // The smaller angle correspond to the maximum cosinus.
        if (lCosAngle > lMaxCosAngle) {
            lMaxCosAngle = lCosAngle;
            lPtIdx = i;
        }

        if (lCosAngle2 > lMaxCosAngle2) {
            lMaxCosAngle2 = lCosAngle2;
            lPtIdx2 = i;
        }

    }

    [lMinusX release];
    [lX release];
    [lTmpVec release];

    // if there is at least one point upper the x axis, the point with the minimum angle cannot be one below the x axis
    if (lMaxCosAngle2 != -2.0) {
        return [mSetOfPts objectAtIndex:lPtIdx];
    } else {
        return [mSetOfPts objectAtIndex:lPtIdx2];
    }

}

- (void) minimumVerticalStripWithLDS:(IdxPt2f*) pPtL1 LUS:(IdxPt2f*) pPtL2 RDS:(IdxPt2f*) pPtR1 RUS:(IdxPt2f*) pPtR2
{
    IdxPt2f* lTmp = nil;

    lTmp = [self leftmostPt];
    [pPtL1 setWithX:[lTmp x] Y:[lTmp y]];
    [pPtL2 setWithX:[lTmp x] Y:([lTmp y] + 1.0)];

    lTmp = [self rightmostPt];
    [pPtR1 setWithX:[lTmp x] Y:[lTmp y]];
    [pPtR2 setWithX:[lTmp x] Y:([lTmp y] + 1.0)];

}

- (void) minimumOrientedStripInDirection:(Vec2f*) pVec1 WithLDS:(IdxPt2f*)pPtL1 LUS:(IdxPt2f*)pPtL2 RDS:(IdxPt2f*)pPtR1 RUS:(IdxPt2f*)pPtR2
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    Vec2f* lOrthogonalDirection = [[Vec2f alloc] init];
    [lOrthogonalDirection setWithX:((-1)*[pVec1 y]) Y:[pVec1 x]];

    pPtL1 = [self extremePtInDirection:lOrthogonalDirection];
    [lOrthogonalDirection multiplyByScalar:(-1)];
    pPtR1 = [self extremePtInDirection:lOrthogonalDirection];

    [pPtL2 setWithX:[pPtL1 x] Y:[pPtL1 y]];
    [pPtL2 translateWithVector:pVec1];

    [pPtR2 setWithX:[pPtR1 x] Y:[pPtR1 y]];
    [pPtR2 translateWithVector:pVec1];

    [lOrthogonalDirection release];
}

- (void) boundingBoxWithLDC:(IdxPt2f*)pPtL1 LUC:(IdxPt2f*)pPtL2 RUC:(IdxPt2f*)pPtR1 RDC:(IdxPt2f*)pPtR2
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    IdxPt2f* lUp = [self uppermostPt];
    IdxPt2f* lDown = [self lowestPt];
    IdxPt2f* lLeft = [self leftmostPt];
    IdxPt2f* lRight = [self rightmostPt];

    [pPtL1 setWithX:[lLeft x] Y:[lDown y]];
    [pPtL2 setWithX:[lLeft x] Y:[lUp y]];
    [pPtR1 setWithX:[lRight x] Y:[lUp y]];
    [pPtR2 setWithX:[lRight x] Y:[lDown y]];
}

- (void) divideSetInUp:(SetOfPt2f*) pSetUp andDown:(SetOfPt2f*) pSetDown
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    IdxPt2f* lLeft = [self leftmostPt];
    IdxPt2f* lRight = [self rightmostPt];
    NSUInteger lLeftIdx = [lLeft idx];
    NSUInteger lRightIdx = [lRight idx];

    int lOrientation = 0;

    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        lOrientation = [self orientationOfPtA:lLeftIdx PtB:lRightIdx andPtC:i];
        if (lOrientation == 0 || lOrientation == 1) {
            [pSetUp addPt:[mSetOfPts objectAtIndex:i] andUpdateIndex:NO];
        } else if (lOrientation == -1){
            [pSetDown addPt:[mSetOfPts objectAtIndex:i] andUpdateIndex:NO];
        } else {
            NSAssert(FALSE, @"Impossible to arrive here!");
        }
    }
}

#pragma mark -
#pragma mark Geometric sorting methods

- (SetOfPt2f*) sortLeftToRight
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    NSSortDescriptor* lXValueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:YES];
    NSArray* lAllDescriptors = [NSArray arrayWithObjects:lXValueDescriptor, nil];

    NSArray* lSortedSet = [mSetOfPts sortedArrayUsingDescriptors:lAllDescriptors];

    SetOfPt2f* lSortedSetOfPts = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lSortedSetOfPts setName:@"sort left to right"];
    NSLog(@"init %@",lSortedSetOfPts.name);
#endif

    NSEnumerator* lEnumerator = [lSortedSet objectEnumerator];
    id lObject;

    while ((lObject = [lEnumerator nextObject])) {
        [lSortedSetOfPts addPt:lObject andUpdateIndex:NO];
    }

    [lXValueDescriptor release];

    return lSortedSetOfPts;
}

- (SetOfPt2f*) sortBottomToTop
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    NSSortDescriptor* lXValueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"y" ascending:YES];
    NSArray* lAllDescriptors = [NSArray arrayWithObjects:lXValueDescriptor, nil];

    NSArray* lSortedSet = [mSetOfPts sortedArrayUsingDescriptors:lAllDescriptors];

    SetOfPt2f* lSortedSetOfPts = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lSortedSetOfPts setName:@"sort bottom to top"];
    NSLog(@"init %@",lSortedSetOfPts.name);
#endif

    NSEnumerator* lEnumerator = [lSortedSet objectEnumerator];
    id lObject;

    while ((lObject = [lEnumerator nextObject])) {
        [lSortedSetOfPts addPt:lObject andUpdateIndex:NO];
        [lObject release];
    }

    [lXValueDescriptor release];

    return lSortedSetOfPts;
}

- (SetOfPt2f*) sortInDirection:(Vec2f *)pDirection
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");
    NSAssert([pDirection length] > 0.0, @"Direction can't be null vector");

    // Copy and normalize the direction vector
    Vec2f* lDirection = [[Vec2f alloc] init];
    [lDirection setWithX:[pDirection x] Y:[pDirection y]];
    [lDirection normalize];

    // Set x axis vector
    Vec2f* lAxisX = [[Vec2f alloc] init];
    [lAxisX setWithX:1.0 Y:0.0];

    double lCosAngle = [lAxisX scalarProductWith:lDirection];

    double lSinAngle = 0.0;
    if ([pDirection y] >= 0.0) {
        lSinAngle = sqrt(1-lCosAngle*lCosAngle);
    } else {
        lSinAngle = (-1.0)*sqrt(1-lCosAngle*lCosAngle);
    }

    [lAxisX release];
    [lDirection release];

    // Apply a rotation of angle -Angle (Angle between X axis and direction vector) to all the points in the set
    NSMutableArray* lRotatedSet = [[NSMutableArray alloc] init];


    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        // Create a rotated point and save it's position in mSetOfPts
        IdxPt2f* lTmpPt = [[IdxPt2f alloc] init];
        [lTmpPt setX:([[mSetOfPts objectAtIndex:i] x]*lCosAngle        + [[mSetOfPts objectAtIndex:i] y]*lSinAngle)];
        [lTmpPt setY:([[mSetOfPts objectAtIndex:i] x]*lSinAngle*(-1.0) + [[mSetOfPts objectAtIndex:i] y]*lCosAngle)];
        [lTmpPt setIdx:i];

        [lRotatedSet addObject:lTmpPt];
        [lTmpPt release];
    }

    // Sort the rotated point with x value
    NSSortDescriptor* lXValueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"x" ascending:YES];
    NSArray* lAllDescriptors = [NSArray arrayWithObjects:lXValueDescriptor, nil];

    NSArray* lSortedSet = [lRotatedSet sortedArrayUsingDescriptors:lAllDescriptors];



    SetOfPt2f* lSortedSetOfPts = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lSortedSetOfPts setName:@"sort in direction"];
    NSLog(@"init %@",lSortedSetOfPts.name);
#endif

    NSEnumerator* lEnumerator = [lSortedSet objectEnumerator];
    id lObject;

    while ((lObject = [lEnumerator nextObject])) {
        [lSortedSetOfPts addPt:[mSetOfPts objectAtIndex:[lObject idx]] andUpdateIndex:NO];
        [lObject release];
    }


    [lRotatedSet removeAllObjects];
    [lRotatedSet release];
    [lXValueDescriptor release];

    return lSortedSetOfPts;

}

- (SetOfPt2f*) sortAngularlyFromBottom
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    // Get bottom point in the set
    IdxPt2f* lBottomPt = [self lowestPt];

    // Get the index of this point in the set
    NSUInteger lBottomPtIdx = [lBottomPt idx];

    // Opposite vector toward the lowest point in the set
    Vec2f* lTranslation = [[Vec2f alloc] init];
    [lTranslation setWithX:([lBottomPt x]*(-1)) Y:([lBottomPt y]*(-1))];

    NSMutableArray* lAngleValues = [[NSMutableArray alloc] init];
    Vec2f* lTmpVec = [[Vec2f alloc] init];

    Vec2f* lXAxis = [[Vec2f alloc] init];
    [lXAxis setWithX:1.0 Y:0.0];

    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        // Save a point with the translated coordinates, it's original index in the set and it's angle with the x axis
        IdxPt2f* lTmpPt = [[IdxPt2f alloc] init];
        [lTmpPt setWithX:[[mSetOfPts objectAtIndex:i] x] Y:[[mSetOfPts objectAtIndex:i] y]];
        [lTmpPt setIdx:i];

        // The bottom point is the new origin, angle = 0.0
        if (i == lBottomPtIdx) {
            [lTmpPt setParameter:0.0];
            [lAngleValues addObject:lTmpPt];
            [lTmpPt release];
        } else {
            [lTmpPt translateWithVector:lTranslation];

            [lTmpVec setWithX:[lTmpPt x] Y:[lTmpPt y]];
            [lTmpVec normalize];
            [lTmpPt setParameter:acos([lXAxis scalarProductWith:lTmpVec])];

            // save the point in an array
            [lAngleValues addObject:lTmpPt];
            [lTmpPt release];
        }
    }

    // Sort the point with reference to the angle value
    NSSortDescriptor* lAngleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"parameter" ascending:YES];

    NSArray* lAllDescriptors = [NSArray arrayWithObjects:lAngleDescriptor, nil];
    NSArray* lSortedSet = [lAngleValues sortedArrayUsingDescriptors:lAllDescriptors];

    // Create a set of point and fill it with the points sorted angularly
    SetOfPt2f* lSortedSetOfPts = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lSortedSetOfPts setName:@"sort angularly from bottom"];
    NSLog(@"init %@",lSortedSetOfPts.name);
#endif

    // Save the lowest point first (with angle value = 0). It's the last one in the sorted set as it has been sorted in a decreasing order
    for (NSUInteger i = 0; i < ([lSortedSet count]); i++) {
        [lSortedSetOfPts addPt:[mSetOfPts objectAtIndex:[[lSortedSet objectAtIndex:i ] idx]] andUpdateIndex:NO];
    }


    for (NSUInteger i = 0; i < [lSortedSetOfPts nbOfPts]; i++) {
        [lSortedSetOfPts ptAtIndex:i];
    }

    [lAngleDescriptor release];
    [lXAxis release];
    [lTmpVec release];
    [lTranslation release];

    [lAngleValues removeAllObjects];
    [lAngleValues release];

    return lSortedSetOfPts;
}

- (SetOfPt2f*) sortDistanceFromPoint:(IdxPt2f *) pPt
{
    NSAssert([mSetOfPts count] > 0 , @"Empty set!!");

    NSMutableArray* lDistValues = [[NSMutableArray alloc] init];
    double lDistance = 0.0;

    for (NSUInteger i = 0; i < [mSetOfPts count]; i++) {
        // Save a point with the translated coordinates, it's original index in the set and it's angle with the x axis
        IdxPt2f* lTmpPt = [[IdxPt2f alloc] init];
        [lTmpPt setWithX:[[mSetOfPts objectAtIndex:i] x] Y:[[mSetOfPts objectAtIndex:i] y]];
        [lTmpPt setIdx:i];

        lDistance = sqrt(([lTmpPt x] - [pPt x])*([lTmpPt x] - [pPt x]) + ([lTmpPt y] - [pPt y])*([lTmpPt y] - [pPt y]));
        [lTmpPt setParameter:lDistance];

        // save the point in an array
        [lDistValues addObject:lTmpPt];
        [lTmpPt release];
    }

    // Sort the point with reference to the distance
    NSSortDescriptor* lDistDescriptor = [[NSSortDescriptor alloc] initWithKey:@"parameter" ascending:YES];

    NSArray* lAllDescriptors = [NSArray arrayWithObjects:lDistDescriptor, nil];
    NSArray* lSortedSet = [lDistValues sortedArrayUsingDescriptors:lAllDescriptors];

    // Create a set of point and fill it with the points sorted angularly
    SetOfPt2f* lSortedSetOfPts = [[[SetOfPt2f alloc] init] autorelease];

#ifdef DEBUG
    [lSortedSetOfPts setName:@"sort distance from point"];
    NSLog(@"init %@",lSortedSetOfPts.name);
#endif

    NSEnumerator* lEnumerator = [lSortedSet objectEnumerator];
    id lObject;

    while ((lObject = [lEnumerator nextObject])) {
        [lSortedSetOfPts addPt:[mSetOfPts objectAtIndex:[lObject idx]] andUpdateIndex:NO];
        [lObject release];
    }

    [lDistDescriptor release];
    [lDistValues removeAllObjects];
    [lDistValues release];

    return lSortedSetOfPts;
}



@end
