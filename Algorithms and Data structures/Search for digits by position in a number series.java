package com.company;
/*Рассмотрим строку, составленную из записанных подряд натуральных чисел от 1 до бесконечности.
Числа представлены в десятичной системе и не разделяются пробелами.
Тем самым строка выглядит как 1234567891011121314...
Программа вычисляет k-тый символ строки.
*/
import java.util.Scanner;
public class Kth {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        long position = input.nextLong();
        long countOfDigits, digit=0, dozen;
        for (dozen = 1,countOfDigits = 0; position >= 0; dozen*=10,countOfDigits++){
            position -= 9*dozen*(countOfDigits+1);
        }
        dozen /= 10;
        long startPos = position + 9*dozen*countOfDigits;
        long number = dozen+(long)Math.floor(startPos/countOfDigits);
        long positionDigitInNumber = startPos%countOfDigits;
        for(long i = countOfDigits; positionDigitInNumber < i; i--){
            digit = number%10;
            number = (long)Math.floor(number/10);
        }
        System.out.println(digit);
    }
}
