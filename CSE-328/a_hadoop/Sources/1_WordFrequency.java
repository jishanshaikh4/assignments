// Java/Hadoop program for finding the frequency of words
// Author: JISHAN SHAIKH

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
public class WordFrequency {
	public static void main(String [] args) throws Exception
	{

		Configuration conf=new Configuration();
		Job job=new Job(conf,"wordcount");
		job.setJarByClass(WordFrequency.class);
		job.setMapperClass(MapClass.class);
		job.setReducerClass(ReduceClass.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		FileInputFormat.addInputPath(job, new Path(args[0]));
		FileOutputFormat.setOutputPath(job, new Path(args[1]));
		System.exit(job.waitForCompletion(true)?0:1);

	}

	public static class MapClass extends Mapper<LongWritable, Text, Text, IntWritable>{

		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException
		{
			String line = value.toString();
			String[] words=line.split(" ");
			for(String word: words)
			{
			 	context.write(new Text(word.trim()),  new IntWritable(1));
			}
		}
	}

	public static class ReduceClass extends Reducer<Text, IntWritable, Text, IntWritable>
	{
		public void reduce(Text word, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException
		{
			 int sum = 0;	
	  		 for(IntWritable value : values)
			 {
				sum += value.get();
	   		 }

	   		context.write(word, new IntWritable(sum));
		}
	}
}
