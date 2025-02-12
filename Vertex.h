#import <Foundation/Foundation.h>

@class IdxPt2f;

@interface Vertex : NSObject
{
    IdxPt2f*    coordinates;
    NSUInteger  vertexId;
    NSUInteger  incidentEdgeId;
}

#pragma mark -
#pragma mark Properties

@property (readwrite,retain) IdxPt2f*   coordinates;
@property (readwrite,assign) NSUInteger vertexId;
@property (readwrite,assign) NSUInteger incidentEdgeId;

#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;

@end
