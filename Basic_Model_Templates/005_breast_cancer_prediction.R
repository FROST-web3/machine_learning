#初步探索用随机森林，最终部署用梯度提升树
#特征选择：对随机森林/梯度提升树：优先使用RFE或Boruta

library(Boruta)
library(caret)


#读数据
x=read.csv("Rdata/breast.csv",row.names = 1)

#预处理
x=x[,-1]
x=na.omit(x)

#把最后的类别一列改为0 1
x[x[,10]==4,10]=1
x[x[,10]==2,10]=0
x$class=as.factor(x$class)

#设置全局的随机数种子
set.seed(123)

#boruta选择特征，会隐势用到全局随机数种子
boruta_result <- Boruta(
  class ~ .,          # 使用所有变量预测class
  data = x,           # 数据框
  maxRuns = 300,      # 设置较高的迭代次数以确保算法收敛
  doTrace = 2,        # 输出详细进度信息
  pValue = 0.01,      # 使用1%的显著性水平
  mcAdj = TRUE,       # 应用多重比较调整
  holdHistory = TRUE, # 保存完整历史以便后续分析
  num.threads = 12     # 使用4个线程加速计算（根据您的CPU调整）
)

# 打印Boruta结果摘要
boruta_result


# 获取确认重要的特征，不要暂定特征
important_features <- getSelectedAttributes(boruta_result,withTentative = FALSE)

#写公式formula
formula=paste("class ~", paste(important_features, collapse = " + "))
formula=as.formula(formula)

#####随机森林
# 设置10折交叉验证
ctrl <- trainControl(method = "cv", number = 10,search = "grid") 

# 使用train()函数训练模型
model_rf <- train(formula, #在R的caret包中，"+"符号的含义与算法类型无关。公式接口主要用于指定哪些变量是预测变量，哪些是目标变量，而不是定义这些变量之间的数学关系。
               data = x,
               method = "rf",  # 随机森林算法，可以替换为其他算法
               nthread = 12,
               tuneLength = 100,
               trControl = ctrl)


#####梯度提升树
# 使用train()函数训练模型
model_XGBoost <- train(formula, 
               data = x,
               method = "xgbTree",  # XGBoost，梯度提升树算法算法之一
               nthread = 12,
               tuneLength = 100,
               trControl = ctrl)

#####查看模型结果
#查看性能
model_rf
model_XGBoost
#查看过拟合
model_XGBoost$resample
model_rf$resample


#####模型简单使用
result_1=predict(model_XGBoost,newData)

#混淆矩阵检验
table(newData$class,result_1)