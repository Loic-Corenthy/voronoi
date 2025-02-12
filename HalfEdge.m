#import "HalfEdge.h"

@implementation HalfEdge

#pragma mark -
#pragma mark Properties

@synthesize halfEdgeId;
@synthesize originId;
@synthesize twinId;
@synthesize incidentFaceId;
@synthesize nextId;
@synthesize previousId;

#pragma mark -
#pragma mark Basic methods

- (id)init
{
    self = [super init];
    if (self) {
        halfEdgeId      = 0;
        originId        = 0;
        twinId          = 0;
        incidentFaceId  = 0;
        nextId          = 0;
        previousId      = 0;
    }

    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
