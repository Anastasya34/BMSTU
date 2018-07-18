from Point import Point


class Edge:
    def __init__(self, v1, v2, opposite):
        # уравнение прямой ax+by+c=0
        self.A = v1.y - v2.y
        self.B = v2.x - v1.x
        self.C = v1.x * v2.y - v2.x * v1.y
        # соотв вершины треугольника
        self.v1 = v1
        self.v2 = v2
        # вершина противоположная линии
        self.oppositePoint = opposite

    def onEdge(self, point):
        if (self.A * point.x + self.B * point.y + self.C == 0):
            return True
        return False

    def existCommonVertex(self, point):
        if (self.v1.x == point.x and self.v1.y == point.y):
            return True
        if (self.v2.x == point.x and self.v2.y == point.y):
            return True
        return False

    def createVect(self, point1, point2):
        return Point(point2.x - point1.x, point2.y - point1.y)

    def isOneSide(self, point1, point2):
        # косоле произведение векторов(псевдоскалярное)
        # вектор на ребре треугольника
        vectEdge = self.createVect(self.v1, self.v2)
        # вектор от точки на ребре до противоположной ребру вершине треугольника
        vectWithPoint1 = self.createVect(self.v1, point1)
        pointPos1 = vectEdge.x * vectWithPoint1.y - vectWithPoint1.x * vectEdge.y
        vectWithPoint2 = self.createVect(self.v1, point2)
        pointPos2 = vectEdge.x * vectWithPoint2.y - vectWithPoint2.x * vectEdge.y
        if (pointPos1 * pointPos2 > 0):
            return True
        return False

    def isOneSide1(self, point):
        # косоле произведение векторов(псевдоскалярное)
        # вектор на ребре треугольника
        vectEdge = self.createVect(self.v1, self.v2)
        # вектор от точки на ребре до противоположной ребру вершине треугольника
        vectOpos = self.createVect(self.v1, self.oppositePoint)
        oppositePos = vectEdge.x * vectOpos.y - vectOpos.x * vectEdge.y
        vectWithPoint = self.createVect(self.v1, point)
        pointPos = vectEdge.x * vectWithPoint.y - vectWithPoint.x * vectEdge.y
        if (oppositePos * pointPos > 0):
            return True
        return False

    def isOneSide2(self, point):
        oppositePos = self.A * self.oppositePoint.x + self.B * self.oppositePoint.y + self.C
        pointPos = self.A * point.x + self.B * point.y + self.C
        if (oppositePos * pointPos > 0):
            return True
        return False