#!/usr/bin/python
# coding=utf-8
import numpy as np
from numpy import linalg
from Point import Point
from Triangles import Triangles
from pyglet.gl import *
import random
global pointsInTriangulation, points, triangles, shouldDeleted
window = pyglet.window.Window(600, 600, caption='Triangulation')
global angle1, angle2
global R, p, k
global size
global maspoints1
global maspoints2
global scale
scale = 1
shouldDeleted = []

def condDelaune(triangle1, triangle2):
    a = np.array([[triangle1.v[i].x, triangle1.v[i].y, 1] for i in range(len(triangle1.v))])
    a = linalg.det(a)

    b = np.array(
        [[pow(triangle1.v[i].x, 2) + pow(triangle1.v[i].y, 2), triangle1.v[i].y, 1] for i in range(len(triangle1.v))])
    b = linalg.det(b)

    c = np.array(
        [[pow(triangle1.v[i].x, 2) + pow(triangle1.v[i].y, 2), triangle1.v[i].x, 1] for i in range(len(triangle1.v))])
    c = linalg.det(c)

    d = np.array([[pow(triangle1.v[i].x, 2) + pow(triangle1.v[i].y, 2), triangle1.v[i].x, triangle1.v[i].y] for i in
                  range(len(triangle1.v))])
    d = linalg.det(d)

    x = b / (2 * a)
    y = -c / (2 * a)
    center = Point(x, y)
    r_pow2 = (b ** 2 + c ** 2 - 4 * a * d) / (4 * pow(a, 2))
    for i in range(len(triangle2.v)):
        buf = (triangle2.v[i].x - center.x) ** 2 + (triangle2.v[i].y - center.y) ** 2
        if (buf < r_pow2):
            return False
    return True


def condDelaune2(triangle, point):
    a = np.array([[triangle.v[i].x, triangle.v[i].y, 1] for i in range(len(triangle.v))])
    a = linalg.det(a)
    b = np.array(
        [[pow(triangle.v[i].x, 2) + pow(triangle.v[i].y, 2), triangle.v[i].y, 1] for i in range(len(triangle.v))])
    b = linalg.det(b)
    c = np.array(
        [[pow(triangle.v[i].x, 2) + pow(triangle.v[i].y, 2), triangle.v[i].x, 1] for i in range(len(triangle.v))])
    c = linalg.det(c)
    d = np.array([[pow(triangle.v[i].x, 2) + pow(triangle.v[i].y, 2), triangle.v[i].x, triangle.v[i].y] for i in
                  range(len(triangle.v))])
    d = linalg.det(d)
    x = b / (2 * a)
    y = -c / (2 * a)
    center = Point(x, y)
    # R = b**2+c**2-4*a*d/(4*pow(a,2))
    # r = (point.x - center.x)**2 + (point.y - center.y)**2
    for i in range(3):
        sign = a / abs(a)
        res = (a * (point.x ** 2 + point.y ** 2) - b * triangle.v[i].x + c * triangle.v[i].y - d) * sign
        if (res < 0):
            return False
    return True


def condDelaune3(triangle, id_edge, point):
    v1 = triangle.edge[id_edge].v1
    v2 = triangle.edge[id_edge].oppositePoint
    v3 = triangle.edge[id_edge].v1
    cos_a = (point.x - v1.x) * (point.x - v3.x) + (point.y - v1.y) * (point.y - v3.y)
    cos_b = (v2.x - v1.x) * (v2.x - v3.x) + (v2.y - v1.y) * (v2.y - v3.y)

    if (cos_a < 0 and cos_b < 0): return False;
    if (cos_a >= 0 and cos_b >= 0): return True;

    sin_a = abs((point.x - v1.x) * (point.y - v3.y) - (point.x - v3.x) * (point.y - v1.y))
    sin_b = abs((v2.x - v1.x) * (v2.y - v3.y) - (v2.x - v3.x) * (v2.y - v1.y))
    return sin_a * cos_b + cos_a * sin_b >= 0


def convex(id_T1, id_T2, setT1Edges, setT2Edges):
    for i in setT1Edges:
        for j in setT2Edges:
            v1 = triangles[id_T2].edge[j].v1
            v2 = triangles[id_T2].edge[j].v2
            if (not triangles[id_T1].edge[i].existCommonVertex(v1) and not triangles[id_T1].edge[i].existCommonVertex(
                    v2)):
                if (not triangles[id_T1].edge[i].isOneSide(v1, v2)):
                    return False
            v1 = triangles[id_T1].edge[i].v1
            v2 = triangles[id_T1].edge[i].v2
            if (not triangles[id_T2].edge[j].existCommonVertex(v1) and not triangles[id_T2].edge[j].existCommonVertex(
                    v2)):
                if (not triangles[id_T2].edge[j].isOneSide(v1, v2)):
                    return False
    return True

def generatePoints(count):
    return [Point(random.triangular(-500., 500.), random.triangular(-500., 500.)) for i in range(count)]


