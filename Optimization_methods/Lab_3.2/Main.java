package com.company;

import java.util.ArrayList;

import static java.lang.Math.pow;

/**
 * Created by User on 02.04.2018.
 */
public class Main{
    public static int it = 0;

    static float f(float x){
        return (float)(5*pow(x,6)-36*pow(x,5)-165/2*pow(x,4)-60*pow(x,3)+36);
    }

    static float f_der(float x){
        return (float) (30*pow(x,5)-180*pow(x,4)-330*pow(x,3)-180*pow(x,2));
    }

    public static float min(float x_0, float x_1, float x_2){
        if ( f(x_0) < f(x_1 )){
            if (f(x_0) < f(x_2)){
                return x_0;
            }
            else {
                return x_2;
            }
        }
        else {
            if (f(x_1) < f(x_2)){
                return x_1;
            }
            else {
                return x_2;
            }
        }
    }
    public static float quadraticInterpolation(float a1, float eps){
        float step = 0.01f;
        float a2, a3, f_min, alfa, a_min;
        float cond1, cond2;

        while (true) {
            a2 = a1 + step;
            if (f(a1) > f(a2)) {
                a3 = a1 + 2 * step;
            } else {
                a3 = a1 - 2 * step;
            }
            while (true){
                it++;
                a_min = min(a1, a2, a3);
                f_min = f(a_min);

                float den = ((a2 - a3) * f(a1) + (a3 - a1) * f(a2) + (a1 - a2) * f(a3));

                if (Math.abs(den) > 0.1) {
                    alfa = (float) (0.5 * ((Math.pow(a2, 2) - Math.pow(a3, 2)) * f(a1) +
                            (Math.pow(a3, 2) - Math.pow(a1, 2)) * f(a2) +
                            (Math.pow(a1, 2) - Math.pow(a2, 2)) * f(a3)) /
                            den);
                } else {
                    a1 = a_min + step;
                    break;
                }
                cond1 = (f_min - f(alfa)) / f(alfa);
                cond2 = (a_min - alfa) / alfa;
                if (Math.abs(cond1) > eps || Math.abs(cond2) > eps) {
                    if (a1 <= alfa && alfa <= a3) {
                        if (alfa < a2) {
                            a3 = a2;
                            a2 = alfa;
                        } else {
                            a1 = a2;
                            a2 = alfa;
                        }
                    } else {
                        a1 = alfa;
                        break;
                    }
                } else {
                    return alfa;
                }
            }
        }
    }

    public static float qubicInterpolation(float a1, float eps){
        float a2 = a1;
        float alfa = 0.0f;
        float step = 0.02f;
        if (f_der(a1)< 0) {
            int i = 0;
            do {
                a1 = a2;
                a2 += pow(2, i) * step;
                ++i;
                it++;
            } while (f_der(a1) * f_der(a2) > 0.0f);
        } else {
            int i = 0;
            do {
                a1 = a2;
                a2 -= pow(2, i) * step;
                ++i;
                it++;
            } while (f_der(a1) * f_der(a2) > 0.0f);
        }
        float z,w,mu, cond1,cond2;
        while (true){
            it++;
            z = 3 * (f(a1) - f(a2)) / (a2 - a1) + f_der(a1) + f_der(a2);
            if (a1 < a2) {
                w = (float)Math.sqrt(pow(z, 2) - f_der(a1) * f_der(a2));
            } else {
                w = -(float)Math.sqrt(pow(z, 2) - f_der(a1) * f_der(a2));

            }
            mu = (f_der(a2) + w - z) / (f_der(a2) - f_der(a1) + 2 * w);
            if (mu < 0.0f) {
                alfa = a2;
            }
            if (0.0f <= mu && mu <= 1.0f) {
                alfa = a2 - mu * (a2 - a1);
            }
            if (mu > 1.f) {
                alfa = a1;
            }
            while (f(alfa) >= f(a1) && Math.abs((alfa - a1) /alfa) > eps) {
                alfa = alfa -(alfa - a1) / 2;
            }
            cond1 = f_der(alfa);
            cond2 = (alfa - a1)/alfa;

            if (Math.abs(cond1) > eps || Math.abs(cond2) > eps ) {
                if (f_der(alfa) * f_der(a1) <= 0.0f) {
                    a2 = a1;
                    a1 = alfa;
                }
                if (f_der(alfa) * f_der(a2) <= 0.0f) {
                    a1 = alfa;
                }
            }
            else {
                return alfa;
            }

        }
    }

    public static void main(String[] args) {
        float x_0 = -13.0f;
        System.out.println("Метод квадратичной интерполяции");
        it = 0;
        float eps = 0.01f;
        float res_x = quadraticInterpolation(x_0, eps);
        System.out.println("x =" + res_x);
        System.out.println("f(x)=" + f(res_x));
        System.out.println("Количество итераций " + it);

        System.out.println("Метод кубической интерполяции");
        it = 0;
        eps = 0.04f;
        res_x = qubicInterpolation(x_0, eps);
        System.out.println("x =" + res_x);
        System.out.println("f(x)=" + f(res_x));
        System.out.println("Количество итераций " + it);
    }
}
