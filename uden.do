**cleaning the data**

drop if CHE==.
gen LOGCHE= log(CHE)
gen LOGGDP= log(GDP)

*creating ID code**

egen id = group(Country)


*creating panel data:
xtset id year




*simple pooled ols ignoring the heteroskedasy F statisitk shows 17,63 and the probablity value is less than 5 % tells us that our model is fit for analyse. R-square is  0.0065 meaning that our independent variabel are explaining 0,65 % variance in out dependent variable, which is very low. All coefficient are all positiv relate with gdp_growth but with  gpi and loggdp_prcap being insignificant.
regress LOGGDP LOGCHE, robust cluster(id)
eststo model, title ("OLS")
predict resid, residuals
*normalty test Jarque-Bera normality test:  Chi(2) is below 0.05 which means that our data is not normal distibuted and we can reject our null-hypotese:
jb resid
*multicornarrity, if the vif value is less than 10 then we do not have multicornarrity in our data:
vif
*heter Is below 0,05 so there is heterkestdasy in our data.
imtest, white
estat hettest



xtreg  LOGGDP LOGCHE i.Year, fe robust cluster(id)
eststo model, title ("OLS")



xtreg  LOGGDP LOGCHE i.Year i.id, re robust cluster(id)





*if the value is more than 5 %, then the fixed model is better, so we can not reject the null-hypotese. so we can use fixed effect model for our analysis.
hausman Fe_GDP Re_GDP
eststo model7, title ("FE VS RE for model 1")
* is below or fail to fails to meet the asymptotic assumptions of the Hausman test
hausman Fe_Fertil Re_Fertil
eststo model8, title ("FE VS RE for model 2")
esttab, mtitles p scalars(r2)

*Breusch-pagan LM-test Random vs ols model:
* the result is not signifikant since p value is not below 0.05 and we should therefor use the ols model when comparing to Random effekt.
quietly xtreg gdp_growth gpi loggdp_prcap logpop i.year i.id, re robust
xttest0
* the result is signifikant p value is below 0.05 and we should therefor not use the ols model.
quietly xtreg fertility gpi  i.year i.id,re robust
xttest0
