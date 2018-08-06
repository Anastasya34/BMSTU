import org.apache.storm.trident.operation.BaseFilter;
import org.apache.storm.trident.tuple.TridentTuple;

/**
 * Created by anastasiya on 24.01.17.
 */
public class PrintFilter extends BaseFilter {
    private String regexp;
    public PrintFilter() {
    }
    public PrintFilter(String regexp) {
        this.regexp = regexp;
    }
    @Override
    public boolean isKeep(TridentTuple objects) {
        System.out.println(objects);
        return false;

    }
}
