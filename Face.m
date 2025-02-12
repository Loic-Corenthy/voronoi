#import "Face.h"
#import "IdxPt2f.h"


@implementation Face

#pragma mark -
#pragma mark Properties

@synthesize faceId;
@synthesize outCmpId;
@synthesize inCmpId;
@synthesize circumcircle;

#pragma mark -
#pragma mark Basic methods

- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        faceId      = 0;
        outCmpId    = 0;
        inCmpId     = 0;
        circumcircle = [[IdxPt2f alloc] init];
        [circumcircle setWithX:0.0 Y:0.0];
        [circumcircle setIdx:0];
        [circumcircle setParameter:0.0];
    }

    return self;
}

- (void) dealloc
{
    [circumcircle release];
    [super dealloc];
}

#pragma mark -
#pragma mark Circumcircle methods

- (void) setCircumcircleCenterWithX:(double)pX Y:(double)pY
{
    [circumcircle setWithX:pX Y:pY];
}


- (void) setCircumcircleRadius:(double)pR
{
    [circumcircle setParameter:pR];
}

@end
