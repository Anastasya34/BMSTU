/*
Cтрока выглядит как
1234567891011121314...
Составьте программу, вычисляющую k-тый символ строки (0≤k<263). 
 В программе разрешается использовать только примитивные целочисленные типы данных,
 то есть, в частности, массивы и строки использовать нельзя. 
 Для любого k из указанного диапазона программа должна работать не дольше 2 секунд. 
 Точкой входа в программу должен быть метод main публичного класса Kth.
*/
package com.company;
import java.util.Scanner;
public class Kth {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        long position = input.nextLong();
        long countOfDigits, digit=0, dozen;

        for (dozen = 1, countOfDigits = 1; position >= 0; dozen*=10, countOfDigits++){
            position -= 9*dozen*countOfDigits;
        }
        countOfDigits--;
        dozen /= 10;
        long startPos = position + 9*dozen*countOfDigits;

        long number = dozen+(long)Math.floor(startPos/countOfDigits);
        long posDigitInNumber = startPos%countOfDigits;
        
        while( posDigitInNumber < countOfDigits){
            digit = number%10;
            number = (long)Math.floor(number/10);
            countOfDigits--;
        }
       
        System.out.println(digit);
    }
}
