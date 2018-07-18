from Edge import Edge

class Triangles:
    def __init__(self, v1, v2, v3):
        self.v = [None] * 3
        self.v[0] = v1
        self.v[1] = v2
        self.v[2] = v3
        self.edge = [None] * 3
        self.edge[0] = Edge(v1, v2, opposite=v3)
        self.edge[1] = Edge(v2, v3, opposite=v1)
        self.edge[2] = Edge(v3, v1, opposite=v2)
        self.neighbors = {0: None,
                          1: None,
                          2: None}

    def addNeighborKV(self, edge_i, triangle):
        self.neighbors.update({edge_i: triangle})

    def findAnalogEdge(self, triangle, id_selfEdge=None):
        if id_selfEdge != None:
            for i in range(3):
                if ((self.edge[id_selfEdge].v1 == triangle.edge[i].v1) and (self.edge[id_selfEdge].v2 == triangle.edge[i].v2)) or (
                    (self.edge[id_selfEdge].v1 == triangle.edge[i].v2) and (self.edge[id_selfEdge].v2 == triangle.edge[i].v1)):
                    return i
            return None
        else:
            for id_selfEdge in range(3):
                for i in range(3):
                    if ((self.edge[id_selfEdge].v1 == triangle.edge[i].v1) and (self.edge[id_selfEdge].v2 == triangle.edge[i].v2)) or (
                        (self.edge[id_selfEdge].v1 == triangle.edge[i].v2) and (self.edge[id_selfEdge].v2 == triangle.edge[i].v1)):
                        return (id_selfEdge, i)
            return (None,None)

    def addNewNeighborT(self, neighbor):
        id_edgeSelf, id_edgeNeighbor = self.findAnalogEdge(neighbor)
        if id_edgeNeighbor != None:
            self.neighbors[id_edgeSelf] = neighbor
            neighbor.addNeighborKV(id_edgeNeighbor, self)
            return (id_edgeSelf, id_edgeNeighbor)
        return None

    def addAlreadyExistNeighborT(self, neighbor):
        id_edgeSelf, id_edgeNeighbor = self.findAnalogEdge(neighbor)
        if id_edgeNeighbor != None:
            self.neighbors[id_edgeSelf] = neighbor
            neighbor.neighbors.update({id_edgeNeighbor: self})
            return (id_edgeSelf, id_edgeNeighbor)
        return (None,None)