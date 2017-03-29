library(ReinforcementLearning)
context("state")

test_that("state is generated correctly", {
  dummyState <- state("s2")
  expect_equal(dummyState, "s2")

  dummyState <- state(2)
  expect_equal(dummyState, "2")

  dummyState <- state(data.frame("A" = c(1:3), "B" = c(5,2,1), "C" = c(2,1,2)))
  expect_equal(dummyState, "1:3, c(5, 2, 1), c(2, 1, 2)")
})
