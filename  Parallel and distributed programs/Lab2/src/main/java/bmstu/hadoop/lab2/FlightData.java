package bmstu.hadoop.lab2;

import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class FlightData implements WritableComparable<FlightData>{
    private boolean cancelled;
    private int originAiroportId;//	- ID авиапорта
    private float arrDelay;//— разница в минутах между расчетным временем приземления и реальным (может быть отрицательной)
    private float airTime;//	- время в полете в минутах


    public float getArrDelay() {
        return this.arrDelay;
    }
    public void setArrDelay(float id) {
        this.arrDelay = id;
    }
    public boolean getCancelled() {
        return cancelled;
    }
    public void setCancelled(float fieldValue) {
        if ((int)fieldValue==1)
            this.cancelled = true;
        else
            this.cancelled = false;
    }
    public int getOriginAiroportId() {
        return originAiroportId;
    }
    public void setOriginAiroportId(int fieldValue) {
        this.originAiroportId = fieldValue;
    }
    public float getAirTime() {
        return airTime;
    }
    public void setAirTime(float fieldValue) {
        this.airTime = fieldValue;
    }

    public int compareTo(FlightData record) {
        int result;

        if (!(record.cancelled ==this.cancelled)) {
            if (this.cancelled)
                return 1;
            else
                return -1;
        }

        result= Float.compare(this.arrDelay,record.getArrDelay());
        if (result!=0)
            return result;

        result=Integer.compare(this.originAiroportId,record.getOriginAiroportId());
        if(result != 0)
            return result;

        result = Float.compare(this.airTime, record.getAirTime());
        if(result != 0)
            return result;

        return result;
    }

    //сериализация данных
    public void write(DataOutput out) throws IOException {
        out.writeBoolean(cancelled);
        out.writeFloat(arrDelay);
        out.writeInt(originAiroportId);
        out.writeFloat(airTime);
    }
    //десериализация
    public void readFields(DataInput in) throws IOException {
        cancelled = in.readBoolean();
        arrDelay = in.readFloat();
        originAiroportId = in.readInt();
        airTime = in.readFloat();
    }



    public int hashCode() {
     return toString().hashCode();
    }

    public boolean equals(Object that){
        if (that==null)
            return false;

        if(!(that instanceof FlightData)) {
            return false;
        }

        FlightData thatObj= (FlightData) that;


        if (this.cancelled != thatObj.cancelled) return false;

        if (this.arrDelay != thatObj.arrDelay) return false;

        if (this.originAiroportId != thatObj.originAiroportId) return false;

        if (this.airTime != thatObj.airTime) return false;

        return true;
    }


    @Override
    public String toString() {
        String str="Cancelled: "+Boolean.toString(cancelled)+" ArrDelay: "+Float.toString(this.arrDelay)+" originAiroportId: "+Integer.toString(this.originAiroportId)+" airportTime: "+Float.toString(this.airTime);
        return str;
    }


}
