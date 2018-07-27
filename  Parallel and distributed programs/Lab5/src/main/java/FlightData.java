import java.io.Serializable;

/**
 * Created by anastasiya on 10.12.16.
 */
public class FlightData implements Serializable {
    private float cancelled;
    private int originAirportId;//	- ID авиапорта
    private float arrDelay;//— разница в минутах между расчетным временем приземления и реальным (может быть отрицательной)
    private float airTime;//	- время в полете в минутах
    private long total;
    private long counter;
    public FlightData() {
    }

    public FlightData(float cancelled, int originAiroportId, float arrDelay, float airTime) {
        this.cancelled = cancelled;
        this.originAirportId = originAiroportId;
        this.arrDelay = arrDelay;
        this.airTime = airTime;
    }
    public FlightData(float cancelled, int originAiroportId, float arrDelay, float airTime, long total, long counter) {
        this.cancelled = cancelled;
        this.originAirportId = originAiroportId;
        this.arrDelay = arrDelay;
        this.airTime = airTime;
        this.total=total;
        this.counter=counter;
    }
    public FlightData(long total, long counter) {
        this.total=total;
        this.counter=counter;
    }

    public long getTotal() {
        return total;
    }
    public long getCounter() {
        return counter;
    }

    public static FlightData addValue(FlightData a, long value) {
        return new FlightData(
                a.getTotal() + value,
                a.getCounter() + 1l );
    }

    public float percentage() {
        return counter/(total / 100);
    }


    public float getArrDelay() {
        return this.arrDelay;
    }
    public void setArrDelay(float id) {
        this.arrDelay = id;
    }
    public float getCancelled() {
        return cancelled;
    }
    public void setCancelled(float fieldValue) {
        this.cancelled=fieldValue;
    }
    public int getOriginAirportId() {
        return originAirportId;
    }
    public void setOriginAirportId(int fieldValue) {
        this.originAirportId = fieldValue;
    }
    public float getAirTime() {
        return airTime;
    }
    public void setAirTime(float fieldValue) {
        this.airTime = fieldValue;
    }
}

