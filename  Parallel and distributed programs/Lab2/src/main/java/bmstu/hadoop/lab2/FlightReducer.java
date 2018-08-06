package bmstu.hadoop.lab2;

import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.Reducer;
import java.io.IOException;
import java.util.Iterator;


public class  FlightReducer extends Reducer<FlightData, Text, FlightData, Text> {
    @Override
    protected void reduce(FlightData key, Iterable<Text> values, Context context)
            throws IOException, InterruptedException {

        for(Text value:values) {
            context.write(key,value);//?????????
        }

    }
}