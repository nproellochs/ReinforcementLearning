#' Defines an environment for a gridworld example
#'
#' Function defines an environment for a 2x2 gridworld example. Here, an agent is intended to
#' navigate from an arbitrary start position to a goal position. The grid is surrounded by a wall
#' which makes it impossible for the agent to move off the grid. In addition, the agent faces a wall between s1 and s4.
#' If the agent reaches the goal position, it earns a reward of 10. Crossing each square of the grid leads
#' to a negative reward of -1.
#'
#' @param state The current state.
#' @param action Action to be executed.
#' @return List containing the next state and the reward.
#' @export
gridworldEnvironment <- function(state, action) {
  next_state <- state
  if(state == state("s1") && action == "down") next_state <- state("s2")
  if(state == state("s2") && action == "up") next_state <- state("s1")
  if(state == state("s2") && action == "right") next_state <- state("s3")
  if(state == state("s3") && action == "left") next_state <- state("s2")
  if(state == state("s3") && action == "up") next_state <- state("s4")

  if(next_state == state("s4") && state != state("s4")) {
    reward <- 10
  } else {
    reward <- -1
  }

  out <- list("NextState" = next_state, "Reward" = reward)
  return(out)
}

#' Sample grid sequence
#'
#' Function uses an environment function to generate sample experience in the form of state transition tuples.
#'
#' @param N Number of samples.
#' @param actionSelection (optional) Defines the action selection mode of the reinforcement learning agent. Default: \code{random}.
#' @param control (optional) Control parameters defining the behavior of the agent.
#' Default: \code{alpha = 0.1}; \code{gamma = 0.1}; \code{epsilon = 0.1}.
#' @param model (optional) Existing model of class \code{rl}. Default: \code{NULL}.
#' @param ... Additional parameters passed to function.
#' @seealso \code{\link{gridworldEnvironment}}
#' @seealso \code{\link{ReinforcementLearning}}
#' @return An \code{dataframe} containing the experienced state transition tuples \code{s,a,r,s_new}.
#' The individual columns are as follows:
#' \describe{
#'   \item{\code{State}}{The current state.}
#'   \item{\code{Action}}{The selected action for the current state.}
#'   \item{\code{Reward}}{The reward in the current state.}
#'   \item{\code{NextState}}{The next state.}
#' }
#' @export
sampleGridSequence <- function(N, actionSelection = "random",
                               control = list(alpha = 0.1, gamma = 0.1, epsilon = 0.1), model = NULL, ...) {
  states <- c("s1", "s2", "s3", "s4")
  actions <- c("up", "down", "left", "right")

  data <- sampleExperience(N = N, env = gridworldEnvironment, states = states, actions = actions,
                           actionSelection = actionSelection, control = control, model = model)
  return(data)
}
