package com.company;

/**
 * Created by anastasiya on 30.03.17.
 */
class IdentToken extends Token{
    public String ident;

    public IdentToken(Position starting, Position following,String ident) {
        super(DomainTag.IDent, ident, starting, following);
        this.ident = DomainTag.IDent;
    }
}
