package bmstu.hadoop.lab3;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class AirportPartitioner extends Partitioner<AirportComparable, Text> {
    public int getPartition(AirportComparable key, Text value, int numReduceTasks) {
        return (key.getOriginAiroportId() & Integer.MAX_VALUE) % numReduceTasks;
    }
}