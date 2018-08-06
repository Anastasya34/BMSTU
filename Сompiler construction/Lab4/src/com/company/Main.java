package com.company;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.regex.Matcher ;
import java.util.regex.Pattern ;
import java.nio.file.Paths;

public class Main {

    static Token nextToken(Position currentSymbol, String input_text_programm){

        while (currentSymbol.isWhiteSpace()) {
            currentSymbol.next(currentSymbol);
        }
        Position start = new Position(input_text_programm, currentSymbol.getLine(), currentSymbol.getPos(), currentSymbol.getIndex());
        Position endToken;
        int A=65, z=122, t=116, s=155,e=101;
        if (currentSymbol.isLetter()){
            if ((currentSymbol.Cp() == 't') || (currentSymbol.Cp() == 's') || (currentSymbol.Cp() == 'e')){

                currentSymbol.next(currentSymbol);

                if (currentSymbol.isLetterOrDigit()){

                    currentSymbol.next(currentSymbol);//третий символ

                    if (currentSymbol.isLetterOrDigit()){
                        do {
                            currentSymbol.next(currentSymbol);
                        }
                        while (currentSymbol.isLetterOrDigit());
                        endToken = new Position(
                                input_text_programm,
                                currentSymbol.getLine(),
                                currentSymbol.getPos(),
                                currentSymbol.getIndex()
                        );
                        return (
                                new IdentToken(
                                        start,
                                        endToken,
                                        input_text_programm.substring(start.getIndex(),endToken.getIndex())
                                )
                        );
                    }
                    else{

                        if (currentSymbol.isWhiteSpace() || currentSymbol.isSpecSimbol()){
                            endToken = new Position(
                                    input_text_programm,
                                    currentSymbol.getLine(),
                                    currentSymbol.getPos(),
                                    currentSymbol.getIndex()
                            );
                            return (
                                    new VarToken(
                                            start,
                                            endToken,
                                            input_text_programm.substring(start.getIndex(),endToken.getIndex())
                                    )
                            );
                        }
                        else{
                            do{
                                currentSymbol.next(currentSymbol);
                            }
                            while (!currentSymbol.isLetter() && currentSymbol.Cp() != -1 );
                            endToken = new Position(
                                    input_text_programm,
                                    currentSymbol.getLine(),
                                    currentSymbol.getPos(),
                                    currentSymbol.getIndex()
                            );
                            return (new ErrorToken(start,endToken));
                        }
                    }
                }
                else {
                    if(currentSymbol.isPoint()){
                        do {
                            currentSymbol.next(currentSymbol);
                        }
                        while (currentSymbol.isLetterOrDigit());
                        endToken = new Position(
                                input_text_programm,
                                currentSymbol.getLine(),
                                currentSymbol.getPos(),
                                currentSymbol.getIndex()
                        );
                        return (
                                new VarToken(
                                        start,
                                        endToken,
                                        input_text_programm.substring(start.getIndex(),endToken.getIndex())
                                )
                        );
                    }
                    else{
                        if(currentSymbol.isWhiteSpace()){
                            endToken = new Position(
                                    input_text_programm,
                                    currentSymbol.getLine(),
                                    currentSymbol.getPos(),
                                    currentSymbol.getIndex()
                            );

                            return (
                                    new IdentToken(
                                            start,
                                            endToken,
                                            input_text_programm.substring(start.getIndex(),endToken.getIndex())
                                    )
                            );
                        }
                    }
                }
            }
            else{
                currentSymbol.next(currentSymbol);
                if (currentSymbol.isLetterOrDigit()){
                    do {
                        currentSymbol.next(currentSymbol);
                    }
                    while (currentSymbol.isLetterOrDigit());
                    endToken = new Position(
                            input_text_programm,
                            currentSymbol.getLine(),
                            currentSymbol.getPos(),
                            currentSymbol.getIndex()
                    );
                    return (
                            new IdentToken(
                                    start,
                                    endToken,
                                    input_text_programm.substring(start.getIndex(),endToken.getIndex())
                            )
                    );
                }
                else {
                    if(currentSymbol.isWhiteSpace()){
                        endToken = new Position(
                                input_text_programm,
                                currentSymbol.getLine(),
                                currentSymbol.getPos(),
                                currentSymbol.getIndex()
                        );
                        return (
                                new IdentToken(
                                        start,
                                        endToken,
                                        input_text_programm.substring(start.getIndex(),endToken.getIndex())
                                )
                        );
                    }
                    else{
                        do{
                            currentSymbol.next(currentSymbol);
                        }
                        while (!currentSymbol.isLetter() && currentSymbol.Cp() != -1 );
                        endToken = new Position(
                                input_text_programm,
                                currentSymbol.getLine(),
                                currentSymbol.getPos(),
                                currentSymbol.getIndex()
                        );
                        return (new ErrorToken(start,endToken));
                    }
                }

            }
        }
        else {
            do{
                currentSymbol.next(currentSymbol);
            }
            while (!currentSymbol.isLetter() && currentSymbol.Cp() != -1 );
            endToken = new Position(
                    input_text_programm,
                    currentSymbol.getLine(),
                    currentSymbol.getPos(),
                    currentSymbol.getIndex()
            );
            return (new ErrorToken(start,endToken));
        }
        return (new ErrorToken(start,start));
    }


    public static void main(String args[]) {

        File fileWithInputText= new File("test1.txt");
        String input_text_programm;
        ArrayList<Token> tokensSeq=new ArrayList<>();
        try {
            String fileName = fileWithInputText.getName();
            input_text_programm = new String(Files.readAllBytes(Paths.get(fileName)));
            Position currentSymbol = new Position(input_text_programm);
            while (currentSymbol.Cp() != -1) {
               while (currentSymbol.isWhiteSpace()) {
                    currentSymbol.next(currentSymbol);
                }
                tokensSeq.add(nextToken(currentSymbol,input_text_programm));

            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        for (int i = 0; i < tokensSeq.size(); i++){
            System.out.println( tokensSeq.get(i).tag + tokensSeq.get(i).coords.toString() + tokensSeq.get(i).value);
        }

    }
}