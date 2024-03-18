*** ============= SETUP ============= ***

clear all
cd "\\Client\C$\Users\taaha\OneDrive\Desktop\UTM\4th Year\Winter Semester\ECO475\Paper"
set more off 
log using paper.log, replace



*** ============= DATA SETUP ============= ***
import excel "Data.xlsx", sheet("Sheet1") firstrow

// List all the variables in the dataset.
describe

// Create a table of summary statistics
summarize

// Set time variable
gen time = date(Date,"YMD")
format time %td
gen time_monthly = mofd(time)
format time_monthly %tm 
tsset time_monthly
gen year = year(time)

// Test for autocorrelation.
// If there is autocorrelation, we cannot use OLS.
// The results show that there is autocorrelation in all variables except FDI.
ac IndustrialProd, name(acf_IP, replace) 
ac EPU, name(acf_EPU, replace)
ac FDI, name(acf_FDI, replace)
ac Interest, name(acf_INT, replace)
ac Import, name(acf_IMP, replace)
ac Exports, name(acf_EXP, replace)
ac Inflation, name(acf_INF, replace)
ac KSEPrice, name(acf_KSE, replace)
ac PKRUSD, name(acf_PKR, replace)
ac ConsumerConfidence, name(acf_CC, replace)

graph combine acf_IP acf_EPU acf_FDI acf_INT acf_IMP acf_EXP acf_INF acf_KSE acf_PKR acf_CC, ycommon


// Check whether each series is stationary
dfuller EPU
dfuller FDI
dfuller Interest // This variable is not stationary, might need to apply differencing.
dfuller Imports // This variable is not stationary, might need to apply differencing.
dfuller Exports // This variable is not stationary, might need to apply differencing.
dfuller ConsumerConfidence // This variable is not stationary, might need to apply differencing.
dfuller IndustrialProd
dfuller PKRUSD // This variable is not stationary, might need to apply differencing.
dfuller KSEPrice // This variable is not stationary, might need to apply differencing.
dfuller Inflation // This variable is not stationary, might need to apply differencing.

// Apply Differencing
gen InterestDiff = D.Interest
gen ImportsDiff = D.Imports
gen ExportsDiff = D.Exports
gen ConsumerConfidenceDiff = D.ConsumerConfidence
gen PKRUSDDiff = D.PKRUSD
gen KSEPriceDiff = D.KSEPrice
gen InflationDiff = D.Inflation


// Check whether the differenced series is now stationary.
dfuller InterestDiff
dfuller ImportsDiff
dfuller ExportsDiff
dfuller ConsumerConfidenceDiff
dfuller PKRUSDDiff
dfuller KSEPriceDiff
dfuller InflationDiff


// Create an display a decomposition plot of the time series variables.
// With this, we can inspect for any trending variables.
// Graph a time series chart for all variables to inspect for time trends.
tsline EPU, name(tsEPU, replace)

tsline FDI, name(tsFDI, replace)

tsline InterestDiff, name(tsINT, replace)

tsline ImportsDiff, name(tsIMP, replace)

tsline ExportsDiff, name(tsEXP, replace)

tsline ConsumerConfidenceDiff, name(tsCC, replace)

tsline IndustrialProd, name(tsINDP, replace)

tsline PKRUSDDiff, name(tsEXC, replace)

tsline KSEPriceDiff, name(tsKSE, replace)

tsline InflationDiff, name(tsINF, replace)

graph combine tsEPU tsINT tsIMP tsEXP tsCC tsINDP tsEXC tsKSE tsINF


// There seems to be no trending variables.




*** ============= VARIABLE SELECTION ============= ***

// Test for causality to check which variables to include
// Granger Causality test passes for lag 1-3
var InflationDiff EPU, lags(1)
vargranger

// Granger Causality test fails.
var InflationDiff FDI, lags(1)
vargranger

// Granger causality test passes for lags 1-3
var InflationDiff InterestDiff, lags(1)
vargranger

// Granger Causality test passes for lag = 2
var InflationDiff ImportsDiff, lags(1)
vargranger

// Granger Causality test passes for lags 2-4
var InflationDiff ExportsDiff, lags(2)
vargranger

// Granger Causality test fails.
var InflationDiff ConsumerConfidenceDiff, lags(1)
vargranger

// Granger causality test passes lags 1-3.
var InflationDiff PKRUSDDiff, lags(1)
vargranger

// Granger causality test fails.
var InflationDiff KSEPriceDiff, lags(1)
vargranger

// Granger Causality test fails.
var InflationDiff IndustrialProd, lags(1)
vargranger


// Create a loop to find the optimal number of lags for each variable.
// Pick lags by minimizing AIC.
// Choose optimal number of lags
// Set maximum number of lags to consider
local max_lags = 4

foreach var of varlist EPU InterestDiff ImportsDiff ExportsDiff PKRUSDDiff {
    varsoc InflationDiff L.`var', maxlag(`max_lags')
    di "Optimal number of lags for `var': " r(max)
}


// _Imonth_2-_Imonth_12
// Regress using the optimal lags obtained by minimizing AIC for the relevant variables.
// Test for multicollinearity.
reg InflationDiff EPU L.EPU L2.EPU L3.EPU InterestDiff L.InterestDiff L2.InterestDiff L3.InterestDiff L4.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L3.ImportsDiff ExportsDiff L.ExportsDiff L2.ExportsDiff PKRUSDDiff
estat vif
// There appears to be no multicollinearity.

// Now test for heteroskedasticity.
reg InflationDiff EPU L.EPU L2.EPU L3.EPU InterestDiff L.InterestDiff L2.InterestDiff L3.InterestDiff L4.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L3.ImportsDiff ExportsDiff L.ExportsDiff L2.ExportsDiff PKRUSDDiff
estat hettest
// There seems to be heteroskedasticity use newey HAC standard errors.

newey InflationDiff EPU L.EPU L2.EPU L3.EPU InterestDiff L.InterestDiff L2.InterestDiff L3.InterestDiff L4.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L3.ImportsDiff ExportsDiff L.ExportsDiff L2.ExportsDiff PKRUSDDiff, lag(4)


// Get rid of irrelevant variables according to regression result and economic theory.
// Test for heteroskedasticity.
reg InflationDiff EPU L.EPU L3.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L2.PKRUSDDiff
estat hettest

// We have heteroskedasticity, so we will use HAC standard errors.
newey InflationDiff EPU L.EPU L3.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L2.PKRUSDDiff, lag(3)



*** ============= FINAL MODEL ============= ***

// Test for seasonality
gen month = month(time)
drop if year(time) < 2011
xi i.month

reg InflationDiff EPU L.EPU L3.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L2.PKRUSDDiff _Imonth_2-_Imonth_12

// Through this, we can see that there is no evidence of seasonality.
test _Imonth_2 _Imonth_3 _Imonth_4 _Imonth_5 _Imonth_6 _Imonth_7 _Imonth_8 _Imonth_9 _Imonth_10 _Imonth_11 _Imonth_12


// Our final model is then:
newey InflationDiff EPU L.EPU L3.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L2.PKRUSDDiff, lag(3)


// Let us test that the errors are normally distributed:
reg InflationDiff EPU L.EPU L3.InterestDiff ImportsDiff L.ImportsDiff L2.ImportsDiff L2.PKRUSDDiff
predict residuals, residual
swilk residuals



*** ============= DATA STATISTICS ============= ***
summarize EPU
summarize Inflation
summarize InflationDiff

summarize Interest Imports PKRUSD
summarize InterestDiff ImportsDiff PKRUSDDiff

log close