def drawTriangle(triangle):
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    glBegin(GL_TRIANGLES)
    glColor3f(random.triangular(0, 1), random.triangular(0, 1), random.triangular(0, 1))  # yellow
    glVertex2f(triangle.v[0].x, triangle.v[0].y)
    glColor3f(random.triangular(0, 1), random.triangular(0, 1), random.triangular(0, 1))  # yellow
    glVertex2f(triangle.v[1].x, triangle.v[1].y)
    glColor3f(random.triangular(0, 1), random.triangular(0, 1), random.triangular(0, 1))  # yellow
    glVertex2f(triangle.v[2].x, triangle.v[2].y)
    glEnd()

def printTriangles():
    for i in range(len(triangles)):  # {
        print("=================================")
        print("id = ", i)
        for k in range(3):
            print("edge ", k, " :")
            print("x= ", triangles[i].edge[k].v1.x, " y= ", triangles[i].edge[k].v1.y)
            print("x= ", triangles[i].edge[k].v2.x, " y= ", triangles[i].edge[k].v2.y)


def notSuperStructure(id):
    global size
    for i in range(3):
        if (triangles[id].v[i].x == size or triangles[id].v[i].x == -size):
            return False
        if (triangles[id].v[i].y == size or triangles[id].v[i].y == -size):
            return False
    return True


def rebuild(addTriangles):
    global triangles, shouldDeleted
    for triangle in addTriangles:
        id_addT = triangles.index(triangle)
        # находим соседа по каждому из ребер треугольников, добавленных на предыдущем шаге
        for j in range(3):
            neighbor = triangles[id_addT].neighbors.get(j)
            if (neighbor != None and neighbor not in addTriangles):
                id_neighbor = triangles.index(neighbor)
                id_edgeAddT, id_edgeOldT = triangles[id_addT].findAnalogEdge(triangles[id_neighbor])
                oppositePointAddT = triangles[id_addT].edge[id_edgeAddT].oppositePoint
                oppositePointOldT = triangles[id_neighbor].edge[id_edgeOldT].oppositePoint
                setAddTEdges = [0, 1, 2]
                setOldTEdges = [0, 1, 2]
                setAddTEdges.pop(id_edgeAddT)
                setOldTEdges.pop(id_edgeOldT)
                # проверка на условие Делане и выпуклость четырехугольника
                if (not condDelaune2(triangles[id_neighbor], oppositePointAddT) and convex(id_addT, id_neighbor,
                                                                                           setAddTEdges,
                                                                                           setOldTEdges)) and notSuperStructure(
                    id_neighbor):
                    shouldDeleted.append(triangles[id_addT])
                    shouldDeleted.append(triangles[id_neighbor])
                    len_ = len(triangles)
                    triangles.append(Triangles(oppositePointAddT,
                                               oppositePointOldT,
                                               triangles[id_addT].edge[id_edgeAddT].v1)
                                     )
                    triangles.append(Triangles(oppositePointAddT,
                                               oppositePointOldT,
                                               triangles[id_addT].edge[id_edgeAddT].v2)
                                     )
                    # добавляем в соседи друг друга
                    triangles[len_].addNewNeighborT(triangles[len_ + 1])
                    #
                    for k in setOldTEdges:
                        if triangles[id_neighbor].neighbors.get(k) != None:
                            id_neighb = triangles.index(triangles[id_neighbor].neighbors.get(k))
                            for id in range(len_, len_ + 2):
                                triangles[id].addAlreadyExistNeighborT(triangles[id_neighb])

                    for j in setAddTEdges:
                        if triangles[id_addT].neighbors.get(j) != None:
                            id_neighb = triangles.index(triangles[id_addT].neighbors.get(j))
                            for id in range(len_, len_ + 2):
                                triangles[id].addAlreadyExistNeighborT(triangles[id_neighb])

                    for id in range(len(shouldDeleted)):
                        triangles.pop(triangles.index(shouldDeleted[id]))
                    shouldDeleted.clear()
                    break
    return


