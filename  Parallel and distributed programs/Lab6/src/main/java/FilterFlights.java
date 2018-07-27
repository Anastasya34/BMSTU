import org.apache.hadoop.hbase.exceptions.DeserializationException;
import org.apache.hadoop.hbase.filter.FilterBase;
import org.apache.hadoop.hbase.Cell;
import org.apache.hadoop.hbase.util.Bytes;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

/**
 * Created by anastasiya on 25.01.17.
 */

public class FilterFlights extends FilterBase {

    String selectRowKey;
    boolean remove=true;

    public FilterFlights() {
        super();
    }

    public FilterFlights(String selectRowKey) {

        this.selectRowKey = selectRowKey;
    }

   /* @Override
    public boolean filterRowKey(byte[] buffer, int offset, int length) throws IOException {//true если требутеся убрать строку из результата
        String key = new String(buffer, offset, length);

        return !key.equals(selectRowKey);
    }*/
    @Override
    public byte[] toByteArray() throws IOException {

        return selectRowKey.getBytes("UTF-8");
    }

    @Override
    public ReturnCode filterKeyValue(Cell cell) throws IOException {//вызывается для каждого KeyValue, можем
                                                                    // вернуть команду что делать дальше
        //Constructs a new String by decoding the specified subarray of bytes using the platform's default charset.
        String key = new String(cell.getQualifierArray(), cell.getQualifierOffset(), cell.getQualifierLength());
        String str_value = new String(cell.getValueArray(), cell.getValueOffset(), cell.getValueLength());
        double value=Double.parseDouble(str_value);

        if (key.equals("CANCELLED") && value == 1) {
            remove = false;
        }
        else
            if (key.equals("ARR_DELAY_NEW") && value > Double.parseDouble(selectRowKey)) {
                remove = false;
            }

        return ReturnCode.INCLUDE;
    }

    public static FilterFlights parseFrom(byte[] pbBytes) throws DeserializationException {
        try {
            System.out.println("create filter!");
            return new FilterFlights(new String(pbBytes, "UTF-8"));
        }
        catch (UnsupportedEncodingException e) {

            throw new DeserializationException(e);
        }
    }


    @Override
    public void reset() throws IOException {
        this.remove = true;
    }

    @Override
    public boolean filterRow() throws IOException {
        return this.remove;
    }


}

