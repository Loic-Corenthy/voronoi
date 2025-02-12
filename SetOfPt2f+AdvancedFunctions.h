#import "SetOfPt2f.h"

@class DCEL;

@interface SetOfPt2f (SetOfPt2f_AdvancedFunctions)

#pragma mark -
#pragma mark Advanced geometric methods

/// Create the convex hull of the set of points
- (SetOfPt2f*) convexHull;

/// Create a monotone polygon joining all the points of the set
- (SetOfPt2f*) polygonizeMono;

/// Create an angular triangulation of the set of points
- (SetOfPt2f*) triangularizeAngular;

@end
