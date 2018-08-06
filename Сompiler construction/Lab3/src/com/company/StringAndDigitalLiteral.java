package com.company;

import java.io.*;
import java.util.Scanner;
import java.util.regex.Matcher ;
import java.util.regex.Pattern ;

public class StringAndDigitalLiteral {
    public static void main(String args[]) {

        String stringLiteral = "\"(?:[^\"\n\\\\]|\\\\[nt\"]|\\\\)*?\"";
        String numericLiteral = "[0-9](?:[0-9]|_)*";
        String space="[\\s]+";
        String patternString = "(^" + numericLiteral + ")|(^" + stringLiteral + ")|(^" + space + ")";
        Pattern pattern = Pattern.compile(patternString);
        File file = new File("test.txt");
        BufferedReader reader;
        int numberString = 1;
        int pos=0;
        try {
            //Объект для чтения файла в буфер
            reader = new BufferedReader(new FileReader(file.getAbsoluteFile()));
            // считаем сначала первую строку
            String line = reader.readLine();
            String newLine=null;
            while (line != null) {
                Matcher matcher;
                newLine=reader.readLine();
                //for посимвольно читаем строку, ind++  pattern.matcher(line.substring(ind))
                int ind =0;
                while(ind < line.length()){
                    matcher = pattern.matcher(line.substring(ind));
                    if (matcher.find()){
                        if (matcher.group(1) != null) {
                            pos = ind + 1;
                            System.out.println("Число: " + "(" + numberString + ", " +pos + ") " + matcher.group(1));
                            ind += matcher.end();
                        } else {
                            if (matcher.group(2) != null) {
                                pos=ind+1;
                                System.out.println("Строка: " + "(" + numberString + ", " + pos+ ") " + matcher.group(2));
                                ind += matcher.end();
                            }
                            else{
                                ind++;
                            }
                        }
                    }
                    else{

                        pos=ind+1;
                        System.out.println("Syntax error " + "(" + numberString + ", " +pos+ ") ");
                        while (!matcher.find() && ind!=line.length()){
                            ind++;
                            matcher = pattern.matcher(line.substring(ind));
                        }

                    }
                }
                line = newLine;
                numberString++;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}