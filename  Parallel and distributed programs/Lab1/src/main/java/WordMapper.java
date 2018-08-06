
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.Mapper;
import java.io.IOException;
import java.lang.String;
import java.lang.Character;
import static java.lang.Character.toLowerCase;
import java.util.regex.*;


public class WordMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
    @Override
    protected void map(LongWritable key, Text value, Mapper.Context context) throws
            IOException, InterruptedException {

        String line = value.toString();
        String line_without_simbol=removeAllNonSymbols(line);
        line=line_without_simbol.toLowerCase();
        String[] words =line.split(" ");
        for (String word : words) {
            if (!word.equals(""))
                context.write(new Text(word), new IntWritable(1));
        }
    }

    public static String removeAllNonSymbols(String s) {
        String r = "";
        for (int i = 0; i < s.length(); i ++){
            if ((s.charAt(i) != ')')
                    && (s.charAt(i) != '(')
                    && (s.charAt(i) != '.')
                    && (s.charAt(i) != ',')
                    && (s.charAt(i) != ';')
                    && (s.charAt(i) != ':')
                    && (s.charAt(i) != '—')
                    && (s.charAt(i) != '[')
                    && (s.charAt(i) != ']')
                    && (s.charAt(i) != '\'')
                    && (s.charAt(i) != '!')
                    && (s.charAt(i) != '?')
                    && (s.charAt(i) != '»')
                    && (s.charAt(i) != '…')
                    && (s.charAt(i) != '“')
                    )
                r += s.charAt(i);

        }
        return r;

    }
}