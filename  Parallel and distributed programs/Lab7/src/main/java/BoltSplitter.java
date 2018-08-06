import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

import java.util.Map;

/**
 * Created by anastasiya on 25.01.17.
 */
public class BoltSplitter extends BaseRichBolt {

    private OutputCollector outputCollector;

    @Override
    public void prepare(Map map, TopologyContext topologyContext, OutputCollector outputCollector) {
        this.outputCollector = outputCollector;
    }
    //обрабатывает входящий tuple и(возможно) генерирует исходящие
    @Override
    public void execute(Tuple tuple) {
        //System.out.println("splitter tuple with id="+tuple.getSourceStreamId());
        String line=tuple.getStringByField("line");
        line=line.replace(",","")
                 .replace(".", "");
        String[] words=line.split(" ");

        for (int i=0; i < words.length; i++) {
            //System.out.println("send word " + words[i]);
            outputCollector.emit(tuple, new Values(words[i]));
        }

    }

    //описывает исходящие tuple
    @Override
    public void declareOutputFields(OutputFieldsDeclarer outputFieldsDeclarer) {
        outputFieldsDeclarer.declare(new Fields("word"));

    }
}