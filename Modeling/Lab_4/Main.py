import math

def sampleMean(arr):
    n = len(arr)
    sum = 0.0
    for elem in arr:
        sum = sum + elem
    return (sum / float(n))

def S(arr):
    sampleMean_ = sampleMean(arr)
    n = len(arr)
    sum = 0.0
    for elem in arr:
        sum = sum + (elem - sampleMean_)**2
    return sum /float(n)

def main(arr1, arr2):
    ln_arr1 = [math.log(elem) for elem in arr1]
    ln_arr2 = [math.log(elem) for elem in arr2]

    beta = math.sqrt(S(ln_arr1)/S(ln_arr2))
    alfa = math.exp(sampleMean(ln_arr1) - beta * sampleMean(ln_arr2))
    return alfa, beta

#Проверка наличия достаточно тесной связи между потоком пассажиров, вошедших в метро, и пассажиров, прошедших через турникет
thA0 = [ 16.551, 16.810, 14.434, 20.891, 13.773, 14.739, 24.713, 10.127, 14.689, 13.047, 16.487, 14.345, ]
rA0  = [ 14.899, 14.292, 13.046, 18.696, 12.468, 13.313, 22.040, 9.278,  13.269, 11.833, 14.843, 12.968, ]
thA1 = [ 30.746, 22.558, 28.001, 32.958, 28.277, 36.763, 34.650, 33.590, 12.239, 35.848, 38.451, 18.573, ]
rA1  = [ 27.320, 20.155, 24.916, 29.255, 25.159, 32.398, 30.735, 29.808, 11.126, 31.784, 34.061, 16.668, ]
thB0 = [ 32.822, 25.314, 36.918, 46.677, 16.909, 21.889, 34.998, 23.285, 21.561, 37.778, 29.376, 32.822, ]
rB0  = [ 29.553, 22.567, 32.720, 41.259, 15.212, 19.569, 31.040, 20.791, 19.282, 33.472, 26.120, 29.553, ]
thB1 = [ 21.002, 40.022, 35.118, 20.283, 41.746, 40.458, 19.478, 22.974, 25.348, 25.336, 23.743, 29.751, ]
rB1  = [ 18.793, 35.436, 31.145, 18.164, 36.944, 35.817, 17.460, 21.353, 23.430, 22.586, 22.025, 27.282, ]
thC0 = [ 17.084, 29.096, 38.639, 23.690, 29.087, 21.993, 30.082, 18.776, 34.808, 26.192, 18.230, 37.085, ]
rC0  = [ 15.365, 25.876, 34.226, 21.145, 25.868, 20.494, 26.738, 17.263, 31.290, 23.751, 16.784, 33.283, ]
rC0  = [ 15.365, 25.876, 34.226, 21.145, 25.868, 20.494, 26.738, 17.263, 31.290, 23.751, 16.784, 33.283, ]
thC1 = [ 4.544,  17.519, 38.841, 37.324, 16.717, 40.099, 42.244, 22.099, 40.895, 17.519, 38.841, 37.324, ]
rC1  = [ 3.118,  16.162, 34.819, 33.492, 15.461, 35.920, 37.797, 20.170, 36.617, 16.162, 34.819, 33.492, ]

alfa, beta = main(thA0, rA0)
print("thA0, rA0: alfa =", alfa, "beta =", beta)
alfa, beta  = main(thA1, rA1)
print("thA1, rA1: alfa =", alfa, "beta =", beta)
alfa, beta  = main(thB0, rB0)
print("thB0, rB0: alfa =", alfa, "beta =", beta)
alfa, beta  = main(thB1, rB1)
print("thB1, rB1: alfa =", alfa, "beta =", beta)
alfa, beta  = main(thC0, rC0)
print("thC0, rC0: alfa =", alfa, "beta =", beta)
alfa, beta = main(thC1, rC1)
print("thC1, rC1: alfa =", alfa, "beta =", beta)

#рабочая выборка
ksi_w1 = thA0 + thB0 + thC0
ksi_w2 = rA0 + rB0 + rC0

#контрольная выборка
ksi_c1 = thA1 + thB1 + thC1
ksi_c2 = rA1 + rB1 + rC1

n = len(ksi_w1)

alfa_w, beta_w = main(ksi_w1,ksi_w2)
print(alfa_w,beta_w)
ksi_calc2 = ksi_c2

ksi_calc1 = [alfa_w * pow(ksi_calc2[i], beta_w) for i in range(len(ksi_w1))]

ksi_c1.sort()
ksi_calc1.sort()

dif = []
for i in range(5,50,5):
    list_contr1 = [x for x in ksi_c1 if x < i]
    list_calc1 =  [x for x in ksi_calc1 if x < i]
    Fn_contr1 = len(list_contr1) / n
    Fn_calc1 = len(list_calc1) / n
    dif.append(abs(Fn_contr1 - Fn_calc1))

if (max(dif) > 0.05):
    print("принимаем")

print(max(dif))

#часть 2
IIA0 = [[4.252, 5.158, 4.907,], [4.349, 5.242, 4.995,], [3.550, 4.458, 4.209,], [5.704, 6.605, 6.357,],
        [3.348, 4.239, 3.984,], [3.654, 4.556, 4.309,], [6.973, 7.872, 7.626,], [2.113, 3.018, 2.762,],
        [3.636, 4.532, 4.286,], [3.089, 3.989, 3.739,], [4.235, 5.135, 4.885,], [3.521, 4.421, 4.171,],
]

