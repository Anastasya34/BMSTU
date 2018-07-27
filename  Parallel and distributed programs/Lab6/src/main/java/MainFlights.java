/**
 * Created by anastasiya on 24.01.17.
 */
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Table;
import org.apache.hadoop.hbase.util.Bytes;

import java.io.BufferedReader;
import java.io.FileReader;

public class MainFlights {

    public static void main(String[] args) throws Exception {

        Configuration config = HBaseConfiguration.create();
        config.set("hbase.zookeeper.quorum", "localhost");
        Connection connection = ConnectionFactory.createConnection();
        Table tableFlights = connection.getTable(TableName.valueOf("Flights"));
        byte[] nameColumnFamily = Bytes.toBytes("flights data");

        String pathFileFlights = "/home/anastasiya/IdeaProjects/Lab3/Race.csv";

        BufferedReader fileReader = new BufferedReader(new FileReader(pathFileFlights));

        String row = fileReader.readLine();//первая строка
        row = row.replace("\"", "");
        String[] nameColumns = row.split(",");

        String[] columnsInRow= new String[nameColumns.length];
        int idRow = 1;

        while (fileReader.readLine() != null) {
            //очищаем строку от ковычек и запятых
            row = fileReader.readLine();
            row = row.replace("\"","");
            columnsInRow = row.split(",");

            Put putInTable = new Put(Bytes.toBytes(columnsInRow[5]  + columnsInRow[7] +  Integer.toString(idRow)));//??

            for(int i=0; i < nameColumns.length; i++) {
                putInTable.addColumn(   nameColumnFamily,//имя ColumnFamily
                                        Bytes.toBytes(nameColumns[i]),//название столбца
                                        Bytes.toBytes(columnsInRow[idRow]));//содержание столбца
            }

            tableFlights.put(putInTable);
            idRow++;
        }
        tableFlights.close();
        fileReader.close();
        connection.close();
    }
}