def triangulationIfBelongsEdge(k, cur, idEdgeCur):
    global triangles, points
    id_1 = len(triangles)
    triangles.append(Triangles(triangles[cur].edge[idEdgeCur].v1,
                               points[k],
                               triangles[cur].edge[idEdgeCur].oppositePoint,
                               )
                     )
    triangles.append(Triangles(triangles[cur].edge[idEdgeCur].v2,
                               points[k],
                               triangles[cur].edge[idEdgeCur].oppositePoint,
                               ))
    # находим id соседа по ребру, на которое попадает точка
    neighbordId = triangles.index(triangles[cur].neighbors.get(idEdgeCur))
    # вычисляем id того же ребра в соседнем треугольнике
    idEdgeNeighb = triangles[cur].findAnalogEdge(triangles[neighbordId], idEdgeCur)
    triangles.append(Triangles(triangles[neighbordId].edge[idEdgeNeighb].v1,
                               points[k],
                               triangles[neighbordId].edge[idEdgeNeighb].oppositePoint,
                               )
                     )
    triangles.append(Triangles(triangles[neighbordId].edge[idEdgeNeighb].v2,
                               points[k],
                               triangles[neighbordId].edge[idEdgeNeighb].oppositePoint,
                               )
                     )
    # добавить соседей только что созданных соседей
    for i in range(id_1, len(triangles)):
        for id in range(i + 1, len(triangles)):
            triangles[id].addNewNeighborT(triangles[i])

    setCurEdges = [0, 1, 2]
    setNeighbordEdges = [0, 1, 2]

    setCurEdges.pop(idEdgeCur)
    setNeighbordEdges.pop(idEdgeNeighb)
    # добавить уже существующих соседей
    # надо получить id ребра в соседнем треугольнике
    for i in setCurEdges:
        if (triangles[cur].neighbors.get(i) != None):
            id_neighb_cur = triangles.index(triangles[cur].neighbors.get(i))
            for id in range(id_1, id_1 + 2):
                triangles[id].addAlreadyExistNeighborT(triangles[id_neighb_cur])
    trianglesN = triangles[neighbordId]

    for i in setNeighbordEdges:
        if (triangles[neighbordId].neighbors.get(i) != None):
            id_neighb_neighb = triangles.index(triangles[neighbordId].neighbors.get(i))
            print(id_neighb_neighb)
            for id in range(id_1 + 2, len(triangles)):
                triangles[id].addAlreadyExistNeighborT(triangles[id_neighb_neighb])
    triangles.pop(cur)
    triangles.pop(triangles.index(trianglesN))
    return [triangles[len(triangles) - i] for i in range(1, 5)]


def insideTriangle(k, triangle):
    global triangles, shouldDeleted
    neighbords = []
    newTriangles = []
    id_last = len(triangles)
    cur = triangles.index(triangle)
    for i in range(0, 3):
        triangles.append(Triangles(
                                    triangles[cur].edge[i].v1,
                                    points[k],
                                    triangles[cur].edge[i].v2,
                                  )
                        )
        if (triangles[cur].neighbors.get(i) != None):
            # находим id соседа по ребру
            neighbordId = triangles.index(triangles[cur].neighbors.get(i))
            (idNewTedge, idOldTedge) = triangles[id_last + i].addAlreadyExistNeighborT(triangles[neighbordId])
            # переделать в commonEdge = {T : edge,...} и удалять старый Т в конце
            newTriangles.append([id_last + i, idNewTedge])
            neighbords.append([neighbordId, idOldTedge])
    # добавляем друг с другом
    for i in range(id_last + 1, id_last + 3):
        triangles[id_last].addNewNeighborT(triangles[i])
    triangles[id_last + 1].addNewNeighborT(triangles[id_last + 2])
    triangles.pop(cur)
    return [triangles[len(triangles) - i] for i in range(1, 4)]


def triangulation(id_point, triangle):
    global triangles, points, pointsInTriangulation, shouldDeleted
    cur = triangles.index(triangle)
    # проверка на совпадение точек
    if points[id_point] not in pointsInTriangulation:
        # проверяем принадлежит ли точка ребру
        for id_edge in range(3):
            if (triangles[cur].edge[id_edge].onEdge(points[id_point])):  # если принадлежит
                addTriangles = triangulationIfBelongsEdge(id_point, cur, id_edge)
                rebuild(addTriangles)
                return cur
            # проверяем с одной ли строны точка и противоположная вершина от ребра текущего треугольника
            elif (not triangles[cur].edge[id_edge].isOneSide1(points[id_point])):  # если с другой стороны стороны
                triangle = triangles[cur].neighbors.get(id_edge)
                cur = triangles.index(triangle)
                triangulation(id_point, triangle)
                return cur
        # значит точка внутри текущего треугольника
        addTriangles = insideTriangle(id_point, triangle)
        rebuild(addTriangles)
        return cur


@window.event
def on_draw():
    global scale, n, triangles, points, pointsInTriangulation, size
    window.clear()
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glEnable(GL_DEPTH_TEST)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    size = 500.
    glOrtho(-size, size, -size, size, -size, size)
    glScalef(scale, scale, scale)

    #Добавление суперструктуры
    pointsInTriangulation = [
                                Point(-size,  size),
                                Point( size,  size),
                                Point( size, -size),
                                Point(-size, -size),
                            ]
    #
    triangles = [
                Triangles(
                           pointsInTriangulation[0],
                           pointsInTriangulation[1],
                           pointsInTriangulation[3],
                           ),
                 Triangles(
                           pointsInTriangulation[2],
                           pointsInTriangulation[3],
                           pointsInTriangulation[1],
                           ),
                 ]
    # добавляем соседей
    triangles[0].addNewNeighborT(triangles[1])

    points = generatePoints(10)
    # обработка оставшихся точек
    current = 0
    for id_point in range(0, len(points)):
        current = triangulation(id_point, triangles[current])
        pointsInTriangulation.append(points[id_point])

    for i in range(len(triangles)):
        drawTriangle(triangles[i])

pyglet.app.run()
