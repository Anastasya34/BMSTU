import com.google.common.base.Charsets;
import org.apache.storm.shade.com.google.common.collect.Lists;
import org.apache.storm.shade.org.apache.zookeeper.server.quorum.QuorumCnxManager;
import org.apache.storm.spout.SpoutOutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichSpout;
import org.apache.storm.trident.operation.TridentCollector;
import org.apache.storm.trident.spout.IBatchSpout;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Values;
import com.google.common.io.Files;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.apache.storm.utils.Utils.sleep;

/**
 * Created by anastasiya on 25.01.17.
 */
public class Spout implements IBatchSpout {
    public static String NAME_DIR = "/home/anastasiya/IdeaProjects/Lab8/Test";
    private TopologyContext topologyContext;


    @Override
    public void open(Map map, TopologyContext topologyContext) {
        this.topologyContext = topologyContext;

    }

    @Override
    public void emitBatch(long batchId, TridentCollector tridentCollector) {
        File dir = new File(NAME_DIR);
        String line;
        if (dir.exists() && (dir.isDirectory())) {
            // получаем все вложенные объекты в каталоге
            File[] masFiles = dir.listFiles();
            for (int i=0; i < masFiles.length; i++) {

                try (BufferedReader readerFile = new BufferedReader(new FileReader(masFiles[i]))) {
                    line = readerFile.readLine();
                    while (readerFile.readLine() != null) {
                        line = readerFile.readLine();
                        tridentCollector.emit(new Values(line));

                    }
                    readerFile.close();
                    File new_path= new File("/home/anastasiya/IdeaProjects/Lab8/Output/"+masFiles[i].getName());
                    Files.move(masFiles[i], new_path);
                }
                catch (FileNotFoundException file) {
                    System.out.println("File " + file+ " not found");
                }
                catch (IOException wrongLine) {
                    System.out.println("Error reading" + masFiles[i]);

                }
            }
        }
    }
    @Override
    public void ack(long  batchId) {}

    @Override
    public void close() {}

    @Override
    public Map<String, Object> getComponentConfiguration() {
        return null;
    }

    @Override
    public Fields getOutputFields() {
        return new Fields("row");
    }

}
