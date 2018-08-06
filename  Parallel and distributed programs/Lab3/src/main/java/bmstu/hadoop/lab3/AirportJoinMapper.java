package bmstu.hadoop.lab3;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;
import java.lang.String;

import static java.lang.Character.toLowerCase;


public class AirportJoinMapper extends Mapper<LongWritable, Text, AirportComparable, Text> {
    @Override
    protected void map(LongWritable key, Text value, Mapper.Context context) throws IOException, InterruptedException {

        String dataTableAirport = value.toString();
        String[] elementTableAirport =dataTableAirport.split("\",");
        if (key.get()>0) {

            int airoportId = Integer.parseInt(deleteQuotes(elementTableAirport[0]));//	- ID авиапорта
            String airportName = deleteQuotes(elementTableAirport[1]);

            AirportComparable keymapAirport = new AirportComparable();
            keymapAirport.setOriginAiroportIdAiroportId(airoportId);
            keymapAirport.setDataId(0);

            context.write(keymapAirport, new Text(airportName));
        }
    }

    protected String deleteQuotes(String value){
        String valueWithoutQuotes=value.replace("\"","");
        return valueWithoutQuotes;

    }
}

