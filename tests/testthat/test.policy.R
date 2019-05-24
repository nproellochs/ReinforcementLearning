library(ReinforcementLearning)
context("computePolicy")

test_that("policy is evaluated correctly", {
  dummyPolicy <- computePolicy(data.frame("A" = c(1:3), "B" = c(5,2,1), "C" = c(2,1,2)))
  expect_equal(dummyPolicy, c("B", "A", "A"))

  dummyPolicy <- computePolicy(data.frame("A" = c(1), "B" = c(4), "C" = c(2)))
  expect_equal(dummyPolicy, c("B"))

  dummyPolicy <- computePolicy(data.frame())
  expect_equal(dummyPolicy, NULL)

  expect_error(computePolicy(1))
})
