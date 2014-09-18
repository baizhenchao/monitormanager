monitormanager
==============
功能：
统计各个监控项数据，用正态分布函数获取99.5%置信区间，产出报表

主要文件：

Monitorrun.sh 项目启动脚本，可配位CT任务

Download.rb 从SVN中co出监控项信息处理，产出monitorlist

Localmanager.rb 从monitorlist读入处理过的监控项信息，计算，产出报表

Monitorlist 临时文件，处理过的监控项信息

Statics.rb 支持函数，本地监控项信息缺失时访问API取得相应信息

Readdata.rb 支持函数，获取监控项的均值和方差

Tablereader.rb 支持函数，根据标准正态分布表计算置信区间

Normtable.txt 标准正态分布表

Cratenormtable.rb 产生标准正态分布表

其他皆为测试文件
