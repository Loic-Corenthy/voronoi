#import <Foundation/Foundation.h>

@class IdxPt2f;

@interface Face : NSObject
{
    NSUInteger faceId;
    NSInteger outCmpId;
    NSInteger inCmpId;
    IdxPt2f* circumcircle;
}

#pragma mark -
#pragma mark Properties

@property (readwrite,assign) NSUInteger faceId;
@property (readwrite,assign) NSInteger  outCmpId;
@property (readwrite,assign) NSInteger  inCmpId;
@property (readonly) IdxPt2f* circumcircle;


#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;

#pragma mark -
#pragma mark Circumcircle methods

/// Set circumcircle center
- (void) setCircumcircleCenterWithX:(double)pX Y:(double)pY;

/// Set circumcircle radius
- (void) setCircumcircleRadius:(double)pR;

@end