IIA1 = [[4.902, 6.006, 5.252,], [3.275, 4.278, 3.570,], [4.369, 5.365, 4.663,], [5.350, 6.659, 5.804,],
        [4.419, 5.418, 4.713,], [6.119, 7.117, 6.416,], [5.695, 6.692, 5.991,], [5.434, 6.475, 5.778,],
        [1.209, 2.212, 1.504,], [5.929, 6.929, 6.229,], [6.450, 7.454, 6.750,], [2.474, 3.474, 2.772,],
]


IIB0 = [[6.965, 7.195,], [5.088, 5.318,], [7.989, 8.219,], [10.429, 10.659,], [2.987, 3.217,], [4.232, 4.462,],
        [7.509, 7.739,], [4.581, 4.811,], [4.150, 4.380,], [8.204, 8.434,], [6.104, 6.334,], [6.965, 7.195,],
]
IIB1 = [[4.070, 3.840,], [8.825, 8.595,], [7.599, 7.369,], [3.8907, 3.6607,], [9.256, 9.026,], [8.934, 8.704,],
        [3.689, 3.459,], [4.563, 4.333,], [5.156, 4.927,], [5.154, 4.923,], [4.755, 4.525,], [6.257, 6.021,],
]

IIC0 = [[4.344, 5.574,], [8.348, 9.578,], [11.529, 12.759,], [6.546, 7.776,], [8.345, 9.575,], [5.985, 7.211,],
        [8.672, 9.907,], [4.908, 6.138,], [10.252, 11.482,], [7.382, 8.610,], [4.726, 5.956,], [11.011, 12.241,],
]

IIC1 = [[1.164, 1.394,], [5.489, 5.719,], [12.594, 12.827,], [12.091, 12.321,], [5.222, 5.452,], [13.016, 13.242,],
        [10.211, 10.441, 10.526,], [5.178, 5.404, 5.489,], [9.873, 10.103, 10.188,], [4.029, 4.252, 4.344,],
        [9.360, 9.592, 9.675,], [8.981, 9.211, 9.296,]
]
#рабочая выборка
ksi_w1 = []
for arr in IIA0:
   ksi_w1.append(sum((int(arr[i]) for i in range(0, int(len(arr))))))
for arr in IIB0:
   ksi_w1.append(sum((int(arr[i]) for i in range(0, int(len(arr))))))
for arr in IIC0:
   ksi_w1.append(sum((int(arr[i]) for i in range(0, int(len(arr))))))

ksi_w2 = []
for arr in IIA0:
   if len(arr) == 3:
       ksi_w2.append(arr[0]+arr[1])
   else:
       ksi_w2.append(arr[0])

for arr in IIB0:
  if len(arr) == 3:
       ksi_w2.append(arr[0]+arr[1])
  else:
       ksi_w2.append(arr[0])
for arr in IIC0:
   if len(arr) == 3:
       ksi_w2.append(arr[0]+arr[1])
   else:
       ksi_w2.append(arr[0])

ksi_w3 = []
for arr in IIA0:
   ksi_w3.append(arr[len(arr)-1])
for arr in IIB0:
   ksi_w3.append(arr[len(arr)-1])
for arr in IIC0:
   ksi_w3.append(arr[len(arr)-1])

#контрольная выборка
ksi_c1 = []
for arr in IIA0:
   ksi_c1.append(sum((int(arr[i]) for i in range(0, int(len(arr))))))
for arr in IIB0:
   ksi_c1.append(sum((int(arr[i]) for i in range(0, int(len(arr))))))
for arr in IIC0:
   ksi_c1.append(sum((int(arr[i]) for i in range(0, int(len(arr))))))

ksi_c2 = []
for arr in IIA0:
   if len(arr) == 3:
       ksi_c2.append(arr[0]+arr[1])
   else:
       ksi_c2.append(arr[0])
for arr in IIB0:
   if len(arr) == 3:
       ksi_c2.append(arr[0]+arr[1])
   else:
       ksi_c2.append(arr[0])
for arr in IIC0:
   if len(arr) == 3:
       ksi_c2.append(arr[0]+arr[1])
   else:
       ksi_c2.append(arr[0])

ksi_c3 = []
for arr in IIA1:
   ksi_c3.append(arr[len(arr)-1])
for arr in IIB1:
   ksi_c3.append(arr[len(arr)-1])
for arr in IIC1:
   ksi_c3.append(arr[len(arr)-1])

alfa_12, beta_12 = main(ksi_w1,ksi_w2)
alfa_23, beta_23 = main(ksi_w2,ksi_w3)

alfa, beta = main(ksi_w1,ksi_w3)
print(" alfa12 =", alfa_12, "beta12 =", beta_12)
print(" alfa23 =", alfa_23, "beta23 =", beta_23)

ksi_calc3 = [(x**(1/beta_23))/alfa_23 for x in ksi_c2]
ksi_calc = [alfa_23 * (x ** beta_23) for x in ksi_calc3]
ksi_calc1 = [alfa_12 * (x ** beta_12) for x in ksi_calc]

ksi_c1.sort()
ksi_calc1.sort()
dif.clear()
for i in range(5,25,5):
    list_contr1 = [x for x in ksi_c1 if x < i]
    list_calc1 =  [x for x in ksi_calc1 if x < i]
    Fn_contr1 = len(list_contr1) / n
    Fn_calc1 = len(list_calc1) / n
    dif.append(abs(Fn_contr1 - Fn_calc1))
print("dif ",max(dif))














