####卷积层
#1.一个卷积核提取一种数据特征，这个特征不是指数据的列名，而是内在的深层次特征。
#2.一个卷积核在提取时，参数是一样的。
#3.n个核，最终会形成n个特征图。不论哪一层都是如此。
#4.卷积核是独立于神经元的权重数据，神经元对应特征图的"像素"

####池化层
#1.就是负责压缩数据，有两种算法，一种是算区域内平均数，一种是区最大值。

####展品操作：就是把特征图按顺序，再按行、列的顺序拉成一维向量。

####全连接层：就是普通的神经网络，负责"计算"，类似于传统神经网络中的"隐藏层"。

####输出层：
#1.回归问题中输出层通常只有一个神经元
#2.分类问题：输出层有多个神经元，通常每个类别对应一个神经元，每个神经元权重不同，但是都会工作，然后输出的值汇总，再根据设定好的激活函数，转化成最终的类别


##################################################################
##################################################################

#####例子
# 安装和加载
install.packages("keras")
library(keras)

# 创建CNN模型
cnn_model <- keras_model_sequential() %>%
  # 添加第一个卷积层和池化层
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu", 
                input_shape = c(28, 28, 1)) %>%  # 只有第一层需要指定input_shape
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  
  # 添加第二个卷积层和池化层
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  
  # 展平层
  layer_flatten() %>%
  
  # 全连接层
  layer_dense(units = 128, activation = "relu") %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 10, activation = "softmax")

# 打印模型摘要
summary(cnn_model)

# 编译模型
cnn_model %>% compile(
  optimizer = optimizer_adam(learning_rate = 0.001),  # Adam优化器，设置学习率
  loss = "categorical_crossentropy",                  # 多分类问题的标准损失函数
  metrics = c("accuracy")                             # 评估指标：准确率
)

# 加载并准备MNIST数据集
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

# 数据预处理
# 1. 归一化像素值 (从0-255到0-1)
x_train <- x_train / 255
x_test <- x_test / 255

# 2. 调整维度以匹配模型输入 (添加通道维度)
x_train <- array_reshape(x_train, c(nrow(x_train), 28, 28, 1))
x_test <- array_reshape(x_test, c(nrow(x_test), 28, 28, 1))

# 3. 将标签转换为one-hot编码
y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)

# 创建验证集（从训练集中划分20%）
val_indices <- sample(1:nrow(x_train), size = floor(0.2 * nrow(x_train)))
x_val <- x_train[val_indices, , , ]
y_val <- y_train[val_indices, ]
x_train <- x_train[-val_indices, , , ]
y_train <- y_train[-val_indices, ]

# 设置回调函数
callbacks_list <- list(
  # 早停：如果验证集准确率连续3个epoch没有提升，则停止训练
  callback_early_stopping(
    monitor = "val_accuracy",
    patience = 3
  ),
  # 模型检查点：保存训练期间性能最佳的模型
  callback_model_checkpoint(
    filepath = "best_cnn_model.h5",
    monitor = "val_accuracy",
    save_best_only = TRUE
  )
)

# 训练模型
history <- cnn_model %>% fit(
  x = x_train,
  y = y_train,
  epochs = 15,                       # 训练轮数
  batch_size = 128,                  # 批量大小
  validation_data = list(x_val, y_val),  # 验证数据
  callbacks = callbacks_list         # 回调函数
)

# 绘制训练历史
plot(history)

# 加载训练期间保存的最佳模型
best_model <- load_model_hdf5("best_cnn_model.h5")

# 在测试集上评估最佳模型
test_results <- best_model %>% evaluate(x_test, y_test)
cat("测试集损失:", test_results[1], "\n")
cat("测试集准确率:", test_results[2], "\n")

# 使用模型进行预测
predictions <- best_model %>% predict(x_test)
predicted_classes <- max.col(predictions) - 1  # 获取概率最高的类别

# 可视化部分测试样本的预测结果
par(mfrow = c(5, 5), mar = c(0.5, 0.5, 1.5, 0.5))
for (i in 1:25) {
  sample_idx <- sample(1:nrow(x_test), 1)
  image(t(x_test[sample_idx,,1]), col = gray.colors(12), axes = FALSE)
  true_label <- which.max(y_test[sample_idx,]) - 1
  pred_label <- predicted_classes[sample_idx]
  title_color <- ifelse(true_label == pred_label, "darkgreen", "red")
  title(main = paste("真实:", true_label, "预测:", pred_label), 
        col.main = title_color, cex.main = 0.8)
}

# 保存最终模型（如果需要）
save_model_hdf5(cnn_model, "final_cnn_model.h5")                    





















#####常用层及默认参数（代码积木）
###全连接层 (Dense)
layer_dense(
  units,                  # 唯一必需参数：输出维度
  activation = NULL,      # 默认无激活函数
  use_bias = TRUE,        # 默认使用偏置
  kernel_initializer = "glorot_uniform", # 默认权重初始化方法
  bias_initializer = "zeros"             # 默认偏置初始化方法
)


###卷积层 (Conv2D)
layer_conv_2d(
  filters,                # 必需：卷积核数量
  kernel_size,            # 必需：卷积核大小，如c(3, 3)
  strides = c(1, 1),      # 默认步长1x1
  padding = "valid",      # 默认不填充
  activation = NULL,      # 默认无激活函数
  use_bias = TRUE         # 默认使用偏置
)


###池化层
layer_max_pooling_2d(
  pool_size = c(2, 2),    # 默认池化窗口2x2
  strides = NULL,         # 默认等于pool_size
  padding = "valid"       # 默认不填充
)

### 展平层
layer_flatten() 





###Dropout（设置一定比例神经元输出为0，防止过拟合）
layer_dropout(
  rate                    # 唯一必需参数：丢弃率(0-1)
)


#####模型编译
model %>% compile(
  optimizer = "rmsprop",  # 默认优化器
  loss = NULL,            # 必需参数：损失函数
  metrics = NULL          # 默认不计算指标
)

# 常用简化写法
model %>% compile(
  optimizer = "adam",
  loss = "categorical_crossentropy",
  metrics = "accuracy"
)



#####模型训练
history <- model %>% fit(
  x,                      # 训练数据
  y,                      # 标签
  batch_size = 32,        # 默认批次大小
  epochs = 10,            # 默认训练轮数
  verbose = 1,            # 默认显示进度条
  validation_split = 0.0  # 默认不使用验证集
)



#####模型评估与预测
# 评估模型
scores <- model %>% evaluate(x_test, y_test)

# 预测
predictions <- model %>% predict(x_test)




#####保存与加载模型
# 保存模型
save_model_hdf5(model, "my_model.h5")

# 加载模型
model <- load_model_hdf5("my_model.h5")