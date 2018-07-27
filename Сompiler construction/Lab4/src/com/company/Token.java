package com.company;

/**
 * Created by anastasiya on 30.03.17.
 */
abstract class Token{
    public String tag;
    public Fragment  coords;
    public String value;
    protected Token(String tag ,String value, Position starting , Position following){
        this.tag=tag;
        this.value=value;
        coords = new Fragment(starting,following);

    }
}
