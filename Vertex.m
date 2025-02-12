#import "Vertex.h"
#import "IdxPt2f.h"


@implementation Vertex

#pragma mark -
#pragma mark Properties

@synthesize coordinates;
@synthesize vertexId;
@synthesize incidentEdgeId;

#pragma mark -
#pragma mark Basic methods

- (id)init
{
    self = [super init];
    if (self) {
        coordinates = [[IdxPt2f alloc] init];
        vertexId = 0;
        incidentEdgeId = 0;
    }

    return self;
}

- (void)dealloc
{
    [coordinates release];
    [super dealloc];
}

@end
