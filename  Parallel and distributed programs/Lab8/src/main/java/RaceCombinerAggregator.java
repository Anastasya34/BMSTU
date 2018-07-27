import org.apache.storm.shade.com.google.common.collect.Maps;
import org.apache.storm.trident.operation.CombinerAggregator;
import org.apache.storm.trident.tuple.TridentTuple;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by anastasiya on 27.01.17.
 */

public class RaceCombinerAggregator implements CombinerAggregator<Integer> {

    //aggregateByKey
    @Override
    public Integer init(TridentTuple tridentTuple) {
        return 1;
    }

    @Override
    public Integer combine(Integer a, Integer b) {
        return a + b;
    }

    //Нейтральный элемент
    @Override
    public Integer zero() {
        return 0;
    }
}