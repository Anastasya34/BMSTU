package com.company;

/**
 * Created by anastasiya on 30.03.17.
 */
class VarToken extends Token{
    public String var;

    public VarToken(Position starting, Position following,String var) {
        super(DomainTag.Var, var, starting, following);
        this.var = DomainTag.Var;
    }
}
