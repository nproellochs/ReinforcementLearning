library(ReinforcementLearning)
context("sampleExperience")

test_that("Training examples are sampled correctly", {
  set.seed(0)
  env <- gridworldEnvironment

  states <- c("s1", "s2", "s3", "s4")
  actions <- c("up", "down", "left", "right")

  data <-
    sampleExperience(
      N = 2,
      env = env,
      states = states,
      actions = actions
    )

  expect_equal(is.data.frame(data), TRUE)
  expect_equal(colnames(data), c("State", "Action", "Reward", "NextState"))
  expect_equal(data$State, c("s4", "s2"))
  expect_equal(data$Action, c("left", "right"))
  expect_equal(data$Reward, c(-1, -1))
  expect_equal(data$NextState, c("s4", "s3"))

  expect_error(sampleExperience(N = -1, env = env, states = states, actions = actions))
  expect_error(sampleExperience(N = 2.4, env = env, states = states, actions = actions))
  expect_error(sampleExperience(N = 2, env = "env", states = states, actions = actions))
  expect_error(sampleExperience(N = 2, env = env))
  expect_error(sampleExperience(N = 2, env = env, states = 1, actions = actions))
})

test_that("Epsilon-greedy action selection works correctly", {
  set.seed(0)
  env <- gridworldEnvironment

  states <- c("s1", "s2", "s3", "s4")
  actions <- c("up", "down", "left", "right")

  data <-
    sampleExperience(
      N = 1000,
      env = env,
      states = states,
      actions = actions
    )

  control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)
  model <- ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
                                 s_new = "NextState", control = control)

  set.seed(0)
  data_new <- sampleExperience(N = 10, env = env, states = states, actions = actions,
                               model = model, actionSelection = "epsilon-greedy",
                               control = control)

  expect_equal(is.data.frame(data), TRUE)
  expect_equal(colnames(data_new), c("State", "Action", "Reward", "NextState"))
  expect_equal(head(data_new$State, 2), c("s4", "s2"))
  expect_equal(head(data_new$Action, 2), c("down", "right"))
  expect_equal(head(data_new$Reward, 2), c(-1, -1))
  expect_equal(head(data_new$NextState, 2), c("s4", "s3"))

  expect_error(sampleExperience(N = -2, env = env, states = states, actions = actions, model = model,
                                actionSelection = "epsilon-greedy", control = control))
  expect_error(sampleExperience(N = 5, env = NULL, states = states, actions = actions, model = model,
                                actionSelection = "epsilon-greedy", control = control))
})
