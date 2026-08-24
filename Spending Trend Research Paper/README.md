# US GDP and Personal Consumption Expenditure analysis

## Overview

This project examines the relationship between **Growth Domestic Product (GDP)** and **Personal Consumption Expenditure (PCE)** in the United States. GDP measures the market value of goods and products within an economy and PCE measures household spending on goods and products. 

The goal of this analysis is to determine if GDP can help explain changes in spending within the US and evaluate which regression model has the best representation of this relationship. 

## Research Questions

**How does GDP affect personal consumption expenditure in the US?**

## Data

The data was obtained by the U.S. Bureau of Economic Analysis, which contains annual U.S. economic data for GDP and PCE. 

For this analysis, the data was filtered down to include observations between the years **1970-2025**. The final variables used were:
- **GDP** - Gross domestic product, measured in billions of dollars
- **PCE** - Personal consumption expenditure, measured in billions of dollars

The original BEA dataset contains numerous economic indicators. The data was cleaned and reformatted in Excel to retain only the variables needed for the regression analysis.


## Methods

### Model A: Simple Linear Regression

The first model uses GDP as the independent variable and PCE as the dependent variable.

The estimated regression equation was:

**PCE = -150.50 + 0.68(GDP)**

The coefficient for GDP indicates that a one-unit increase in GDP is associated with approximately a **0.68-unit increase in PCE**, holding the model structure constant.

Model A produced:

- **R² = 0.9997**
- **Adjusted R² = 0.9996**
- **GDP t-statistic = 294.77**
- **GDP p-value < 0.05**

These results indicate a very strong statistical relationship between GDP and PCE.

### Model B: Log-Log Regression

A second model was estimated using the natural logarithm of both GDP and PCE:

**ln(PCE) = -0.79 + 1.04 ln(GDP)**

The log-log specification allows the relationship to be interpreted in terms of **percentage changes (elasticity)** rather than changes in dollar amounts.

The GDP coefficient of approximately **1.04** indicates that a **1% increase in GDP is associated with approximately a 1.04% increase in PCE**.

Model B produced:

- **R² = 0.9998**
- **Adjusted R² = 0.9998**

The log-log model had a slightly higher R² than the linear model and provides a more interpretable measure of the relationship between GDP and household spending.

## Correlation

A correlation analysis was conducted to measure the strength and direction of the relationship between GDP and PCE. The Pearson correlation coefficient was approximately **0.9999**, indicating an extremely strong positive linear relationship between the two variables.

This means that higher levels of GDP are strongly associated with higher levels of personal consumption expenditures. The correlation is consistent with the regression results, which also found a highly significant positive relationship between GDP and PCE.

However, correlation does not establish causation. While GDP and PCE move very closely together, other economic factors may also influence household spending.

## Results

Both models found a strong positive relationship between GDP and PCE.
The extremely high R² values indicate that GDP explains a very large proportion of the variation in PCE within this dataset.
The regression results also show that GDP is statistically significant in both models.

## Conclusion

The analysis demonstrates a strong positive relationship between U.S. GDP and personal consumption expenditures. As GDP increases, household spending also tends to increase. 

The **log-log model** provides an especially useful interpretation because it expresses the relationship in percentage terms. Its coefficient suggests that PCE increases slightly more than proportionally with GDP.

However, the results should be interpreted as an **association rather than proof of causation**. GDP and PCE are both aggregate economic measures that can be influenced by many other economic factors.

## Tools & Skills

- **R / RStudio**
- **Excel**
- **Ordinary Least Squares (OLS) Regression**
- **Simple Linear Regression**
- **Log-Log Regression**
- **Hypothesis Testing**
- **t-tests**
- **R-squared & Adjusted R-squared**
- **Economic Data Analysis**
- **Data Cleaning & Preparation**
- **Regression Model Comparison**





