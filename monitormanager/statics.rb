#! ruby
require 'json'
def getnum(serlist,item,startdate,enddate)
		numlist=Array.new
		reslist=(`monquery -o json -d 1200 -t instance -n #{serlist} -i #{item} -s #{startdate} -e #{enddate}`)
		reslist.split().each do |res|
				begin
				jsonres=JSON.parse(res)
				rescue
						puts "one date has been jump over"
						next
				end
				numlist.push(jsonres["item"][0]["value"])
		end
		return numlist
end

def getmeanandsdiv(serlist,item,startdate,enddate)
	numlist=getnum serlist,item,startdate,enddate
	n=0
	res=""
	numlist.each do |num|
			res+=" "+num.to_s
			n=n+1
	end
	if n==0
			return "error"
	end
	res=res.rstrip.lstrip
	return res
end

#get=ARGV.to_s.delete('[').delete(']').delete(',').delete('"')
#array=get.split
#mean,sdiv,date=getmeanandsdiv(ARGV[0],ARGV[1],ARGV[2].to_s,ARGV[3].to_s)
#puts(ARGV[0]+"-"+ARGV[1]+"-"+ARGV[2]+"-"+ARGV[3])

#mean,sdiv=getmeanandsdiv "ck.HOUYI.tc","mon_logpre_rstatus","20140801060000","20140801180000"
#puts "mean is"+mean.to_s+", div is"+sdiv.to_s
#puts array[0]+" "+array[1]+" "+array[2]+" "+array[3]
#mean,sdiv,data=getmeanandsdiv "ck.HOUYI.tc,ck.HOUYI.jx,ck.HOUYI.m1,ck.HOUYI.cq","logagent_proc_main_thread_num","20140801060000","20140801180000"
#puts "mean is"+mean.to_s+", div is"+sdiv.to_s
#puts data
