#!ruby
Small=-5
Large=5
Deta=0.00001
Prec=0.00001
def func(x,u,o)
		temp1=(x-u)/o
		temp2=-1*temp1*temp1/2
		temp3=Math::E**temp2/o
		temp4=temp3/(2*Math::PI)**0.5
		return temp4
end
def norminv(prob,mean=0,sdiv=1)
		flag=false
		dSum=0
		di=-100000000
		i=Small
		if prob>0.5
				prob=1-prob
				flag=true
		end
		while i+Deta<=Large do
				dSum+=func(i,mean,sdiv)*Deta
				if (dSum-prob).abs<=Prec
						di=i
						break
				end
				i+=Deta
		end
		if(flage)
				di=-di
		end
		return di
end
def getrange()
		if !File::exists?("normtable.txt")
		        File.new("normtable.txt","w")
		end
		f=File.open("normtable.txt","w+")
		i=0.0
		while i+0.0005<=1 do
		f.puts(i.to_s+" "+norminv(i,0,1).to_s)
		puts i
		i+=0.0005
		end
end
getrange
#i=0.99999
#puts norminv(i,0,1).to_s
