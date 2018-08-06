package bmstu.hadoop.lab2;

import org.apache.hadoop.io.RawComparator;
import org.apache.hadoop.io.WritableComparator;


public class FlightGroupingComparator extends WritableComparator {

    protected FlightGroupingComparator() {
        super(FlightData.class,true);
    }

    @Override
    public int compare(Object a, Object b) {
        FlightData c=(FlightData)a;
        FlightData d=(FlightData)b;
        return  c.compareTo(d);
    }
}
