#import "SetOfPt2f.h"
#import "IdxPt2f.h"

@interface SetOfPt2f (SetOfPt2f_BasicFunctions)

#pragma mark -
#pragma mark Basic geometry methods

/// Distance between 2 points
- (double) distanceBetweenPtA:(NSUInteger) pIdx1 andPtB:(NSUInteger) pIdx2;

/// Signed area of a triangle defined by 3 points
- (double) signedAreaBetweenPtA:(NSUInteger) pIdx1 PtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;

/// Orientation of 3 points: Sign only of the signed area of a triangle defined by 3 points.  1 : Positive sign, -1 : Negative sign, 0 : No sign, points are aligned
- (int) orientationOfPtA:(NSUInteger) pIdx1 PtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;

/// Check if the 3 points are aligned
- (BOOL) alignmentOfPtA:(NSUInteger) pIdx1 PtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;

/// Distance between a point and a line. If the points defining the line are identical, return distance between the point and the first point defining the line
- (double) distanceBetweenPtA:(NSUInteger) pIdx1 AndLineBCwithPtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;

/// Distance between a point and a segment. If the points defining the line are identical, return distance between the point and the first point defining the line. If the point is not perpendicularly placed with reference to the segment, return the distance between the point and the closest point defining the segment.
- (double) distanceBetweenPtA:(NSUInteger) pIdx1 AndSegmentBCwithPtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;

/// Test if a point belongs to a segment.
- (BOOL) isPtA:(NSUInteger) pIdx1 InSegmentBCWithPtB:(NSUInteger) pIdx2 andPtC:(NSUInteger) pIdx3;

/// Test if a point is inside a triangle. The point to be tested cannot be one of the points defining the triangle
- (BOOL) isPtA:(NSUInteger) pIdx1 InTriangleBCDWithPtB:(NSUInteger) pIdx2 PtC:(NSUInteger) pIdx3 andPtD:(NSUInteger) pIdx4;

/// Test if 2 segments are intersecting
- (BOOL) isSegmentABWithPtA:(NSUInteger) pIdx1 andPtB:(NSUInteger) pIdx2 IntersectingSegmentCDWithPtC:(NSUInteger) pIdx3 andPtD:(NSUInteger) pIdx4;

#pragma mark -
#pragma mark Extreme points methods

/// Determine the point of the set with the maximum value in X coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (IdxPt2f*) rightmostPt;

/// Determine the point of the set with the minimum value in X coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (IdxPt2f*) leftmostPt;

/// Determine the point of the set with the maximum value in Y coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (IdxPt2f*) uppermostPt;

/// Determine the point of the set with the minimum value in Y coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (IdxPt2f*) lowestPt;

/// Determine the point of the set with the maximum value in X coordinate after basis transformation.
- (IdxPt2f*) extremePtInDirection:(Vec2f*) pDirection;

/// Determine the point of the set with the maximum norm.
- (IdxPt2f*) furthestFromOrigin;

/// Determine the point M of the set such that the positive oriented angle (M,O,U) is minimum. U is the point (1,0)
- (IdxPt2f*) minimumAngle;

/// Compute the minimum vertical strip that contains the set of points. The result is a set of 4 points: - the left down strip (LDS), the left up strip (LUS), the right down strip (RDS) and the right up strip (RUS)
- (void) minimumVerticalStripWithLDS:(IdxPt2f*) pPtL1 LUS:(IdxPt2f*) pPtL2 RDS:(IdxPt2f*) pPtR1 RUS:(IdxPt2f*) pPtR2;

/// Compute the minimum strip that contains the set of points in a specific direction. The result is a set of 4 points: - the left down strip (LDS), the left up strip (LUC), the right down strip (RDS) and the right up strip (RUS)
- (void) minimumOrientedStripInDirection:(Vec2f*) pVec1 WithLDS:(IdxPt2f*)pPtL1 LUS:(IdxPt2f*)pPtL2 RDS:(IdxPt2f*)pPtR1 RUS:(IdxPt2f*)pPtR2;

/// Compute the bounding box containing all the points. The result corresponds to 4 points: the left down corner (LDC), the left up corner (LUC), the right down corner (RDS) and the right up corner (RUS)
- (void) boundingBoxWithLDC:(IdxPt2f*)pPtL1 LUC:(IdxPt2f*)pPtL2 RUC:(IdxPt2f*)pPtR1 RDC:(IdxPt2f*)pPtR2;

/// Divide the set of points in 2 groups: pSetUp containts the point upper the line going through the leftmost and rightmost points and pSetDown containts the point below the line going through the leftmost and rightmost points
- (void) divideSetInUp:(SetOfPt2f*) pSetUp andDown:(SetOfPt2f*) pSetDown;

#pragma mark -
#pragma mark Geometric sorting methods

/// Sort the points from left to right sorting by X coordinates.
- (SetOfPt2f*) sortLeftToRight;

/// Sort the points from bottom to top sorting by Y coordinates.
- (SetOfPt2f*) sortBottomToTop;


/// Sort the points in a specified direction by rotating all the points and then sorting by X coordinates.
- (SetOfPt2f*) sortInDirection:(Vec2f*) pDirection;

/// Sort angularly the points of the set. If P is one of the point of the set, the angle is the angle between the vector OP and the x axis.
- (SetOfPt2f*) sortAngularlyFromBottom;

/// Sort the points according to their distance to a point.
- (SetOfPt2f*) sortDistanceFromPoint:(IdxPt2f*) pPt;

@end
