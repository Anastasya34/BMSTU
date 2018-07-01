package com.company;

import java.util.*;

import static java.lang.Math.floor;
import static java.lang.Math.pow;

public class Optimization {
    public static int it=0;

    static double f(double x){
        return (5*pow(x,6)-36*pow(x,5)-165/2*pow(x,4)-60*pow(x,3)+36);
    }

    static float f_der(float x){
        return (float) (30*pow(x,5)-180*pow(x,4)-330*pow(x,3)-180*pow(x,2));
    }

    public static double halfSectionMethod(double a, double b, double eps){
        double x_middle = (a+b)/2;
        double L = Math.abs(b-a);
        while (L > eps) {
            double y = a + L / 4;
            double z = b - L / 4;
            double f_x = f(x_middle);
            double f_y = f(y);
            double f_z = f(z);
            if (f_y < f_x) {
                b = x_middle;
                x_middle = y;
            } else {
                if (f_z < f_x) {
                    a = x_middle;
                    x_middle = z;
                } else {
                    a = y;
                    b = z;
                }
            }
            L = Math.abs(b-a);
            it++;
        }
        return x_middle;
    }

    public static double  goldenSectionMethod(double a, double b, double eps){
        double z,y;
        double PHI = (1.+Math.sqrt(5.))/2.;
        while (Math.abs(b - a) > eps){
            z = b - (b - a) / PHI;
            y = a + (b - a) / PHI;
            if (f(y) <= f(z))
                a = z;
            else
                b = y;
            it++;
        }
        return (a + b) / 2;
    }

    public static double methodFibonacci(double a, double b, double eps){
        double L = Math.abs(b-a);
        double y,z;
        int N = 3;
        ArrayList<Double> fibArr = new ArrayList<>(Arrays.asList(new Double[]{1.,1.,2.,3.}));//вынести в отделаный массив
        for (double f1 = 2., f2 = 3.; fibArr.get(fibArr.size()-1) < L/eps; ++N) {
            fibArr.add(f1+f2);
            f1 = f2;
            f2 = fibArr.get(fibArr.size()-1);
        }
        for (int i = 1; i != N-3; i++) {
            y = a + fibArr.get(N - i - 1) / fibArr.get(N - i + 1) * (b - a);
            z = a + fibArr.get(N - i) / fibArr.get(N - i + 1) * (b - a);
            if (f(y) <= f(z))
                b = z;
            else
                a = y;
            it++;
        }
        return (a + b) / 2;
    }
    public static void main(String[] args) {
        // Алгоритм Свенна:
        double x_0 = -13.;
        double t = 2.;
        double a_0 = 0., b_0 = 10., delta = t ;
        while (true){
            if (f(x_0 - t) <= f(x_0) && f(x_0) >= f(x_0 + t)){
                t++;
            }
            if (f(x_0 - t) >= f(x_0) && f(x_0) <= f(x_0 + t)) {
                a_0 = x_0 - t;
                b_0 = x_0 + t;//начальный интервал неопределенности
                break;
            } else {
                if (f(x_0 - t) >= f(x_0) && f(x_0) >= f(x_0 + t)) {
                    delta = t;
                    a_0 = x_0;
                    x_0 = x_0 + t;
                }
                if (f(x_0 - t) <= f(x_0) && f(x_0) <= f(x_0 + t)) {
                    delta = -t;
                    b_0 = x_0;
                    x_0 = x_0 - t;
                }
                while (true) {
                    double x_k = x_0 + 2 * delta;
                    if (f(x_k) < f(x_0) && delta == t) {
                        a_0 = x_0;
                    }
                    if (f(x_k) < f(x_0) && delta == -t) {
                        b_0 = x_0;
                    }
                    if (f(x_k) >= f(x_0)) {
                        break;
                    }
                    x_0 = x_k;
                }
                break;
            }
        }
        System.out.println("Алгоритм Свенна:");

        System.out.println("Итервал: ("+a_0+", " +b_0+")");

        double a = a_0;
        double b = b_0;
        double eps = 0.01;

        System.out.println("==============================");

        System.out.println("Метод половинного деления");
        double x = halfSectionMethod(a, b, eps);
        System.out.println("x =" + x);
        System.out.println("f(x)=" + f(x));
        System.out.println("Количество итераций " + it);

        System.out.println("==============================");

        System.out.println("Метод золотого сечения");
        it = 0;
        x = goldenSectionMethod(a, b, eps);
        System.out.println("x =" + x);
        System.out.println("f(x)=" + f(x));
        System.out.println("Количество итераций " + it);

        System.out.println("==============================");

        System.out.println("Метод Фибоначчи");
        it = 0;
        x = methodFibonacci(a, b, eps);
        System.out.println("x =" + x);
        System.out.println("f(x)=" + f(x));
        System.out.println("Количество итераций " + it);
    }
}