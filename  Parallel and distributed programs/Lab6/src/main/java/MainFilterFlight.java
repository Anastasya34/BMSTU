import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.filter.BinaryComparator;
import org.apache.hadoop.hbase.filter.CompareFilter;
import org.apache.hadoop.hbase.filter.Filter;
import org.apache.hadoop.hbase.filter.RowFilter;
import org.apache.hadoop.hbase.util.Bytes;

/**
 * Created by anastasiya on 25.01.17.
 */
public class MainFilterFlight {
    public static void main(String[] args) throws Exception {

        Configuration config = HBaseConfiguration.create();
        config.set("hbase.zookeeper.quorum", "localhost");
        Connection connection = ConnectionFactory.createConnection();
        Table tableFlights = connection.getTable(TableName.valueOf("Flights"));

        Scan scan = new Scan();

        scan.addFamily("flights data".getBytes());
        //диапазон дат
        scan.setStartRow(Bytes.toBytes("row80"));
        scan.setStopRow(Bytes.toBytes("row89"));
        String delayTime="7.00";
        scan.setFilter(new FilterFlights( delayTime));

        ResultScanner scanner = tableFlights.getScanner(scan);//итератор
        for (Result res : scanner) {
            System.out.println("row = " + res);
        }

        scanner.close();
        tableFlights.close();
        connection.close();
    }
}
