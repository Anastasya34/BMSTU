import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.tuple.Tuple;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by anastasiya on 25.01.17.
 */
public class BoltWordsCounter extends BaseRichBolt {
    private OutputCollector outputCollector;
    private HashMap<String, Integer> dictionary = new HashMap<String, Integer>();

    @Override
    public void prepare(Map map, TopologyContext topologyContext, OutputCollector outputCollector) {
        this.outputCollector = outputCollector;
    }
    //обрабатывает входящий tuple и(возможно) генерирует исходящие
    @Override
    public void execute(Tuple tuple) {
        System.out.println("counter tuple with id="+tuple.getSourceStreamId());
        if (tuple.getSourceStreamId().equals("sync")){

            for (Map.Entry entry : dictionary.entrySet()) {
                System.out.println("Key: " + entry.getKey() + " Value: " + entry.getValue());
            }
            dictionary.clear();

        }
        else{
            //System.out.println("counter tuple with id="+tuple.getStringByField("word"));
            String word = tuple.getStringByField("word");
            Integer count = dictionary.get(word);
            if (count == null){
                count = 1;
                dictionary.put(word,count);
            }
            else{
                //count++;
                dictionary.put(word, dictionary.get(word) + 1);
            }
        }

    }

    //описывает исходящие tuple
    @Override
    public void declareOutputFields(OutputFieldsDeclarer outputFieldsDeclarer) {
    }
}
