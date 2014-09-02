#! ruby
def readdata(item)
		if !File.exists?("./DATA/#{item}")
				puts item+": no exists"
				return -1000.0001,1000.0001
		end
		f=File.open("./DATA/#{item}")
		numlist=""
		f.each do |line|
				numlist=line
		end
		if numlist.length<2
				puts item+": no enough data"
				return -1000.0001,1000.0001
		end
		numlist=numlist.rstrip.lstrip
		mean=0.0
		sdiv=0.0
		numdata=numlist.split
		numdata.each do |itemdata|
				mean+=itemdata.to_f
		end
		mean=mean/numdata.size
		numdata.each do |itemdata|
				#if (itemdata.to_f/mean-1).abs>1000
				#		puts itemdata
				#end
				#puts (itemdata.to_f/mean-1).abs
				sdiv+=(mean-itemdata.to_f)*(mean-itemdata.to_f)
		end
		sdiv=(sdiv/numdata.size)**0.5
		#puts "mean: "+mean.to_s+",sdiv: "+sdiv.to_s
		return mean,sdiv
end
#readdata "logpretr_log_accessLog_flow_cnt"
#readdata "router_log_accessLog_flow_cps"

