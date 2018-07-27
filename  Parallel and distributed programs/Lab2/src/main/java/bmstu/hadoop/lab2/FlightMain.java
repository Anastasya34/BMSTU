package bmstu.hadoop.lab2;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
public class FlightMain {

        public static void main(String[] args) throws Exception {

        if (args.length != 2) {

            System.err.println("Usage: WordCountApp <input path> <output path>");

            System.exit(-1);

        }
        Job job = Job.getInstance();

        job.setJarByClass(FlightMain.class);

        job.setJobName("Word count");

        FileInputFormat.addInputPath(job, new Path(args[0]));

        FileOutputFormat.setOutputPath(job, new Path(args[1]));

            job.setPartitionerClass(FlightPartitioner.class);
            job.setGroupingComparatorClass(FlightGroupingComparator.class);

            job.setMapperClass(FlightMapper.class);
            job.setReducerClass(FlightReducer.class);


            job.setMapOutputKeyClass(FlightData.class);
            job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(String.class);

        job.setOutputValueClass(Text.class);

        job.setNumReduceTasks(2);

        System.exit(job.waitForCompletion(true) ? 0 : 1);

    }

}

