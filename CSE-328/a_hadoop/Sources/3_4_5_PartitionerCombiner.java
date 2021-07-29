// Java/Hadoop program for implementing partitioner, combiner
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
import org.apache.hadoop.mapreduce.Partitioner;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Driver{
	public static void main(String [] args)  throws Exception{
	
	Configuration conf =new Configuration();
	Job job=new Job(conf,"Implement Partitioner");
	job.setJarByClass(Driver.class);
	job.setMapperClass(MapClass.class);
	job.setPartitionerClass(PartitionClass.class);
	job.setReducerClass(ReduceClass.class);
	job.setNumReduceTasks(6);
	job.setOutputKeyClass(Text.class);
	job.setOutputValueClass(Text.class);
	FileInputFormat.addInputPath(job, new Path(args[0]));
	FileOutputFormat.setOutputPath(job, new Path(args[1]));
	System.exit(job.waitForCompletion(true)?0:1);
	}

	public static class MapClass extends Mapper<LongWritable, Text, Text, Text>{

		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException
		{
			String line = value.toString();
			String[] Words=line.split(",");
			if(Words.length>1)
			{  
				context.write(new Text(Words[0]),  new Text(Words[1]));
			}	
		}
	}

	public static class PartitionClass extends Partitioner<Text,Text>{
		public int getPartition(Text key,Text value,int numReduceTask)
		{
		if(numReduceTask==0)		
			return 0;
		if(key.equals(new Text("Cse1")))
			return 0;
		else if(key.equals(new Text("Mech1")))
			return 1%numReduceTask;
		else if(key.equals(new Text("Cse2")))
			return 2%numReduceTask;
		else if(key.equals(new Text("Mech2")))
			return 3%numReduceTask;
		else if (key.equals(new Text("Civil")))
			return 4%numReduceTask;
		else 
			return 5%numReduceTask;
		}
	}
	
	public static class ReduceClass extends Reducer<Text,Text,Text,Text>{
		public void reduce(Text key,Iterable<Text> Values,Context context)throws IOException, InterruptedException{
		int sum=0;
		for(Text val:Values)
		{	
			context.write(key,val);
		}
		}	
	}
}
