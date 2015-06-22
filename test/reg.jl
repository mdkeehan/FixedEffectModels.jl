using FixedEffectModels, RDatasets, DataFrames
using Base.Test
# values checked from reghdfe
df = dataset("plm", "Cigar")
df[:pState] = PooledDataArray(df[:State])
df[:pYear] = PooledDataArray(df[:Year])


# coefs
@test_approx_eq coef(reg(Sales~NDI, df)) [132.9807886574938,-0.0011999855769369572]
@test_approx_eq coef(reg(Sales~NDI | pState, df))  [-0.0017046786439408952]
@test_approx_eq coef(reg(Sales~NDI | (pState + pYear), df))  [-0.0068438454129809674]
@test_approx_eq coef(reg(Sales~NDI | (pState + pState&Year), df))  [-0.005686067588968156]
@test_approx_eq  coef(reg(Sales~NDI | (pState&Year), df)) -0.007652680961637854
@test_approx_eq  coef(reg(Sales~NDI | (Year&pState), df)) -0.007652680961637854

# coefs weights
@test_approx_eq coef(reg(Sales~NDI, df, weight = :Pop)) [133.9975889363506,-0.0016479139243510202]
@test_approx_eq coef(reg(Sales~NDI | pState, df, weight = :Pop)) [-0.0016956069964287905]
@test_approx_eq coef(reg(Sales~NDI | (pState + pYear), df,  weight = :Pop)) [-0.00526264064237539]
@test_approx_eq coef(reg(Sales~NDI | (pState + pState&Year), df, weight = :Pop)) [-0.0046368444054828975]
