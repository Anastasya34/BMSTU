import java.io.Serializable;

public class Counter implements Serializable {
    private Float totalCountRace;
    private Float cancalledOrLatecomerRaceCount;
    private Float maxTimeDelay;

    public Counter(){}

    public Float getMaxTimeDelay() {
        return maxTimeDelay;
    }

    public Counter(Float total, Float cancalledOrLatecomerRaceCount, Float maxTimeDelay) {
        this.totalCountRace = total;
        this.cancalledOrLatecomerRaceCount = cancalledOrLatecomerRaceCount;
        this.maxTimeDelay = maxTimeDelay;
    }


    public void setTotalCountRace(Float totalCountRace) {
        this.totalCountRace = totalCountRace;
    }

    public void setCancalledOrLatecomerRaceCount(Float cancalledOrLatecomerRaceCount) {
        this.cancalledOrLatecomerRaceCount = cancalledOrLatecomerRaceCount;
    }


    public void setMaxTimeDelay(Float maxTimeDelay) {
        this.maxTimeDelay = maxTimeDelay;
    }



    public Float getTotalCountRace() {
        return totalCountRace;
    }
    public Float getCancalledOrLatecomerRaceCount() {
        return cancalledOrLatecomerRaceCount;
    }

    public static Float max( Counter a, Counter b){
        if (a.getMaxTimeDelay()>b.getMaxTimeDelay())
            return a.getMaxTimeDelay();
        else return b.getMaxTimeDelay();
    }

    public static Counter addValue(Counter a, Float value) {
        return new Counter(
                a.getTotalCountRace() + 1l,
                a.getCancalledOrLatecomerRaceCount() + value,
                a.getMaxTimeDelay());
    }
    public static Counter add( Counter a, Counter b) {
        return new Counter(
                a.getTotalCountRace() + b.getTotalCountRace(),
                a.getCancalledOrLatecomerRaceCount() +b.getCancalledOrLatecomerRaceCount(),
                max(a,b)
        );
    }
    public float percentage() {
        return cancalledOrLatecomerRaceCount/(totalCountRace / 100);
    }


}