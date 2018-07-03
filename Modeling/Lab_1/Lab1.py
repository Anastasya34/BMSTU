# coding=utf-8
import matplotlib.pyplot as plot
import math
global v_0
global alfa
global beta
global m
global g

for_u = 0
for_w = 1

def cross_sectional_area(d):
    return math.pi*pow(d/2,2)

def volume_sphere(d):
    return (4/3)*math.pi*pow(d/2,3)

def f_u(w, u):
    global beta,m
    root = math.sqrt(math.pow(u,2)+math.pow(w,2))
    return -(beta/m)*u*root

def f_w( u,  w):
    global beta,m
    root = math.sqrt(math.pow(u,2)+math.pow(w,2))
    return -(beta/m)*w*root-g

def next_iter_runge_cutta_2D(func,u,w,h):
    if (func == for_u):
        k1 = f_u(w, u)
        k2 = f_u(w + h / 2, u + h * k1 / 2)
        k3 = f_u(w + h / 2, u + h * k2 / 2)
        k4 = f_u(w + h, u + h * k3)
        return u + (k1 + 2 * k2 + 2 * k3 + k4) * h / 6
    else:
        l1 = f_w(u,w)
        l2 = f_w(u + h/2,w + h*l1/2)
        l3 = f_w(u + h/2, w + h*l2/2)
        l4 = f_w(u + h, w + h*l3)
        return w + (l1+2*l2+2*l3+l4)*h/6

def next_iter_runge_cutta_1D(x,u,h):
        x1 = u
        x2 = u + h*x1 / 2
        x3 = u + h*x2 / 2
        x4 = u + h*x3
        return x + (x1 + 2*x2 + 2*x3 + x4) * h / 6

def modelNewton(u,w,x,y,h):
    x_arr = []
    y_arr = []
    t = 0.0
    while( y >= 0.0):
        u = next_iter_runge_cutta_2D(for_u,u,w,h)
        w = next_iter_runge_cutta_2D(for_w,u,w,h)
        x += u*h
        y += w*h
        x_arr.append(x)
        y_arr.append(y)
    return x_arr[:len(x_arr)-1], y_arr[:len(y_arr)-1]

def modelGaliley(v_0,alfa,g,h):
    x_arr = []
    y_arr = []
    t = x = y = 0.0
    while( y >= 0.0):
        x = v_0 * math.cos(alfa) *t
        y = v_0 * math.sin(alfa) *t - g*pow(t,2)/2
        x_arr.append(x)
        y_arr.append(y)
        t += h
    return x_arr[:len(x_arr)-1], y_arr[:len(y_arr)-1]

if __name__ == '__main__':
    global v_0, m, alfa, beta, g
    v_0 = 50.0
    alfa = math.pi/4.0
    #ballistic constant:
    c = 0.15
    #ball diameter:
    d = 0.1
    #gravity acceleration:
    g = 9.8
    air_density = 1.3
    pb_density = 11300.0
    beta = c * air_density * cross_sectional_area(d)/2
    #beta = 0
    print ("beta: ", beta)
    m = pb_density*volume_sphere(d)
    print ("m: ",m)
    n = 70.0 #кол-во разбиений
    step = 1./n
    #начальные условия
    x_0 = y_0 = 0.0
    u_0 = v_0 * math.cos(alfa)
    w_0 = v_0 * math.sin(alfa)
    coords_n = modelNewton(u_0, w_0, x_0, y_0, step)
    print("Newton model distance", coords_n[0][-1])
    plot.plot(coords_n[0],coords_n[1])
    coords_g = modelGaliley(v_0, alfa, g, step)
    print("Galiley model distance", coords_g[0][-1])
    plot.plot(coords_g[0],coords_g[1], color='black')
    plot.show()