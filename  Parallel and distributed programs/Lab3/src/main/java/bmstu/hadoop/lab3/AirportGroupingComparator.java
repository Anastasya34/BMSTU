package bmstu.hadoop.lab3;

import org.apache.hadoop.io.RawComparator;
import org.apache.hadoop.io.WritableComparable;
import org.apache.hadoop.io.WritableComparator;


public class AirportGroupingComparator extends WritableComparator {

    protected AirportGroupingComparator() {
        super(AirportComparable.class,true);
    }

    @Override
    public int compare(WritableComparable a, WritableComparable b) {

        AirportComparable aa=(AirportComparable) a;
        AirportComparable bb=(AirportComparable) b;
        int result = aa.compareToForGroupingComparator(bb);
        System.out.println("compare !"+a+" to "+b+" result="+result);
        return result;
    }
}
