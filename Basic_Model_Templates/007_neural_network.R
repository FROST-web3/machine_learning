#既可以分类，也可以回归
#复杂数据，计算资源需求大

library(caret) #训练简单模型的统一接口R包
library(e1071) #支持向量机和其他算法
library(Boruta) #特征选择
library(nnet) #神经网络R包


#读一个数据集，这个能直接使用
x=iris

#设置全局的随机数种子
set.seed(123)

#boruta特征选择
boruta_result=Boruta(Species~.,data = x,num.threads= 12)

#查看
boruta_result

# 获取确认重要的特征，不要暂定特征
important_features <- getSelectedAttributes(boruta_result,withTentative = FALSE)

#写公式formula
formula=paste("Species~", paste(important_features, collapse = " + "))
formula=as.formula(formula)


#####神经网络训练
#设置训练控制参数
ctrl <- trainControl(method = "cv", number = 5,search = "grid") #默认就是grid搜索

#训练
model_nnet <- train(formula,  #在R的caret包中，"+"符号的含义与算法类型无关。公式接口主要用于指定哪些变量是预测变量，哪些是目标变量，而不是定义这些变量之间的数学关系。
               data = x,
               method = "nnet",  
               nthread = 12,
               tuneLength = 10, #每个超参数自动生成的个数
               trControl = ctrl,
               preProcess = c("center", "scale")
               )
#传统方式
model_nnet <- train(
               x=x[,important_features],
               y=x$Species, #或 y=x[,"Species"]
               method = "nnet",  
               nthread = 12,
               tuneLength = 5, #每个超参数自动生成的个数
               trControl = ctrl,
               preProcess = c("center", "scale")
               )

#查看模型和过拟合报告
model_nnet
model_nnet$resample