require 'json'
require_relative 'readdata'
require_relative 'tablereader'
require_relative 'reportmail'
module Formulamanage
		def manager
				result=Array.new
				File.open("./monitorlist") do |file|
				file.each do |line|
						#puts line
						newline=line.delete '"'
						infolist=newline.split(':')
						infolist[0]=infolist[0].lstrip.rstrip
						infolist[1]=infolist[0].split('/')[1].split('.')[1].lstrip.rstrip
						infolist[2]=infolist[2].delete ','.lstrip.rstrip
						#puts infolist[0]+" "+infolist[1]+" "+infolist[2]
						
						if infolist[2].match('<')&&!infolist[2].match('&')&&!infolist[2].match('\(')
								formula=infolist[2].split('<')
								formula[0]=formula[0].lstrip.rstrip
								formula[1]=formula[1].gsub(/=/,'')
								formula[1]=formula[1].lstrip.rstrip
								result.push(infolist[0]+" "+infolist[1]+" "+formula[0]+" < "+formula[1])
								#puts(infolist[0]+" "+infolist[1]+" "+formula[0]+" < "+formula[1])
						elsif infolist[2].match('>')&&!infolist[2].match('&')&&!infolist[2].match('\(')
								formula=infolist[2].split('>')
								formula[0]=formula[0].lstrip.rstrip
								formula[1]=formula[1].gsub(/=/,'')
								formula[1]=formula[1].lstrip.rstrip
								result.push(infolist[0]+" "+infolist[1]+" "+formula[0]+" > "+formula[1])
								#puts(infolist[0]+" "+infolist[1]+" "+formula[0]+" > "+formula[1])
						end
						
				end
				end
				return result
		end
		def rengelist(rela1,rela2,startdate,enddate)
				report=manager
				renge=Array.new
				renge2=Array.new
				report.each do |rep|
						item=rep.split[2]
						mean,sdiv=readdata(item)
						if(mean==-1000.0001&&sdiv==1000.0001)
								next
						end
						low1,low2,top1,top2=getrange(rela1,rela2,mean,sdiv)
						suggest=0
						if rep.split[3]==">"
								suggest=top2
						elsif rep.split[3]=="<"
								suggest=low1
						end
						if item.include? "_flow_cps"
							if low1==low2&&low2==top1&&top2==top1
								if top2!=rep.split[4].to_f
								renge2.push("#ffff93 "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
								else
								renge2.push("#ffffff "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
								end
							elsif rangejudge(rep.split[3],rep.split[4].to_f,low1,low2,top1,top2)
								renge2.push("#ffffff "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
							else
								renge2.push("#ff0000 "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
							end
						else
							if low1==low2&&low2==top1&&top2==top1
								if top2!=rep.split[4].to_f
								renge.push("#ffff93 "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
								else
								renge.push("#ffffff "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
								end
							elsif rangejudge(rep.split[3],rep.split[4].to_f,low1,low2,top1,top2)
								renge.push("#ffffff "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
							else
								renge.push("#ff0000 "+rep.split[1]+" "+rep.split[2]+" "+rep.split[3]+" "+rep.split[4]+" "+"["+low1.to_s+","+low2.to_s+"]"+",["+top1.to_s+","+top2.to_s+"]"+" "+suggest.to_s)
							end
						end
				end
				mailmanager("baizhenchao",renge,renge2,startdate,enddate)
				puts "report mail has been delivered!"
		end
		def rangejudge(symbol,value,low1,low2,top1,top2)
				case symbol
				when '<'
						if value>=low1&&value<=low2
								return true
						else
								return false
						end
				when '>'
						if value>=top1&&value<=top2
								return true
						else
								return false
						end
				else
						return false
				end
		end
end
include Formulamanage
#puts(array[0]+"-"+array[1]+"-"+array[2]+"-"+array[3])
#rengelist(0.995,0.999,"20140731140719","20140807140725")
rengelist(ARGV[0].to_f,ARGV[1].to_f,ARGV[2],ARGV[3])

#puts rangejudge(">",100,5,10,95,99)
#rengelist 0.995,0.999
#manager 
