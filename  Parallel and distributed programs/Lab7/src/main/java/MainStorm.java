import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.topology.TopologyBuilder;
import org.apache.storm.tuple.Fields;

/**
 * Created by anastasiya on 25.01.17.
 */
public class MainStorm {
    public static void main(String[] args) {

        TopologyBuilder builder = new TopologyBuilder();

        builder.setSpout("generator", new Spout());

        builder.setBolt("splitter", new BoltSplitter(), 10).shuffleGrouping("generator","line");

        builder.setBolt("counter", new BoltWordsCounter(), 10)
                .fieldsGrouping("splitter", new Fields("word"))//?//Для группировки указывается ряд полей. Гарантируется что записи с одинаковым набором значений попадут одному и тому экземпляру bolt
                .allGrouping("generator", "sync");//Сообщение отсылается каждому экземпляру bolt

        // Парметры в spout передаются с помощью
        Config conf = new Config();
        conf.put(Spout.NAME_DIR, args[0]);
        //conf.put(Spout.PROCESSED_DIR, args[1]);
        conf.setDebug(false);
        conf.put(Config.TOPOLOGY_MAX_SPOUT_PENDING, 5);

        LocalCluster cluster = new LocalCluster();

        cluster.submitTopology("frequency dictionary file topology", conf, builder.createTopology());
    }
}
