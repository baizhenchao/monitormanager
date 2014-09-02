require 'json'
require_relative 'statics'
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
				report=Array.new
				result.each do |res|
						info=res.split[0]
						if info.match('/instance')
							info["/instance"]="/cluster"
						elsif info.match('/host')
							info["/host"]="/cluster"
						end
						service= `grep service ./HOUYI/#{info}`
						if !service.empty?
								service=service.split(':')[1]
								service=service.delete '"'
								service=service.delete ','
								service=service.lstrip.rstrip
								report.push(res.split[1]+" "+res.split[2]+" "+res.split[3]+" "+res.split[4]+" "+getbnsmeta(service))
								#puts(res.split[1]+" "+res.split[2]+" "+res.split[3]+" "+res.split[4]+" "+getbnsmeta(service))
						else
								bns=getbnsjson(info)
								if !bns.match('error')
										report.push(res.split[1]+" "+res.split[2]+" "+res.split[3]+" "+res.split[4]+" "+bns)
										#puts(res.split[1]+" "+res.split[2]+" "+res.split[3]+" "+res.split[4]+" "+bns)
								end
						end
				end
				return report
		end
		def getbnsmeta(service)
				bns=Array.new
				res=JSON.parse(`meta-query relation -j  service #{service}`)
				res["#{service}"].each do |names|
						bns.push(names["Name"])
				end
				return bns.join(",")
		end
		def getbnsjson(url)
				begin
				json=File.read('./HOUYI/'+url)
				res=JSON.parse(json)
				rescue Exception
						return "error"
				else
						return res["namespace_list"].join(",")
				end
		end
		def rengelist(rela1,rela2,startdate,enddate)
				report=manager
				renge=Array.new
				i=0
				report.each do |rep|
						serlist=rep.split[4]
						item=rep.split[1]
						str=getmeanandsdiv(serlist,item,startdate,enddate)
						File.new("./DATA/#{item}","w")
						nf=File.open("./DATA/#{item}","w+")
						if str=="error"
								File.delete("./DATA/#{item}")
								puts "a getdata error jumover"
								next
						end
						nf.puts(str)
						i+=1
						puts(i.to_s+" items has done!")
				end
				puts "data download complete!"
		end
end
include Formulamanage
#puts(array[0]+"-"+array[1]+"-"+array[2]+"-"+array[3])
rengelist(ARGV[0].to_f,ARGV[1].to_f,ARGV[2],ARGV[3])

#puts rangejudge(">",100,5,10,95,99)
#rengelist 0.995,0.999,"20140801060000","20140801180000"
#manager 
