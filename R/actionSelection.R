#' Performs \eqn{\varepsilon}-greedy action selection
#'
#' Implements \eqn{\varepsilon}-greedy action selection. In this strategy, the agent explores the environment
#' by selecting an action at random with probability \eqn{\varepsilon}. Alternatively, the agent exploits its
#' current knowledge by choosing the optimal action with probability \eqn{1-\varepsilon}.
#'
#' @param Q State-action table of type \code{hash}.
#' @param state The current state.
#' @param epsilon Exploration rate between 0 and 1.
#' @return Character value defining the next action.
#' @import hash
#' @importFrom stats runif
#' @references Sutton and Barto (1998). Reinforcement Learning: An Introduction, Adaptive
#' Computation and Machine Learning, MIT Press, Cambridge, MA.
#' @export
epsilonGreedyActionSelection <- function(Q, state, epsilon) {
  if (runif(1) <= epsilon) {
    best_action <- names(sample(values(Q[[state]]), 1))
  } else {
    best_action <- names(which.max(values(Q[[state]])))
  }
  return(best_action)
}

#' Performs random action selection
#'
#' Performs random action selection. In this strategy, the agent always selects an action at random.
#'
#' @param Q State-action table of type \code{hash}.
#' @param state The current state.
#' @param epsilon Exploration rate between 0 and 1 (not used).
#' @return Character value defining the next action.
#' @import hash
#' @export
randomActionSelection <- function(Q, state, epsilon) {
  return(names(sample(values(Q[[state]]), 1)))
}

#' Converts a name into an action selection function
#'
#' Input is a name for the action selection, output is the corresponding function object.
#'
#' @param type A string denoting the type of action selection. Allowed values are \code{epsilon-greedy} or \code{random}.
#' @return Function that implements the specific learning rule.
lookupActionSelection <- function(type) {
  if (type == "epsilon-greedy") {
    return(epsilonGreedyActionSelection)
  }
  if (type == "random") {
    return(randomActionSelection)
  }
  stop("Rule for action selection not recognized. Corresponding argument has an invalid value.")
}
