package com.company;

/**
 * Created by anastasiya on 30.03.17.
 */

public class Position implements Comparable<Position> {
    private String text;
    private Integer line,pos,index;

    public Position(String text){
        this.text=text;
        line=pos=1;
        index=0;
    }


    public Position(String text, Integer line, Integer pos, Integer index) {
        this.text = text;
        this.line = line;
        this.pos = pos;
        this.index = index;
    }

    public int getLine() {
        return line;
    }

    public int getPos() {
        return pos;
    }

    public int getIndex() {
        return index;
    }
    @Override
    public int compareTo (Position other) {
        return index.compareTo(other.getIndex());
    }
    @Override
    public String toString(){
        return " ( " + line + " , " + pos + " ) " ;
    }

    public int Cp(){
        return (index == text.length())? -1: text.charAt(index);//?????
    }
    //unicodecategory
    public boolean isWhiteSpace(){
        return index != text.length() && Character.isWhitespace(text.charAt(index));
    }

    public boolean isLetter(){
        return index != text.length() && Character.isLetter(text.charAt(index));
    }

    public boolean isLetterOrDigit(){
        return index != text.length() && Character.isLetterOrDigit(text.charAt(index));
    }
    public boolean isPoint(){return index != text.length() && text.charAt(index)=='.';}
    public boolean isSpecSimbol(){
        return text.charAt(index)=='=' || text.charAt(index)=='+' || text.charAt(index)=='-' || text.charAt(index)=='*' || text.charAt(index)=='/' || text.charAt(index)==';';
    }


/*
    public boolean isDecimalDigit(){
        return index != text.length() && Character.is(text.charAt(index));
    }*/

    public boolean isNewLine() {
        if (index == text.length()) {
            return true;
        }
        if (text.charAt(index) == '\r' && index + 1 < text.length()) {
            return text.charAt(index+1) == '\n';
        }
        return text.charAt(index) == '\n';

    }


    public static Position next(Position p){
        if ( p.index < p.text.length()){
            if (p.isNewLine()){
                if (p.text.charAt(p.index) == '\r')
                    p.index++;
                p.line ++;
                p.pos = 1 ;
            }
            else {
                if ( Character.isHighSurrogate( p.text.charAt(p.index) ) )
                    p.index++;
                p.pos++;
            }
            p.index++;
        }
        return p;
    }
}
