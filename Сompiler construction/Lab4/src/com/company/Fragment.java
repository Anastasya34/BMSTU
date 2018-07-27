package com.company;

/**
 * Created by anastasiya on 30.03.17.
 */
class Fragment {
    public final Position starting, following;

    public Fragment(Position starting, Position following) {
        this.starting = starting;
        this.following = following;
    }

    public String toString() {
        return starting.toString() + "-" + following.toString();
    }
}
