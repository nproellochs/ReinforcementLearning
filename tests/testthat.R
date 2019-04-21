if(!require(testthat)) stop("testthat required for tests")
library(ReinforcementLearning)

suppressWarnings(RNGversion("3.5.0"))
test_check("ReinforcementLearning")
RNGversion(as.character(getRversion()))
