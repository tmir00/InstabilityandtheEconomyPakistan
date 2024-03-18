# Instability and the Economy - A Case Study: Pakistan

## Abstract:
This study delves into the tangible connection between political and economic instability and its consequences on Pakistan's economy, focusing particularly on inflation and public welfare. The removal of Prime Minister Imran Khan in April 2022 illustrates the ongoing political volatility that has plagued Pakistan, a country where every prime minister has faced an abrupt end to their term due to a myriad of disruptions, such as military coups, assassinations, and resignations. Utilizing time series data from 2012 to 2022 and employing a Lagged Multiple Regression model with a focus on inflation, this research examines how instability, measured by the Economic Policy Uncertainty (EPU) Index, impacts the nation's economic health. The results show that past instability significantly affects inflation rates, supporting the idea that instability has a detrimental, though somewhat limited, impact on the economy. The study uncovers the intricate ways in which instability influences economic growth, investment, fiscal management, and human capital development, indicating that the effects of instability on inflation are noticeable but not the sole factors at play. By contributing to the ongoing discussion on how political instability affects economic outcomes, especially in developing countries, this research provides valuable insights into how instability shapes economic indicators and aids in making well-informed policy decisions.

<br>

## Data Analysis Process

The analysis is conducted using a dataset that captures various economic indicators of Pakistan from 2010 to 2012. The data includes variables such as Economic Policy Uncertainty Index (EPU), Foreign Direct Investment (FDI), Interest Rates, Import and Export volumes, Inflation, Industrial Production, Karachi Stock Exchange (KSE) prices, PKR to USD exchange rates, and Consumer Confidence levels.

Here is how our measure of Economic Policy Uncertainty varies with time:

![EPU](https://github.com/tmir00/Instability-and-the-Economy-A-Case-Study-Pakistan/assets/77368499/607fcc56-e3a0-477d-abb1-90da950c4a9b)

### Stata Script Overview

The provided Stata script `Paper.do` performs a series of data manipulation and econometric analysis steps:

- **Data Importing**: The script starts by importing the `Data.xlsx` file and preparing it for analysis by formatting dates and creating necessary time variables.

- **Descriptive Analysis**: It provides a summary of the data to understand the distribution of each variable.

- **Time Series Processing**: The script sets the time variable for the dataset and checks each series for stationarity, applying differencing where necessary to ensure stationary time series.

- **Autocorrelation Checks**: Autocorrelation is assessed to ensure that the Ordinary Least Squares (OLS) assumptions are not violated.

- **Variable Selection**: Through Granger Causality tests and Akaike Information Criterion (AIC), the script selects variables that are significant predictors of inflation and determines the optimal number of lags for each.

- **Model Estimation**: The script employs a Newey-West regression model to account for autocorrelation and heteroskedasticity in the data.

- **Seasonality and Normality Checks**: Tests for seasonality in the data are conducted using dummy variables for months, and the Shapiro-Wilk test is performed to ensure the residuals are normally distributed.

- **Final Model Estimation**: The script refines the regression model to include only significant variables and estimates the final model.

- **Data Statistics**: Summaries of key variables are provided, including EPU, Inflation, and differenced series of Interest, Imports, and PKRUSD exchange rates.

The script concludes by closing the log file and saving all changes and results.


### Running the Script

To run the script, ensure that you have Stata installed on your system and the `Data.xlsx` file is located in the same directory as the `Paper.do` script. Open Stata, navigate to the appropriate directory, and execute the script by typing `do Paper.do` in the command window.

The analysis will offer insights into how various economic indicators, particularly inflation, are influenced by political and economic instability as represented by the EPU Index in Pakistan.
