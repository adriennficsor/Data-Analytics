# Overview
This project involves creating a logistic regression model to predict whether a patient has a 10-year risk of future coronary heart disease (CHD). The dataset used is from an ongoing cardiovascular study on residents of Framingham, Massachusetts, containing over 4,000 records with 15 attributes related to patient information.

The analysis was carried out using Excel for the logistic regression model, with additional correlation analysis and visualization performed using GRETL to assess the relationships between variables and interpret the results.

# Tasks and Solutions
## Data Preprocessing

Data Overview: The dataset is provided in the Heart_desease sheet, with additional attribute descriptions in the Heart_desease_desc sheet.
Cleaned and prepared the data, ensuring that all variables were correctly formatted and missing values were handled appropriately for the logistic regression model.
## Logistic Regression Model

Excel Logistic Regression: Used Excel’s built-in functions and the Solver tool to create a logistic regression model for predicting the likelihood of CHD over a 10-year period.
Dependent Variable: The target variable is binary, indicating whether the patient has a 10-year risk of CHD (1 = Risk, 0 = No Risk).
Independent Variables: The 15 attributes provided in the dataset were used as predictors, such as age, sex, cholesterol levels, smoking status, and other health-related factors.
## Model Estimation and Predictions

The logistic regression model was run using the Solver tool in Excel to estimate the coefficients and make predictions.
Predictions were then calculated for each patient based on the logistic regression equation.
## Interpretation of Coefficients and Odds Ratios

Coefficients: Interpreted the estimated coefficients from the logistic regression output, identifying which variables have the strongest effect on the likelihood of developing CHD.
Odds Ratios: Calculated the odds ratios for each predictor variable, providing insights into the relative odds of CHD risk for different levels of each attribute.
Model Evaluation and Performance Metrics

Confusion Matrix: Created a confusion matrix to assess the model's classification performance (True Positives, True Negatives, False Positives, and False Negatives).
Accuracy, Precision, Recall, and F1-Score: Calculated key performance metrics such as accuracy, precision, recall, and F1-score to evaluate the model’s predictive performance.
AUC-ROC Curve: Used the Area Under the Receiver Operating Characteristic Curve (AUC-ROC) to evaluate the model’s discrimination ability.
# Correlation Analysis and Visualization

GRETL: Used GRETL to perform correlation analysis between the predictors and the target variable (CHD risk). Visualized the correlation results to better understand the relationships between different factors.
The visualizations helped identify key factors that are most strongly correlated with the likelihood of CHD.
Key Insights

Significant Predictors: Age, cholesterol levels, and smoking status emerged as the most significant predictors of future CHD risk.
Odds Ratios: Odds ratios helped quantify the effect of each predictor, showing how changes in a variable (e.g., age or cholesterol) affect the odds of having a 10-year CHD risk.
The model achieved good classification performance, as reflected in the evaluation metrics.
# Tools and Techniques
Excel: Used for creating the logistic regression model, estimating predictions, and calculating performance metrics.
GRETL: Used for correlation analysis and visualizing relationships between the variables to better understand the data.
Solver in Excel: Leveraged Excel’s Solver tool to optimize the logistic regression model’s coefficients.
# Outcome
The logistic regression model was successfully built to predict the 10-year risk of coronary heart disease. The model’s predictions were based on key health indicators such as age, cholesterol, and smoking status. The evaluation metrics showed that the model performed well, providing accurate predictions with a good balance between sensitivity and specificity.

The correlation analysis and visualizations provided valuable insights into which variables were most influential in predicting CHD risk, and the odds ratios further quantified the impact of each variable. The project demonstrated how statistical techniques can be applied to real-world healthcare data to improve risk prediction and decision-making.
