#import "IdxPt2f.h"

@implementation IdxPt2f

#pragma mark -
#pragma mark Properties

@synthesize idx;
@synthesize parameter;

#pragma mark -
#pragma mark Basic methods

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        idx = 0;
        parameter = 0.0;
    }

    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
