package com.company;

/**
 * Created by anastasiya on 30.03.17.
 */
class ErrorToken extends Token {
    public String error;

    public ErrorToken(Position starting, Position following) {
        super(DomainTag.Error, "",starting, following);
        this.error = DomainTag.Error;
    }
}
