package bmstu.hadoop.lab3;

import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class AirportComparable implements WritableComparable<AirportComparable>{
    private int originAiroportId;//	- ID авиапорта
    private int dataId;



    public int getOriginAiroportId() {
        return originAiroportId;
    }
    public void setOriginAiroportIdAiroportId(int fieldValue) {
        this.originAiroportId = fieldValue;
    }

    public int getDataId() {
        return dataId;
    }
    public void setDataId(int fieldValue) {
        this.dataId = fieldValue;
    }

    public int compareTo(AirportComparable record) {
        int result;

        result=Integer.compare(this.originAiroportId,record.getOriginAiroportId());
        if(result != 0)
            return result;

        result = Integer.compare(this.dataId, record.getDataId());
        if(result != 0)
            return result;

        return result;
    }

    public int compareToForGroupingComparator(AirportComparable record) {
        return Integer.compare(this.originAiroportId,record.getOriginAiroportId());
    }

    //сериализация данных
    public void write(DataOutput out) throws IOException {
        out.writeInt(originAiroportId);
        out.writeInt(dataId);
    }
    //десериализация
    public void readFields(DataInput in) throws IOException {
        originAiroportId = in.readInt();
        dataId = in.readInt();
    }



    public int hashCode() {
        return toString().hashCode();
    }

    public boolean equals(Object that){
        if (that==null)
            return false;

        if(!(that instanceof AirportComparable)) {
            return false;
        }

        AirportComparable thatObj= (AirportComparable) that;


        if (this.originAiroportId != thatObj.originAiroportId) return false;

        if (this.dataId!= thatObj.dataId) return false;

        return true;
    }


    @Override
    public String toString() {
        String str="airportId: "+Integer.toString(this.originAiroportId)+" dataId: "+Integer.toString(this.dataId);
        return str;
    }


}
