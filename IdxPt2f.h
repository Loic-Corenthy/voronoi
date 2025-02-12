#import "Pt2f.h"

@interface IdxPt2f : Pt2f
{
    NSUInteger  idx;
    double      parameter;
}

#pragma mark -
#pragma mark Properties

@property (readwrite,assign) NSUInteger idx;
@property (readwrite,assign) double     parameter;

#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;

@end
