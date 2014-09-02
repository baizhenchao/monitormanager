#! ruby
def getrange(rela1=0.995,rela2=0.999,mean=0,sdiv=1)
		if mean==0&&sdiv==0
		        return 0,0,0,0
		else if sdiv==0&&mean!=0
		        return mean,mean,mean,mean
		end
		prob1=(1-rela1)/2
		prob2=(1-rela2)/2
		flag=true
		range1,range2=0,0
		File.open("normtable.txt") do |file|
				file.each do |line|
						info=line.split
						if flag&&prob2<info[0].to_f
								#puts "range1:"+info[1]
								range2=info[1].to_f
						flag=false
						end
						if prob1<info[0].to_f
								#puts "range2:"+info[1]
								range1=info[1].to_f
						break
						end
				
				end
		end
		range1=range1*sdiv
		range2=range2*sdiv
		low1=mean+range2
		low2=mean+range1
		top1=mean-range1
		top2=mean-range2
		low1=low1.floor
		low2=low2.ceil
		top1=top1.floor
		top2=top2.ceil
		if low1<0
				low1=0
		end
		if low2<0
				low2=0
		end
		return low1,low2,top1,top2
end
end
#low1,low2,top1,top2=getrange(0.995,0.999,239,2040997)
#low1,low2,top1,top2=getrange
#puts "low is ["+low1.to_s+","+low2.to_s+"]"+", top is ["+top1.to_s+","+top2.to_s+"]"

