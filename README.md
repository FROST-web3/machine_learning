# R Machine Learning Basic Model Templates

This repository contains a collection of basic templates for various machine learning models implemented in R. These templates provide complete workflows from data preprocessing and feature selection to model training and evaluation, suitable for both beginners and professionals in the field of machine learning.

## Contents

### 1. Linear Regression Model (003_linear_regression_model.R)
- Uses the `state.x77` dataset to predict murder rates
- Includes comparison of variable selection methods (forward/backward/both)
- Correlation analysis and multicollinearity checks
- Cross-validation model evaluation

### 2. Market Basket Analysis (004_market_basket_analysis.R)
- Utilizes `arules` and `arulesViz` packages for association rule mining
- Includes calculation of key metrics: support, confidence, and lift
- Multiple visualization methods for association rules
- Rule filtering and sorting techniques

### 3. Breast Cancer Prediction (005_breast_cancer_prediction.R)
- Feature selection using Boruta algorithm
- Comparison between Random Forest and XGBoost models
- Cross-validation performance evaluation
- Model validation using confusion matrix

### 4. Support Vector Machine (006_support_vector_machine.R)
- SVM model suitable for high-dimensional, low-sample data
- Kernel function selection (Radial basis function)
- Feature selection and data preprocessing
- Hyperparameter optimization and cross-validation

### 5. Neural Network (007_neural_network.R)
- Basic neural network implementation
- Suitable for both classification and regression problems
- Feature selection and data standardization
- Model evaluation and tuning

### 6. Convolutional Neural Network (008_convolutional_neural_network.R)
- CNN implementation using Keras in R
- Detailed CNN architecture design (convolutional layers, pooling layers, fully connected layers)
- Image classification case study using MNIST dataset
- Model saving, loading, and evaluation

## Technical Highlights

- **Feature Selection**: Primarily using Boruta algorithm
- **Model Validation**: K-fold cross-validation
- **Model Evaluation**: Multiple metrics including accuracy and confusion matrix
- **Hyperparameter Optimization**: Grid search and automatic parameter tuning
- **Preprocessing**: Standardization, centering, and other data preprocessing methods

## Usage Instructions

1. Clone the repository
```
git clone https://github.com/FROST-web3/machine_learning.git
```

2. Ensure necessary R packages are installed
```R
# Install basic packages
install.packages(c("caret", "e1071", "Boruta", "kernlab", "corrplot", "arules", "arulesViz"))

# Neural network related packages
install.packages(c("nnet", "keras"))
```

3. Modify and run scripts as needed

## Important Notes

- Some scripts require specific datasets; please prepare or modify data sources according to comments
- CNN model requires TensorFlow and Keras environments
- Model training may take a considerable amount of time, especially when performing cross-validation on large datasets

## Contributions

Improvements and code contributions are welcome through Issues or Pull Requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
