package bmstu.hadoop.lab3;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.MultipleInputs;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
public class AirportMain {

    public static void main(String[] args) throws Exception {

        if (args.length != 3) {

            System.err.println("Usage: WordCountApp <input path1>  <input path2> <output path>");

            System.exit(-1);

        }

        System.out.println("start processing ! " +args[0]+ " " +args[1]);
        Job job = Job.getInstance();

        job.setJarByClass(AirportMain.class);

        job.setJobName("Word count");
        MultipleInputs.addInputPath(job, new Path(args[0]), TextInputFormat.class, bmstu.hadoop.lab3.RaceJoinMapper.class);

        MultipleInputs.addInputPath(job, new Path(args[1]), TextInputFormat.class, bmstu.hadoop.lab3.AirportJoinMapper.class);

       // FileInputFormat.addInputPath(job, new Path(args[0]));
        //FileInputFormat.addInputPath(job, new Path(args[1]));



        FileOutputFormat.setOutputPath(job, new Path(args[2]));

        job.setPartitionerClass(AirportPartitioner.class);

        job.setGroupingComparatorClass(AirportGroupingComparator.class);


        job.setMapOutputKeyClass(AirportComparable.class);
        job.setMapOutputValueClass(Text.class);

        job.setReducerClass(AirportReducer.class);


        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        job.setNumReduceTasks(2);

        System.exit(job.waitForCompletion(true) ? 0 : 1);

    }

}

