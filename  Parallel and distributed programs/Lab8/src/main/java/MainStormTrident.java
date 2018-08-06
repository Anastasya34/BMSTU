import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.topology.TopologyBuilder;
import org.apache.storm.trident.Stream;
import org.apache.storm.trident.TridentTopology;
import org.apache.storm.tuple.Fields;
import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.topology.TopologyBuilder;
import org.apache.storm.tuple.Fields;

/**
 * Created by anastasiya on 25.01.17.
 */
public class MainStormTrident {
    public static void main(String[] args) {
        TridentTopology topology = new TridentTopology();

        Stream wordCounts = topology.newStream("generator", new Spout())
                .parallelismHint(1).shuffle()
                .each(new Fields("row"),new Function(),new Fields("day_of_week","array_delay","is_cancelled")).shuffle()//
                .each(new Fields("array_delay"),new RaceFilter())
                //partitionBy(new Fields("upper_word"))
                //.partitionAggregate(new Fields("upper_word"), new WordAggregator(), new Fields("counts"))
                .groupBy(new Fields("day_of_week"))
                .aggregate(new Fields("day_of_week"),new RaceCombinerAggregator(),new Fields("count"))
                .parallelismHint(10)
                .each(new Fields("day_of_week","count"),new PrintFilter());

        Config conf = new Config();
        conf.put(Spout.NAME_DIR, args[0]);
        LocalCluster cluster = new LocalCluster();
        cluster.submitTopology("poll", conf, topology.build());


    }
}
