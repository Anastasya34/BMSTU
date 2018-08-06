package com.company;

import java.util.ArrayList;

/**
 * Created by anastasiya on 30.03.17.
 */
class ScannerText{
    public String programm;
    private Compiler compiler;
    private Position currentPos;
    private ArrayList<Fragment> comments;



    public ScannerText(String programm, Compiler compiler) {
        this.programm = programm;
        this.compiler = compiler;
        this.currentPos = new Position(programm);
        this.comments = new ArrayList<Fragment>() ;
    }

    public Iterable<Fragment> comment(){
        return comments;
    }



}
