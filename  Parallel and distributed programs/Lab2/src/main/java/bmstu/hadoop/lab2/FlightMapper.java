package bmstu.hadoop.lab2;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;
import java.lang.String;

import static java.lang.Character.toLowerCase;


public class FlightMapper extends Mapper<LongWritable, Text, FlightData, Text> {
    @Override
    protected void map(LongWritable key, Text value, Mapper.Context context) throws
            IOException, InterruptedException {

        String dataTable = value.toString();
        String[] elementTable = dataTable.split(",");

        boolean emptyStringArrDelay = elementTable[17].equals("\"\"")|| elementTable[17].equals("");
        boolean emptyStringAirTime = elementTable[21].equals("\"\"") || elementTable[21].equals("");

        if ((key.get()>0) && (!emptyStringArrDelay) && (!emptyStringAirTime)){

                float Cancelled = Float.parseFloat(elementTable[19].replace("\"", ""));
                int OriginAiroportId = Integer.parseInt(elementTable[11].replace("\"", ""));//	- ID авиапорта
                float ArrDelay = Float.parseFloat(elementTable[17].replace("\"", ""));//— разница в минутах между расчетным временем приземления и реальным (может быть отрицательной)
                float AirTime = Float.parseFloat(elementTable[21].replace("\"", ""));//	- время в полете в минутах

                if (ArrDelay < 0) {
                    FlightData keymap = new FlightData();
                    keymap.setCancelled(Cancelled);
                    keymap.setOriginAiroportId(OriginAiroportId);
                    keymap.setArrDelay(ArrDelay);
                    keymap.setAirTime(AirTime);
                    context.write(keymap, value);
                }
        }
    }
}


