library(ReinforcementLearning)
context("Policy")

test_that("policy is evaluated correctly", {
  dummyPolicy <- policy(data.frame("A" = c(1:3), "B" = c(5,2,1), "C" = c(2,1,2)))
  expect_equal(dummyPolicy, c("B", "A", "A"))

  dummyPolicy <- policy(data.frame("A" = c(1), "B" = c(4), "C" = c(2)))
  expect_equal(dummyPolicy, c("B"))

  dummyPolicy <- policy(data.frame())
  expect_equal(dummyPolicy, NULL)

  expect_error(policy(1))
})
