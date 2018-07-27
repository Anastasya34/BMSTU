import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.SparkConf;
import org.apache.spark.broadcast.Broadcast;
import scala.Tuple2;

import java.util.Map;


public class SparkAirport {
    public static void main(String[] args) throws Exception {
        SparkConf conf = new SparkConf().setAppName("lab5");
        JavaSparkContext sc = new JavaSparkContext(conf);
        JavaRDD<String> airportTableFile= sc.textFile("airport.csv");
        JavaRDD<String> raceTableFile= sc.textFile("Race.csv");
        //////????????????//
        raceTableFile=raceTableFile.filter(
                s -> !s.contains("YEAR")
        );
        airportTableFile=airportTableFile.filter(
                s -> !s.contains("Code"));

       JavaPairRDD<Integer,String> airportTable = airportTableFile.mapToPair(
                s -> {
                    s = s.replace("\"","");
                    int indexFirstComma = s.indexOf(",");
                    int id=Integer.parseInt(s.substring(0,indexFirstComma));
                    String name = s.substring(indexFirstComma+1,s.length());

                    return new Tuple2<Integer, String>(id,name);
                });



        JavaRDD<String[]> raceTable = raceTableFile.map(
                s -> {
                    s = s.replace("\"", "");
                    return s.split(",");
                });

        JavaPairRDD<Tuple2<Integer,Integer>, FlightData> raceTablePair = raceTable.mapToPair(
                s -> {

                    float cancelled = Float.parseFloat(s[19]);
                    int originAirportId = Integer.parseInt(s[11]);//	- ID авиапорта
                    float arrDelay=0;
                    float airTime =0;
                    if (!s[18].equals(""))
                        arrDelay = Float.parseFloat(s[18]);//— разница в минутах между расчетным временем приземления и реальным (может быть отрицательной)
                    if ( !s[21].equals(""))
                        airTime = Float.parseFloat(s[21]);

                    FlightData raceInfo= new FlightData(cancelled,originAirportId,arrDelay,airTime);

                    int destAirportId=Integer.parseInt(s[14]);

                    Tuple2<Integer,Integer> idAirportPair=new Tuple2<Integer,Integer>(originAirportId,destAirportId);

                    return (new Tuple2<Tuple2<Integer,Integer>, FlightData>(idAirportPair,raceInfo));
                });



        JavaPairRDD<Tuple2<Integer,Integer>,Counter>  avgCounts = raceTablePair.combineByKey(
                (flightData)->{
                    //return (new Counter(1f,0f,0f));
                    if ((flightData.getCancelled()==1.0) || (flightData.getArrDelay()>0))
                        return new Counter(1f,1f,flightData.getArrDelay());

                    else return new Counter(1f,0f,0f);

                },// first aggregation step for each key.
                (valueCounter,valueAirport)->{//what to do when a combiner is given a new value
                    if ((valueAirport.getCancelled()==1.0) || (valueAirport.getArrDelay()>0))
                        if (valueAirport.getArrDelay()>valueCounter.getMaxTimeDelay()){
                            valueCounter.setMaxTimeDelay(valueAirport.getArrDelay());
                            return Counter.addValue(valueCounter,1f);
                        }
                        else{
                            return Counter.addValue(valueCounter, 1f);
                        }
                    else return Counter.addValue(valueCounter,0f);
                },
                Counter::add
        );


        JavaPairRDD<Tuple2<Integer,Integer>,String> raceResultTable = avgCounts .mapToPair(
                argRaceTablePair -> {
                    argRaceTablePair._1();
                    argRaceTablePair._2();
                    String raceInfo= "  Percentage canncelled + delayed races: " + Float.toString( argRaceTablePair._2().percentage())+ "         MaxTimeDelay: "+Float.toString(argRaceTablePair._2().getMaxTimeDelay());

                    Tuple2<Integer,Integer> idAirportPair=new Tuple2<Integer,Integer>( argRaceTablePair._1()._1,argRaceTablePair._1()._2);

                    return (new Tuple2<Tuple2<Integer,Integer>, String>(idAirportPair,raceInfo));
                });

        final Broadcast<Map<Integer,String>> airportsBroadcasted = sc.broadcast(airportTable.collectAsMap());

        JavaRDD<String> result = raceResultTable.map(
                argRaceResultTable -> {
                    Map<Integer,String> airportsData= airportsBroadcasted.value();
                    Tuple2<Integer,Integer> idAirports = argRaceResultTable._1();

                    String originAirportName = airportsData.get(idAirports._1());
                    String destAirportName = airportsData.get(idAirports._2());
                    String resultString = "Airport name: FROM "+originAirportName +"  TO  " + destAirportName +" "+argRaceResultTable._2();
                    return resultString;
        });

        result.saveAsTextFile("hdfs://localhost:9000/user/anastasiya/result");
     //   System.out.println(result.collect());
    }
}
