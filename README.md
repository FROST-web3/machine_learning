# R语言机器学习基础模型模板集合

这个仓库包含了使用R语言实现的各种机器学习模型的基础模板。这些模板提供了从数据预处理、特征选择到模型训练和评估的完整流程，适合机器学习初学者和专业人士参考使用。

## 模板内容

### 1. 线性回归模型 (003_linear_regression_model.R)
- 使用`state.x77`数据集预测谋杀率
- 包含变量选择(forward/backward/both)方法比较
- 相关性分析与多重共线性检查
- 交叉验证模型评估

### 2. 购物篮分析 (004_market_basket_analysis.R)
- 使用`arules`和`arulesViz`包进行关联规则挖掘
- 包含支持度、置信度和提升度等关键指标计算
- 多种可视化方法展示关联规则
- 规则筛选与排序方法

### 3. 乳腺癌预测 (005_breast_cancer_prediction.R)
- 基于Boruta算法的特征选择
- 随机森林与XGBoost模型对比
- 交叉验证性能评估
- 混淆矩阵模型验证

### 4. 支持向量机 (006_support_vector_machine.R)
- 适用于高维低样本量数据的SVM模型
- 核函数选择(Radial基函数)
- 特征选择与数据预处理
- 超参数优化与交叉验证

### 5. 神经网络 (007_neural_network.R)
- 基础神经网络实现
- 适用于分类与回归问题
- 特征选择与数据标准化
- 模型评估与调优

### 6. 卷积神经网络 (008_convolutional_neural_network.R)
- 使用Keras在R中实现CNN
- 详细的CNN架构设计(卷积层、池化层、全连接层)
- MNIST数据集图像分类案例
- 包含模型保存、加载与评估

## 技术要点

- **特征选择**：主要使用Boruta算法
- **模型验证**：采用K折交叉验证
- **模型评估**：准确率、混淆矩阵等多种指标
- **超参数优化**：网格搜索与自动参数调优
- **预处理**：标准化、中心化等数据预处理方法

## 使用方法

1. 克隆仓库到本地
```
git clone https://github.com/FROST-web3/machine_learning.git
```

2. 确保安装了必要的R包
```R
# 安装基础包
install.packages(c("caret", "e1071", "Boruta", "kernlab", "corrplot", "arules", "arulesViz"))

# 神经网络相关包
install.packages(c("nnet", "keras"))
```

3. 根据需要修改和运行相应的脚本

## 注意事项

- 部分脚本需要特定数据集，请提前准备或根据注释修改数据源
- CNN模型需要先安装TensorFlow及Keras环境
- 模型训练可能需要较长时间，特别是对大数据集进行交叉验证时

## 贡献

欢迎通过Issue或Pull Request提出改进建议或贡献代码。

## 许可证

本项目采用MIT许可证 - 详情请参见[LICENSE](LICENSE)文件。
