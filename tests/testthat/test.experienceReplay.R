library(ReinforcementLearning)
context("experienceReplay")

test_that("Experience replay performs correctly", {
  suppressWarnings(RNGversion("3.5.0"))
  set.seed(0)
  data <- sampleGridSequence(50)

  d <- data.frame(
    s = data[, "State"],
    a = data[, "Action"],
    r = data[, "Reward"],
    s_new = data[, "NextState"],
    stringsAsFactors = F
  )

  Q <- hash()
  for (i in unique(d$s)[!unique(d$s) %in% names(Q)]) {
    Q[[i]] <- hash(unique(d$a), rep(0, length(unique(d$a))))
  }

  control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)
  res <- experienceReplay(d, Q, control)

  expect_equal(is.list(res), TRUE)
  expect_equal(is.hash(res$Q), TRUE)
  expect_equal(is.hash(res$Q$s1), TRUE)

  expect_error(experienceReplay(d, Q))
  expect_error(experienceReplay(d, Q = "Q", control))
  expect_error(experienceReplay("s1", Q, control))
})
