#####流程思维链总结：
  #1.我的目的从state.x77数据集中训练出一个线性回归模型，从别的参数预测出谋杀率。
  #2.首先用lm建立一个全参数模型。和空模型
  #3.使用step()，用三种方法找到合适的参数。得到三个初步模型。
  #4.评估这三个，发现是一样的
  #5.使用caret包中的train，选择公式，再训练并选择"CV"也就是K折验证来检验模型。


  #6.可选：使用car包中的vif()来计算有没有多重线性关系。
  #7.可选：最开始先画出皮尔逊相关系数，然后保存在cor_matrix，用corrplot(cor_matrix, method="circle", type="upper", tl.col="black", tl.srt=45, addCoef.col="black", number.cex=0.7)画一个相关性的图。


# 加载必要的包
library(caret)
library(stats)
library(car)    # 用于vif()函数
library(corrplot) # 用于绘制相关性图

# 准备数据
data(state)
x <- as.data.frame(state.x77)

# 步骤7：计算并绘制相关性矩阵
cor_matrix <- cor(x, use="complete.obs")
corrplot(cor_matrix, method="circle", type="upper", tl.col="black", 
         tl.srt=45, addCoef.col="black", number.cex=0.7)

# 步骤1-2：创建全参数模型和空模型
full_model <- lm(Murder ~ ., data=x)
null_model <- lm(Murder ~ 1, data=x)

# 步骤3：使用step函数构建三个模型
# 向前选择
forward_model <- step(null_model, 
                     scope=formula(full_model), 
                     direction="forward", 
                     trace=0)

# 向后选择
backward_model <- step(full_model, 
                      scope=formula(full_model),
                      direction="backward", 
                      trace=0)

# 逐步选择
both_model <- step(null_model, 
                  scope=formula(full_model), 
                  direction="both", 
                  trace=0)

# 步骤4：评估三个模型
summary(forward_model)
summary(backward_model)
summary(both_model)

# 步骤6：检查多重共线性
vif_result <- vif(both_model)  # 使用最终选择的模型
print(vif_result)

# 步骤5：使用train函数最终完成训练，之前只是找最佳的线性回归参数。也就是公式
# 设置训练控制参数
ctrl <- trainControl(
  method = "cv",       # 交叉验证方法
  number = 5,         # 使用5折交叉验证
  search = "grid"
)

# 从step选择中获取公式（确保不包含x$引用）
# 假设both_model选择了Population、HS.Grad和Area作为预测变量
final_model <- train(
  Murder ~ Population + `HS Grad` + Area,  # 使用step选择出的变量，手动输入
  data = x,   # 数据
  method = "lm",        # 使用线性回归
  trControl = ctrl,     # 使用我们的交叉验证设置
  tuneLength = 100,
  preProcess = c("center", "scale")  # 中心化和标准化（本来标准化包括中心化，但是这里函数故意把两个功能分开！）
)

# 查看训练结果
print(final_model)
print(final_model$results)
print(final_model$resample)
summary(final_model$finalModel)