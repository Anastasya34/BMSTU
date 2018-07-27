import org.apache.storm.trident.operation.BaseFilter;
import org.apache.storm.trident.tuple.TridentTuple;

/**
 * Created by anastasiya on 27.01.17.
 */
public class RaceFilter extends BaseFilter {
    private String regexp;

    public RaceFilter() {
    }
    public RaceFilter(String regexp) {
        this.regexp = regexp;
    }

    @Override
    public boolean isKeep(TridentTuple objects) {
        String  delay = objects.getString(0);
        boolean deleteСriterion = !delay.equals("")  && !delay.equals("0.00");
        return deleteСriterion;
    }
}
