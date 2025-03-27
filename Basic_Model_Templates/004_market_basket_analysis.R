# 安装和加载必要的包
# install.packages("arules")
# install.packages("arulesViz")
library(arules) #R中必要的包
library(arulesViz)

#加载示例数据，transaction是一个专门的类，存贮交易信息，据说有稠密矩阵构成
data(package="arules")
data("Groceries ")
x=Groceries 

#检查数据
summary(x)
inspect(x)#慎用，会取出全部的交易记录

#设置参数，找到规则
rules = apriori(x,parameter = list(supp = 0.01,conf = 0.5))


#查看结果
inspect(rules)

#排序再查看
sorted_rules=sort(rules,decreasing = T,by=c("lift","coverage","count"))
inspect(sorted_rules)


####可选画图
# 1. 散点图可视化 - 展示规则的支持度、置信度和提升度关系
plot(rules, method = "scatter", measure = c("support", "confidence"), 
     shading = "lift", jitter = 0)

# 2. 图形网络可视化 - 展示项目之间的关联关系
plot(rules, method = "graph", control = list(type = "items"))

# 3. 分组矩阵可视化 - 展示项目集群
plot(rules, method = "grouped")

# 4. 并行坐标图 - 多维度展示规则的各项指标
plot(rules, method = "paracoord", control = list(reorder = TRUE))

# 5. 交互式网络图 - 更直观地探索规则
# 需要额外安装包：install.packages("plotly")
library(plotly)
plot(rules, method = "graph", engine = "htmlwidget")

# 6. 规则的子集筛选与可视化 - 聚焦于特定项目的规则
# 比如查找所有包含"whole milk"的规则
milk_rules <- subset(rules, items %in% "whole milk")
inspect(milk_rules)
plot(milk_rules, method = "graph")

# 7. 创建更美观的规则表格
# 需要额外安装包：install.packages("knitr")
library(knitr)
rules_df <- as(sorted_rules[1:10], "data.frame")
kable(rules_df)