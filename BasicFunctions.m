#import <math.h>

#import "BasicFunctions.h"
#import "Vec2f.h"

@implementation BasicFunctions

- (id)init
{
    self = [super init];
    if (self) {
        // No members =)
    }

    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (double) distanceBetweenPtA:(Pt2f*) pPtA andPtB:(Pt2f*) pPtB
{
    return (sqrt([pPtA x]*[pPtB x] + [pPtA y]*[pPtB y]));
}


- (double) signedAreaBetweenPtA:(Pt2f*) pPtA PtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC
{
    return (0.5 * ( (([pPtB x] - [pPtA x]) * ([pPtC y] - [pPtA y])) - (([pPtB y] - [pPtA y]) * ([pPtC x] - [pPtA x]))));
}

- (int) orientationOfPtA:(Pt2f*) pPtA PtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC
{
    double lTwiceSignedArea = 0.0;

    lTwiceSignedArea = (([pPtB x] - [pPtA x]) * ([pPtC y] - [pPtA y])) - (([pPtB y] - [pPtA y]) * ([pPtC x] - [pPtA x]));
    if (lTwiceSignedArea > 0.0) {
        return 1;
    } else if(lTwiceSignedArea < 0.0){
        return -1;
    } else if(lTwiceSignedArea == 0.0){
        return 0;
    }

    NSAssert(FALSE, @"Impossible to reach this point");
    return 42.0;

}


- (BOOL) alignmentOfPtA:(Pt2f*) pPtA PtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC
{
    int lOrientation = 42;

	lOrientation = [self orientationOfPtA: pPtA PtB:pPtB andPtC:pPtC];

    if (lOrientation == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (double) distanceBetweenPtA:(Pt2f*) pPtA AndLineBCwithPtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC
{
    if ([pPtA isEqual:pPtB]) {
        return [self distanceBetweenPtA: pPtA andPtB: pPtB];
    } else {
        return fabs( ((([pPtB x] - [pPtA x])*([pPtC y] - [pPtA y])) - (([pPtB y] - [pPtA y])*([pPtC x] - [pPtA x]))) / sqrt( (([pPtC x] - [pPtB x])*([pPtC x] - [pPtA x])) + (([pPtC y] - [pPtB y])*([pPtC y ] - [pPtB y]))) );
    }
}


- (double) distanceBetweenPtA:(Pt2f*) pPtA AndSegmentBCwithPtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC
{
    if ([pPtB isEqual:pPtC]) {
        return [self distanceBetweenPtA: pPtA andPtB: pPtB];
    }

    Vec2f* lVecBA = [[Vec2f alloc] init];
    [lVecBA setWithX:([pPtA x] - [pPtB x]) Y:([pPtA y] - [pPtB y])];
//    [lVecAB setX:([pPtB x] - [pPtA x])];
//    [lVecAB setY:([pPtB y] - [pPtA y])];

    Vec2f* lVecBC = [[Vec2f alloc] init];
    [lVecBC setWithX:([pPtC x] - [pPtB x]) Y:([pPtC y] - [pPtB y])];
//    [lVecBC setX:([pPtC x] - [pPtB x])];
//    [lVecBC setY:([pPtC y] - [pPtB y])];

    [lVecBC normalize];

    double lScalarProd = [lVecBC scalarProductWith:lVecBA];

    if (lScalarProd < 0.0) {
        [lVecBC release];
        [lVecBA release];
        return ([self distanceBetweenPtA:pPtA andPtB:pPtB]);
    }

    // Calculate scalar product to see if the point is on the "left side" of the first point defining the segment

    Vec2f* lVecCB = [[Vec2f alloc] init];
    [lVecCB setWithX:([pPtB x] - [pPtC x]) Y:([pPtB y] - [pPtC y])];

    Vec2f* lVecCA = [[Vec2f alloc] init];
    [lVecCA setWithX:([pPtA x] - [pPtC x]) Y:([pPtA y] - [pPtC y])];

    [lVecCB normalize];

    double lScalarProd2 = [lVecCB scalarProductWith:lVecCA];

    if (lScalarProd2 < 0.0) {
        [lVecCA release];
        [lVecCB release];
        [lVecBC release];
        [lVecBA release];
        return [self distanceBetweenPtA:pPtA andPtB:pPtC];
    }

    [lVecCA release];
    [lVecCB release];
    [lVecBC release];
    [lVecBA release];
    return [self distanceBetweenPtA:pPtA AndLineBCwithPtB:pPtB andPtC:pPtC];
}

- (BOOL) isPtA:(Pt2f*) pPtA InSegmentBCWithPtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC
{
    int lOrientation = [self orientationOfPtA:pPtA PtB:pPtB andPtC:pPtC];

    if (lOrientation == 0) {
        if (([pPtA x] > [pPtB x] && [pPtA x] < [pPtC x]) || ([pPtA x] < [pPtB x] && [pPtA x] > [pPtC x])) {
            return YES;
        } else if(([pPtA y] > [pPtB y] && [pPtA y] < [pPtC y]) || ([pPtA y] < [pPtB y] && [pPtA y] > [pPtC y])){
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}


- (BOOL) isPtA:(Pt2f*) pPtA InTriangleBCDWithPtB:(Pt2f*) pPtB PtC:(Pt2f*) pPtC andPtD:(Pt2f*) pPtD
{
    int lSign1 = [self orientationOfPtA:pPtB PtB:pPtC andPtC:pPtA];
    int lSign2 = [self orientationOfPtA:pPtC PtB:pPtD andPtC:pPtA];
    int lSign3 = [self orientationOfPtA:pPtD PtB:pPtB andPtC:pPtA];

    int lSum = abs(lSign1 + lSign2 + lSign3);

    if (lSum == 3) {
        return YES;
    } else if( (lSign1 == 0 || lSign2 == 0 || lSign3 == 0) && lSum == 2) {
        return YES;
    } else {
        return NO;
    }

}

- (BOOL) isSegmentABWithPtA:(Pt2f*) pPtA andPtB:(Pt2f*) pPtB IntersectingSegmentCDWithPtC:(Pt2f*) pPtC andPtD:(Pt2f*) pPtD
{
    int lSign1 = [self orientationOfPtA:pPtA PtB:pPtB andPtC:pPtC];
    int lSign2 = [self orientationOfPtA:pPtA PtB:pPtB andPtC:pPtD];
    int lSign3 = [self orientationOfPtA:pPtC PtB:pPtD andPtC:pPtA];
    int lSign4 = [self orientationOfPtA:pPtC PtB:pPtD andPtC:pPtB];

    int lProd1 = lSign1*lSign2;
    int lProd2 = lSign3*lSign4;

    if (lProd1 == -1 && lProd2 == -1) {
        return YES;
    } else if((lProd1 == 0 && lProd2 == -1) ||(lProd1 == -1 && lProd2 == 0) ) {
        return YES;
    } else if(lProd1 == 0 && lProd2 == 0) {
        BOOL lInside = NO;
        lInside = !lInside; // Useless, just not to have a warning!

        /* finish to implement !!! be careful, the lProd1 == 0 does not mean each lSign == 0 !*/
        return NO;
    } else {
        return NO;
    }

}


- (Pt2f*) rightmostPtInSet:(SetOfPt2f*) pSetOfPts
{
    NSAssert([pSetOfPts nbOfPts] > 0 , @"Empty set!!");

    Pt2f* rightmostPt = nil;

    // Initialize the rightmostpoint with the first point of the set
    //rightmostPt = [[pSetOfPts ptAtIndex:0] retain];
    rightmostPt = [pSetOfPts ptAtIndex:0];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [pSetOfPts nbOfPts]; i++) {
        if ([[pSetOfPts ptAtIndex:i] x] > [rightmostPt x]) {
            if (rightmostPt != [pSetOfPts ptAtIndex:i]) {
                //[rightmostPt release];
                //rightmostPt = [[pSetOfPts ptAtIndex:i] retain];
                rightmostPt = [pSetOfPts ptAtIndex:i];
            }

        }
    }

    return rightmostPt;

}

- (Pt2f*) leftmostPtInSet:(SetOfPt2f*) pSetOfPts
{
    NSAssert([pSetOfPts nbOfPts] > 0 , @"Empty set!!");

    Pt2f* leftmostPt = nil;

    // Initialize the rightmostpoint with the first point of the set
//    leftmostPt = [[pSetOfPts ptAtIndex:0] retain];
    leftmostPt = [pSetOfPts ptAtIndex:0];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [pSetOfPts nbOfPts]; i++) {
        if ([[pSetOfPts ptAtIndex:i] x] < [leftmostPt x]) {
            if (leftmostPt != [pSetOfPts ptAtIndex:i]) {
//                [leftmostPt release];
//                leftmostPt = [[pSetOfPts ptAtIndex:i] retain];
                leftmostPt = [pSetOfPts ptAtIndex:i];
            }

        }
    }

    return leftmostPt;

}

- (Pt2f*) uppermostPtInSet:(SetOfPt2f*) pSetOfPts
{
    NSAssert([pSetOfPts nbOfPts] > 0 , @"Empty set!!");

    Pt2f* uppermostPt = nil;

    // Initialize the rightmostpoint with the first point of the set
//    uppermostPt = [[pSetOfPts ptAtIndex:0] retain];
    uppermostPt = [pSetOfPts ptAtIndex:0];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [pSetOfPts nbOfPts]; i++) {
        if ([[pSetOfPts ptAtIndex:i] y] > [uppermostPt y]) {
            if (uppermostPt != [pSetOfPts ptAtIndex:i]) {
//                [uppermostPt release];
//                uppermostPt = [[pSetOfPts ptAtIndex:i] retain];
                uppermostPt = [pSetOfPts ptAtIndex:i];
            }

        }
    }

    return uppermostPt;

}


- (Pt2f*) lowestPtInSet:(SetOfPt2f*) pSetOfPts
{
    NSAssert([pSetOfPts nbOfPts] > 0 , @"Empty set!!");

    Pt2f* lowestPt = nil;

    // Initialize the rightmostpoint with the first point of the set
//    lowestPt = [[pSetOfPts ptAtIndex:0] retain];

    // If a point in the set have a X coordinate > to the first one, it's the new rightmost
    for (unsigned int i = 0; i < [pSetOfPts nbOfPts]; i++) {
        if ([[pSetOfPts ptAtIndex:i] y] < [lowestPt y]) {
            if (lowestPt != [pSetOfPts ptAtIndex:i]) {
//                [lowestPt release];
//                lowestPt = [[pSetOfPts ptAtIndex:i] retain];
                lowestPt = [pSetOfPts ptAtIndex:i];
            }

        }
    }

    return lowestPt;

}

- (Pt2f*) extremePtInSet:(SetOfPt2f*) pSetOfPts InDirection:(Vec2f*) pDirection
{
    NSAssert([pSetOfPts nbOfPts] > 0 , @"Empty set!!");
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

    for (NSUInteger i = 0; i < [pSetOfPts nbOfPts]; i++) {
        Pt2f* lTmp = [[Pt2f alloc] init];
        [lTmp setX:([[pSetOfPts ptAtIndex:i] x]*lCosAngle        + [[pSetOfPts ptAtIndex:i] y]*lSinAngle)];
        [lTmp setY:([[pSetOfPts ptAtIndex:i] x]*lSinAngle*(-1.0) + [[pSetOfPts ptAtIndex:i] y]*lCosAngle)];
        [lSet addPt:lTmp];
        [lTmp release];
    }

    Pt2f* lExtremePt = [self rightmostPtInSet:lSet];
    NSUInteger lIndex = [lSet indexFromPt:lExtremePt];

    [lSet removeAllPts];
    [lSet release];

    return [pSetOfPts ptAtIndex:lIndex];

}

- (Pt2f*) furthestFromOriginInSet:(SetOfPt2f*) pSetOfPts
{
    NSAssert([pSetOfPts nbOfPts] > 0 , @"Empty set!!");

    SetOfPt2f* lSet = [[SetOfPt2f alloc] init];

    for (NSUInteger i = 0; i < [pSetOfPts nbOfPts]; i++) {
        Pt2f* lTmp = [[Pt2f alloc] init];
        [lTmp setX: ([[pSetOfPts ptAtIndex:i] x]*[[pSetOfPts ptAtIndex:i] x] + [[pSetOfPts ptAtIndex:i] y]*[[pSetOfPts ptAtIndex:i] y])];
        [lSet addPt:lTmp];
        [lTmp release];
    }

    Pt2f* lExtremePt = [self rightmostPtInSet:lSet];
    NSUInteger lIndex = [lSet indexFromPt:lExtremePt];

    [lSet removeAllPts];
    [lSet release];

    return [pSetOfPts ptAtIndex:lIndex];
}

- (Pt2f*) minimumAngleInSet:(SetOfPt2f*) pSetOfPts
{
    NSAssert([pSetOfPts nbOfPts] > 0 , @"Empty set!!");

    Vec2f* lTmpVec = [[Vec2f alloc] init];
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


    for (NSUInteger i = 0; i < [pSetOfPts nbOfPts]; i++) {

        // Create a vector corresponding to the current point and normalize it.
        [lTmpVec setX: [[pSetOfPts ptAtIndex:i] x]];
        [lTmpVec setY:[[pSetOfPts ptAtIndex:i] y]];
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
        return [pSetOfPts ptAtIndex:lPtIdx];
    } else {
        return [pSetOfPts ptAtIndex:lPtIdx2];
    }

}

- (void) minimumVerticalStripInSet:(SetOfPt2f*) pSetOfPts WithLDS:(Pt2f*) pPtL1 LUS:(Pt2f*) pPtL2 RDS:(Pt2f*) pPtR1 RUS:(Pt2f*) pPtR2
{
    Pt2f* lTmp = nil;

    lTmp = [self leftmostPtInSet:pSetOfPts];
    [pPtL1 setWithX:[lTmp x] Y:[lTmp y]];
    [pPtL2 setWithX:[lTmp x] Y:([lTmp y] + 1.0)];

    lTmp = [self rightmostPtInSet:pSetOfPts];
    [pPtR1 setWithX:[lTmp x] Y:[lTmp y]];
    [pPtR2 setWithX:[lTmp x] Y:([lTmp y] + 1.0)];

}

- (void) minimumOrientedStripInSet:(SetOfPt2f *)pSetOfPts InDirection:(Vec2f*) pVec1 WithLDS:(Pt2f *)pPtL1 LUS:(Pt2f *)pPtL2 RDS:(Pt2f *)pPtR1 RUS:(Pt2f *)pPtR2
{
    Vec2f* lOrthogonalDirection = [[Vec2f alloc] init];
    [lOrthogonalDirection setWithX:((-1)*[pVec1 y]) Y:[pVec1 x]];

    pPtL1 = [self extremePtInSet:pSetOfPts InDirection:lOrthogonalDirection];
    [lOrthogonalDirection multiplyByScalar:(-1)];
    pPtR1 = [self extremePtInSet:pSetOfPts InDirection:lOrthogonalDirection];

    [pPtL2 setWithX:[pPtL1 x] Y:[pPtL1 y]];
    [pPtL2 translateWithVector:pVec1];

    [pPtR2 setWithX:[pPtR1 x] Y:[pPtR1 y]];
    [pPtR2 translateWithVector:pVec1];

    [lOrthogonalDirection release];
}

- (void) boundingBoxOfSet:(SetOfPt2f*) pSetOfPts WithLDC:(Pt2f *)pPtL1 LUC:(Pt2f *)pPtL2 RUC:(Pt2f *)pPtR1 RDC:(Pt2f *)pPtR2
{
    Pt2f* lUp = [self uppermostPtInSet:pSetOfPts];
    Pt2f* lDown = [self lowestPtInSet:pSetOfPts];
    Pt2f* lLeft = [self leftmostPtInSet:pSetOfPts];
    Pt2f* lRight = [self rightmostPtInSet:pSetOfPts];

    [pPtL1 setWithX:[lLeft x] Y:[lDown y]];
    [pPtL2 setWithX:[lLeft x] Y:[lUp y]];
    [pPtR1 setWithX:[lRight x] Y:[lDown y]];
    [pPtR2 setWithX:[lRight x] Y:[lUp y]];
}


@end
