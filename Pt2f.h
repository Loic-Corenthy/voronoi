// Basic imports
#import <Foundation/Foundation.h>

// Local imports
#import "Vec2f.h"

@interface Pt2f : NSObject
{
    double x;
    double y;
}

#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;

/// Gets
- (double) x;
- (double) y;
- (double) valueAtIndex:(NSInteger)pIndex;

/// Sets
- (void) setX:(double)pX;
- (void) setY:(double)pY;
- (void) setWithX:(double)pX Y:(double)pY;
- (void) setValueAtIndex:(NSInteger) pIndex Value:(double) pValue;

/// Compare 2 points
- (BOOL) isEqual:(Pt2f*) pPt;

#pragma mark -
#pragma mark Functionality methods

/// Translate a point
- (void) translateWithVector:(Vec2f*) pVect;

@end

