#import <Foundation/Foundation.h>

@interface HalfEdge : NSObject
{
    NSUInteger halfEdgeId;
    NSUInteger originId;
    NSUInteger twinId;
    NSUInteger incidentFaceId;
    NSUInteger nextId;
    NSUInteger previousId;
}

#pragma mark -
#pragma mark Properties

@property (readwrite,assign) NSUInteger halfEdgeId;
@property (readwrite,assign) NSUInteger originId;
@property (readwrite,assign) NSUInteger twinId;
@property (readwrite,assign) NSUInteger incidentFaceId;
@property (readwrite,assign) NSUInteger nextId;
@property (readwrite,assign) NSUInteger previousId;

#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;

@end
