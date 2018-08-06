import com.google.common.base.Charsets;
import org.apache.storm.shade.com.google.common.collect.Lists;
import org.apache.storm.shade.org.apache.zookeeper.server.quorum.QuorumCnxManager;
import org.apache.storm.spout.SpoutOutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichSpout;
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
public class Spout extends BaseRichSpout {
    public static String NAME_DIR ="/home/anastasiya/IdeaProjects/Lab8/Test" ;
    private SpoutOutputCollector spoutOutputCollector;//Spout отправляет Tuple в SpoutOutputCollector посредством вызова метода emit(new Values(...)).
    private int count = 0;

    //описывает исходящие tuple
    @Override
    public void declareOutputFields(OutputFieldsDeclarer outputFieldsDeclarer) {
        //Для каждого потока задается набор полей
        outputFieldsDeclarer.declareStream("line", new Fields("line"));
        outputFieldsDeclarer.declareStream("sync", new Fields());
    }

    //Параметры извлекаются в spout / иницализирует spout
    @Override
    public void open(Map conf, TopologyContext topologyContext, SpoutOutputCollector spoutOutputCollector) {
        this.spoutOutputCollector = spoutOutputCollector;
    }
    //генерирует следующее сообщение
    @Override
    public void nextTuple() {
        // определяем объект для каталога
        File dir = new File(NAME_DIR);
        File[] masFiles = dir.listFiles();
        String line;

        if (dir.exists() && (dir.isDirectory())) {
            // получаем все вложенные объекты в каталоге
            for (int i=0; i < masFiles.length; i++) {

                if (masFiles[i].isFile()) {
                    try (BufferedReader readerFile = new BufferedReader(new FileReader(masFiles[i]))) {
                        //line = readerFile.readLine()
                        while((line = readerFile.readLine()) != null) {

                            //System.out.println("send "+line+" to stream line");
                            spoutOutputCollector.emit("line", new Values(line));

                        }
                        readerFile.close();
                        System.out.println("finish file processing !");
                        Thread.sleep(1000);
                        spoutOutputCollector.emit("sync", new Values());
                        File new_path= new File("/home/anastasiya/IdeaProjects/Lab8/Output/"+masFiles[i].getName());
                        Files.move(masFiles[i],new_path);
                    }
                    catch (FileNotFoundException file) {
                        sleep(100);
                    }
                    catch (IOException wrongLine) {
                        System.out.println("Error reading" + masFiles[i]);//??

                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

    }
}
