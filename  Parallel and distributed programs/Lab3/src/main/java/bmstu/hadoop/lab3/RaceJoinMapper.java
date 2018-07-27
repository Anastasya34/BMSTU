package bmstu.hadoop.lab3;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;
import java.lang.String;

import static java.lang.Character.toLowerCase;


public class RaceJoinMapper extends Mapper<LongWritable, Text, AirportComparable, Text> {
    @Override
    protected void map(LongWritable key, Text value, Mapper.Context context) throws
            IOException, InterruptedException {
        String dataTableRace = value.toString();
        String[] elementTableRace =dataTableRace.split(",");

        boolean emptyStringOriginAeroportId = elementTableRace[14].equals("\"\"")|| elementTableRace[14].equals("");
        boolean emptyStringArrDelay = elementTableRace[17].equals("\"\"")|| elementTableRace[17].equals("");

        if ((key.get()>0) && (!emptyStringArrDelay) && (!emptyStringOriginAeroportId)){

            int originAeroportId = Integer.parseInt(deleteQuotes(elementTableRace[11]));//DEST_AEROPORT_ID — Идентификатор аэропорта
            float cancelled = Float.parseFloat(deleteQuotes(elementTableRace[19]));
            float arrDelay = Float.parseFloat(deleteQuotes(elementTableRace[17]));//DEST_AEROPORT_ID — Идентификатор аэропорта

            if (cancelled==0.00 && arrDelay<0) {
                AirportComparable keymapRace = new AirportComparable();
                keymapRace.setOriginAiroportIdAiroportId(originAeroportId);
                keymapRace.setDataId(1);

                context.write(keymapRace, new Text(elementTableRace[17].toString()));
            }
        }
    }

    protected String deleteQuotes(String value){
        String valueWithoutQuotes=value.replace("\"","");
        return valueWithoutQuotes;

    }
}


