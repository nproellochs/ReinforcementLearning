library(ReinforcementLearning)
context("actionSelection")

test_that("ActionSelection function is choosing the right return value correctly", {
  l <- lookupActionSelection("epsilon-greedy")
  expect_equal(l, selectEpsilonGreedyAction)

  l <- lookupActionSelection("random")
  expect_equal(l, selectRandomAction)

  expect_error(lookupActionSelection("1"))
  expect_error(lookupActionSelection(NULL))
})

test_that("Epsilon-greedy action selection is performed correctly", {
  qht <- hash(letters[1:5], sapply(1:5, function(x) hash(c("AA", "BB", "CC", "DD"), 1:4 )))
  l <- lookupActionSelection("epsilon-greedy")

  expect_equal(l(qht, "a", 0.0), "DD")
  expect_is(l(qht, "a", 0.0), "character")

  expect_error(l(qht, "xx", 0.0))
  expect_error(l(NULL))
})

test_that("Random action selection is performed correctly", {
  qht <- hash(letters[1:5], sapply(1:5, function(x) hash(c("AA", "BB", "CC", "DD"), 1:4 )))
  l <- lookupActionSelection("random")

  expect_is(l(qht, "a"), "character")

  expect_error(l(qht, "xx"))
  expect_error(l(NULL))
})
