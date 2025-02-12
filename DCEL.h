#import <Foundation/Foundation.h>
#import "SetOfPt2f+BasicFunctions.h"

@class IdxPt2f;
@class SetOfPt2f;
@class Vertex;
@class Face;
@class HalfEdge;

@interface DCEL : NSObject
{
    NSMutableArray* arrayOfVertices;
    NSMutableArray* arrayOfFaces;
    NSMutableArray* arrayOfHalfEdges;

    NSUInteger numberOfVertices;
    NSUInteger numberOfFaces;
    NSUInteger numberOfHalfEdges;
}

#pragma mark -
#pragma mark Properties

@property (readonly) NSMutableArray* arrayOfVertices;
@property (readonly) NSMutableArray* arrayOfFaces;
@property (readonly) NSMutableArray* arrayOfHalfEdges;
@property (readonly) NSUInteger numberOfVertices;
@property (readonly) NSUInteger numberOfFaces;
@property (readonly) NSUInteger numberOfHalfEdges;

#pragma mark -
#pragma mark Basic methods

/// Initialization
- (id) init;

/// Free memory
- (void) dealloc;

/// Remove all the vertices, plans (except the whole plan) and half edges
- (void) reset;

#pragma mark -
#pragma mark Interaction with the DCEL

/// Manualy add a vertex ( the user has to specify the correct parameters, debug function)
- (void) addVertex:(Vertex*)pV;

/// Manualy add a face ( the user has to specify the correct parameters, debug function)
- (void) addFace:(Face*)pF;

/// Manualy add a half edge ( the user has to specify the correct parameters, debug function)
- (void) addHalfEdge:(HalfEdge*)pHE;

/// Flip an edge (keep the same half edges but change connections, idem for the faces)
- (void) flipHalfEdge:(NSUInteger)pHalfEdgeId;

/// Calculate the circle passing through the 3 vertices of a face (triangle). The center and the radius are stored in the face.
- (void) circumcircleOfFace:(Face*)pF;

/// Get the opposite point of a half edge
- (IdxPt2f*) oppositePointOfHalfEdgeWith:(HalfEdge*)pHE;

/// Check if a point correspond to a vertex which is already in the DCEL and retun its Id. (return -2 if the point is not found)
- (NSInteger) isAlreadyInWith:(IdxPt2f*)pPt;

/// Sorted list of edges that are incident to a given vertex
- (NSArray*) incidentHalfEdgesOfVertexWith:(Vertex*)pV;

/// Sorted list of edges of a given face
- (NSArray*) halfEdgesOfFaceWith:(Face*)pF;

/// list of adjacent faces of a given face
- (NSMutableArray*) adjacentFacesOfFaceWith:(Face*)pF;

/// Get Vertex corresponding to specific Id
- (Vertex*) vertexFromId:(NSUInteger)pValue;

/// Get Face corresponding to specific Id
- (Face*) faceFromId:(NSUInteger)pValue;

/// Get HalfEdge corresponding to specific Id
- (HalfEdge*) halfEdgeFromId:(NSUInteger)pValue;

/// Update the DCEL with the set of points
- (void) buildDCELFromSetOfPts:(SetOfPt2f*)pAllPts;

#pragma mark -
#pragma mark Get specific graph from DCEL

/// Generate delaunay triangulation from the triangular one
- (void) transformToDelaunayTriangulationWithMaxIteration:(NSUInteger)pMax;

/// Get Voronoi diagram from Delaunay triangulation
- (SetOfPt2f*) voronoiFromDelaunayTriangulation;

#pragma mark -
#pragma mark Debug methods

/// DEBUG Display the vertices, half edges and faces of the DCEL
- (void) displayWithVertices:(BOOL)pDispV andHalfEdges:(BOOL)pDispHE andFaces:(BOOL)pDispF;

/// DEBUG Display retain count of elements of the DCEL
- (void) displayRetainCount;

@end
