#! ruby
require 'mail'
def mailmanager(toname,list,list2,startdate,enddate)
mail=Mail.new do
		from 'baizc@st01-sdcop-dev.st01.baidu.com'
		to toname+'@baidu.com'
		subject 'Monitor Manager'
		html_part do
			content_type 'text/html;charset=UTF-8'
			body bodystring(list,list2,startdate,enddate)
		end
end
mail.delivery_method:sendmail
mail.deliver
end
def bodystring(list,list2,startdate,enddate)
		string="<!doctype html><html xmlns='http://www.w3.org/1999/xhtml'><head><title>my html</title></head><body>"
		string+="<h1>This is about Monitor value checking</h1>"
		date="<div>monitor list in "+startdate+" to "+enddate+"</div>"
		string+=date
		string+='<table border="1" style="color:#333333;border-color:#999999;border-collapse:collapse;width:80%;">'
		string+='<tr style="background:#b5cfd2"><td>porduct line</td><td>module</td><td>item</td><td>monitor value</td><td>confidence-val</td><td>suggest</td></tr>'
		list.each do |line|
				temp="<tr style='background:"+line.split[0]+"'><td>HOUYI</td><td>"+line.split[1]+"</td><td>"+line.split[2]+"</td><td>"+line.split[3]+line.split[4]+"</td><td>"+line.split[5]+"</td><td>"+line.split[6]+"</td></tr>"
				string+=temp
		end
		string+='</table>'
		string+="<br><div>monitor list of  flow_cps</div>"
		string+='<table border="1" style="color:#333333;border-color:#999999;border-collapse:collapse;width:80%;">'
		string+='<tr style="background:#b5cfd2"><td>porduct line</td><td>module</td><td>item</td><td>monitor value</td><td>confidence-val</td><td>suggest</td></tr>'
		list2.each do |line2|
				temp="<tr style='background:"+line2.split[0]+"'><td>HOUYI</td><td>"+line2.split[1]+"</td><td>"+line2.split[2]+"</td><td>"+line2.split[3]+line2.split[4]+"</td><td>"+line2.split[5]+"</td><td>"+line2.split[6]+"</td></tr>"
				string+=temp
		end
		string+='</table></body></html>'
		return string
end
#mailmanager "baizhenchao","manager"
#puts bodystring
