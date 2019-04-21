library(ReinforcementLearning)
context("ReinforcementLearning")

test_that("Reinforcement learning performs correctly", {
  set.seed(0)
  data <- sampleGridSequence(1000)
  control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)
  model <- ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                 s_new = "NextState", control = control)

  expect_equal(predict(model), c("s1" = "down", "s2" = "right", "s3" = "up", "s4" = "right"))
  expect_equal(model$Reward, -263)

  expect_error(ReinforcementLearning("data", s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", control = control))
  expect_error(ReinforcementLearning(data, control = control))
  expect_error(ReinforcementLearning(data, s = "State", a = "Action", r = 4,
                                     s_new = "NextState", control = control))
  expect_error(ReinforcementLearning(data, s = "s", a = "Action", r = "Reward",
                                     s_new = "NextState", control = control))
  expect_error(ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", control = NULL))
  expect_error(ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", control = list(alpha = 2, gamma = 0.1, epsilon = 0.1)))
  expect_error(ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", control = list(alpha = 0.1)))
  expect_error(ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", iter = 2.4))
  expect_error(ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", iter = -1))

  data_na <- data
  data_na$Reward[1] <- NA
  expect_error(ReinforcementLearning(data_na, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", control = control))
})

test_that("Policy updating performs correctly", {
  set.seed(0)
  data <- sampleGridSequence(1000)
  control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)
  model <- ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                 s_new = "NextState", control = control)

  expect_equal(predict(model), c("s1" = "down", "s2" = "right", "s3" = "up", "s4" = "right"))
  expect_equal(model$Reward, -263)

  set.seed(0)
  data_new <- sampleGridSequence(N = 500, actionSelection = "epsilon-greedy", control = control, model = model)
  model_new <- ReinforcementLearning(data_new, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", control = control, model = model)

  expect_equal(model_new$Reward, 633)

  expect_error(ReinforcementLearning(data_new, s = "State", a = "Action", r = "Reward",
                                     s_new = "NextState", control = control, model = "model"))
})
