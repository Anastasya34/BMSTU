import org.apache.storm.trident.operation.BaseFunction;
import org.apache.storm.trident.operation.TridentCollector;
import org.apache.storm.trident.operation.TridentOperationContext;
import org.apache.storm.trident.tuple.TridentTuple;
import org.apache.storm.tuple.Values;

import java.util.Map;

/**
 * Created by anastasiya on 27.01.17.
 */

public class Function extends BaseFunction {
//
//    DAY_OF_WEEK = 4;
//    ARR_DELAY_NEW = 18;
//    IS_CANCELLED = 19;

    //each(new Fields("row"), new SplitFunction(), new Fields("day_of_week", "array_delay", "is_cancelled"))
    @Override
    public void execute(TridentTuple tridentTuple, TridentCollector tridentCollector) {
        String row =tridentTuple.getString(0);
        String[] columns = row.split(",");
        tridentCollector.emit(new Values(columns[4], columns[18], columns[19])); //emit tuple
    }
}