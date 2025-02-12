// Basic imports
#import <Foundation/Foundation.h>

// Local imports
#import "Pt2f.h"
#import "SetOfPt2f.h"

@interface BasicFunctions : NSObject

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;


/**************************************************/
/*	BASIC GEOMETRIC PRIMITIVES					  */
/**************************************************/


/// Distance between 2 points
- (double) distanceBetweenPtA:(Pt2f*) pPtA andPtB:(Pt2f*) pPtB;

/// Signed area of a triangle defined by 3 points
- (double) signedAreaBetweenPtA:(Pt2f*) pPtA PtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC;

/// Orientation of 3 points: Sign only of the signed area of a triangle defined by 3 points.  1 : Positive sign, -1 : Negative sign, 0 : No sign, points are aligned
- (int) orientationOfPtA:(Pt2f*) pPtA PtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC;

/// Check if the 3 points are aligned
- (BOOL) alignmentOfPtA:(Pt2f*) pPtA PtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC;

/// Distance between a point and a line. If the points defining the line are identical, return distance between the point and the first point defining the line
- (double) distanceBetweenPtA:(Pt2f*) pPtA AndLineBCwithPtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC;

/// Distance between a point and a segment. If the points defining the line are identical, return distance between the point and the first point defining the line. If the point is not perpendicularly placed with reference to the segment, return the distance between the point and the closest point defining the segment.
- (double) distanceBetweenPtA:(Pt2f*) pPtA AndSegmentBCwithPtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC;

/// Test if a point belongs to a segment.
- (BOOL) isPtA:(Pt2f*) pPtA InSegmentBCWithPtB:(Pt2f*) pPtB andPtC:(Pt2f*) pPtC;

/// Test if a point is inside a triangle. The point to be tested cannot be one of the points defining the triangle
- (BOOL) isPtA:(Pt2f*) pPtA InTriangleBCDWithPtB:(Pt2f*) pPtB PtC:(Pt2f*) pPtC andPtD:(Pt2f*) pPtD;

/// Test if 2 segments are intersecting
- (BOOL) isSegmentABWithPtA:(Pt2f*) pPtA andPtB:(Pt2f*) pPtB IntersectingSegmentCDWithPtC:(Pt2f*) pPtC andPtD:(Pt2f*) pPtD;


/**************************************************/
/*	EXTREME POINTS								  */
/**************************************************/

/// Determine the point of the set with the maximum value in X coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (Pt2f*) rightmostPtInSet:(SetOfPt2f*) pSetOfPts;

/// Determine the point of the set with the minimum value in X coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (Pt2f*) leftmostPtInSet:(SetOfPt2f*) pSetOfPts;

/// Determine the point of the set with the maximum value in Y coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (Pt2f*) uppermostPtInSet:(SetOfPt2f*) pSetOfPts;

/// Determine the point of the set with the minimum value in Y coordinate. Return a pointer on that point, do not allocate memory for the returned pointer!!!!
- (Pt2f*) lowestPtInSet:(SetOfPt2f*) pSetOfPts;

/// Determine the point of the set with the maximum value in X coordinate after basis transformation.
- (Pt2f*) extremePtInSet:(SetOfPt2f*) pSetOfPts InDirection:(Vec2f*) pDirection;

/// Determine the point of the set with the maximum norm.
- (Pt2f*) furthestFromOriginInSet:(SetOfPt2f*) pSetOfPts;

/// Determine the point M of the set such that the positive oriented angle (M,O,U) is minimum. U is the point (1,0)
- (Pt2f*) minimumAngleInSet:(SetOfPt2f*) pSetOfPts;


/// Compute the minimum vertical strip that contains the set of points. The result is a set of 4 points: - the left down strip (LDS), the left up strip (LUS), the right down strip (RDS) and the right up strip (RUS)
- (void) minimumVerticalStripInSet:(SetOfPt2f*) pSetOfPts WithLDS:(Pt2f*) pPtL1 LUS:(Pt2f*) pPtL2 RDS:(Pt2f*) pPtR1 RUS:(Pt2f*) pPtR2;

/// Compute the minimum strip that contains the set of points in a specific direction. The result is a set of 4 points: - the left down strip (LDS), the left up strip (LUC), the right down strip (RDS) and the right up strip (RUS)
- (void) minimumOrientedStripInSet:(SetOfPt2f *)pSetOfPts InDirection:(Vec2f*) pVec1 WithLDS:(Pt2f *)pPtL1 LUS:(Pt2f *)pPtL2 RDS:(Pt2f *)pPtR1 RUS:(Pt2f *)pPtR2;

/// Compute the bounding box containing all the points. The result corresponds to 4 points: the left down corner (LDC), the left up corner (LUC), the right down corner (RDS) and the right up corner (RUS)
- (void) boundingBoxOfSet:(SetOfPt2f*) pSetOfPts WithLDC:(Pt2f *)pPtL1 LUC:(Pt2f *)pPtL2 RUC:(Pt2f *)pPtR1 RDC:(Pt2f *)pPtR2;


@end







