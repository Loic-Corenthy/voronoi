#import <Foundation/Foundation.h>

@interface Vec2f : NSObject
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
- (double) valueAtIndex:(NSInteger) pIndex;

/// Sets
- (void) setX:(double) pX;
- (void) setY:(double) pY;
- (void) setWithX:(double) pX Y:(double) pY;

#pragma mark -
#pragma mark Functionality methods

/// Add a vector to the current one
- (void) addVector:(Vec2f*) pVector;

/// Substract vector to the current one
- (void) substractVector:(Vec2f*) pVector;

/// Multiply by a scalar
- (void) multiplyByScalar:(double) pScalar;

/// Scalar product
- (double) scalarProductWith:(Vec2f*) pVec1;

/// Get length of the vector
- (double) length;

/// Normalize vector
- (void) normalize;


@end