library(ReinforcementLearning)
context("learningRule")

test_that("LearningRule is returning the correct function", {
  l <- lookupLearningRule("experienceReplay")
  expect_equal(l, replayExperience)

  expect_error(lookupLearningRule("1"))
  expect_error(lookupLearningRule(NULL))
})
