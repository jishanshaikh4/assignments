// Java/Hadoop program for finding the average marks
// Author: JISHAN SHAIKH

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class AverageMarks {
	public static void main(String [] args) throws Exception

	{

	Configuration conf=new Configuration();
	Job job=new Job(conf,"Average marks ");
	job.setJarByClass(AverageMarks.class);
	job.setMapperClass(MapClass.class);
	job.setReducerClass(ReduceClass.class);
	job.setOutputKeyClass(Text.class);
	job.setMapOutputValueClass(IntWritable.class);
	job.setOutputValueClass(FloatWritable.class);
	FileInputFormat.addInputPath(job, new Path(args[0]));
	FileOutputFormat.setOutputPath(job, new Path(args[1]));
	System.exit(job.waitForCompletion(true)?0:1);
	}

	public static class MapClass extends Mapper<LongWritable, Text, Text, IntWritable>{

		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException
		{
			String line = value.toString();
			String[] Words=line.split(",");
			if(Words.length>1)
			{
			context.write(new Text(Words[0]),  new IntWritable(Integer.parseInt(Words[1])));
			}
			
		}
	}

	public static class ReduceClass extends Reducer<Text, IntWritable, Text, FloatWritable>
	{
		public void reduce(Text word, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException
		{
			 int total= 0;	
			int count=0;
	  		 for(IntWritable value : values)
			 {
				total += value.get();
				count+=1;
	   		 }

	   		context.write(word, new FloatWritable(total/count));
			}
	}
}
