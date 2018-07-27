package bmstu.hadoop.lab3;

import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.Reducer;
import java.io.IOException;
import java.util.Iterator;
import java.math.*;

public class  AirportReducer extends Reducer<AirportComparable, Text, Text, Text> {
    @Override
    protected void reduce(AirportComparable key, Iterable<Text> values, Context context)
            throws IOException, InterruptedException {
        Iterator<Text> iter = values.iterator();
        Text airportName = new Text("Airport name: " + iter.next().toString());
        float count=0,summa=0, max=0,min=0,average=0;
        String firstKey = key.toString();

        while (iter.hasNext()) {
            Text str = iter.next();
            float valueArrDelay=Float.parseFloat(str.toString());

            max=Max(max,Math.abs(valueArrDelay));
            min=Min(min,Math.abs(valueArrDelay));
            count+=1;
            summa+=valueArrDelay;
            //context.write(key, new Text(firstKey+"+++++"+count+"----"+str.toString()));


        }
        if (count!=0)
            average= summa/count;
        Text outValue = new Text(" max: "+Float.toString(max)+" average: " +Float.toString(average)+" min: "+Float.toString(min)+"\t" );

        context.write(airportName, outValue);


    }

    float Min(float v1, float v2){
        if (v1<=v2)
            return v1;
        else
            return v2;
    }

    float Max(float v1, float v2){
        if (v1>=v2)
            return v1;
        else
            return v2;
    }
}