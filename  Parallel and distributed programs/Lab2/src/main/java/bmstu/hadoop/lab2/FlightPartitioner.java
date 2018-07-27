package bmstu.hadoop.lab2;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class FlightPartitioner extends Partitioner<FlightData, Text> {
    public int getPartition(FlightData key, Text value, int numReduceTasks) {
        return ((int)key.getArrDelay() & Integer.MAX_VALUE) % numReduceTasks;
    }
}