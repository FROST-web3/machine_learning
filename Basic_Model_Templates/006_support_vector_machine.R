#列多、行少的时候，选择SVM。SVM处理稀疏矩阵很有效。最终把样本分为两类，但可拓展。计算消耗小
# 安装并加载caret包和e1071包（caret依赖e1071来实现SVM）
library(caret)
library(e1071)
library(Boruta)
library(kernlab)


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

######SVM训练
# 设置5折交叉验证
ctrl <- trainControl(method = "cv", number = 5,search = "grid") #默认就是grid搜索 

#训练
model_SVM <- train(formula, #在R的caret包中，"+"符号的含义与算法类型无关。公式接口主要用于指定哪些变量是预测变量，哪些是目标变量，而不是定义这些变量之间的数学关系。
               data = x,
               method = "svmRadial",  # SVM有几种不同的算法，适合不同的情况,这个是比较通用的
               nthread = 12,
               tuneLength = 100, #每个超参数自动生成的个数
               trControl = ctrl,
               preProcess = c("center", "scale") #已经用了boruta选择特征了"nzv", "corr"就不需要了
               )

#查看模型和过拟合报告
model_SVM
model_SVM$resample


#####模型简单使用
result_1=predict(model_SVM ,newData)

#混淆矩阵检验
table(newData$class,result_1)


###补充：传统的调用方式
model_SVM <- train( 
               x=x[,important_features],
               y=x$Species,
               method = "svmRadial",  # SVM有几种不同的算法，适合不同的情况,这个是比较通用的
               nthread = 12,
               trControl = ctrl,
               preProcess = c("center", "scale","nzv", "corr")
               )