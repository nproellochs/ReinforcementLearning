#' Performs experience replay
#'
#' Performs experience replay. Experience replay allows reinforcement learning agents to remember and reuse experiences from the past.
#' The algorithm requires input data in the form of sample sequences consisting of states, actions and rewards.
#' The result of the learning process is a state-action table Q that allows one to infer the best possible action in each state.
#'
#' @param D A \code{dataframe} containing the input data for reinforcement learning.
#' Each row represents a state transition tuple \code{(s,a,r,s_new)}.
#' @param Q Existing state-action table of type \code{hash}.
#' @param control Control parameters defining the behavior of the agent.
#' @param ... Additional parameters passed to function.
#' @return Returns an object of class \code{hash} that contains the learned Q-table.
#' @seealso \code{\link{ReinforcementLearning}}
#' @references Lin (1992). "Self-Improving Reactive Agents Based on Reinforcement Learning, Planning and Teaching", Machine Learning (8:3), pp. 293--321.
#' @references Watkins (1992). "Q-learning". Machine Learning (8:3), pp. 279--292.
#' @import hash
#' @export
replayExperience <- function(D, Q, control, ...) {
  if (!is.hash(Q)) {
    stop("Parameter Q must be of type hash.")
  }
  if (!is.data.frame(D)) {
    stop("Argument 'data' must be empty or of type 'data.frame'.")
  }
  if (sum(c("s", "a", "r", "s_new") %in% colnames(D)) != 4) {
    stop("Undefined columns specified.")
  }
  if (!is.list(control)) {
    stop("Argument 'control' must be of type 'list'.")
  }

  for (i in 1:nrow(D)) {
    d <- D[i, ]
    state <- d$s
    action <- d$a
    reward <- d$r
    nextState <- d$s_new

    currentQ <- Q[[state]][[action]]
    if (has.key(nextState,Q)) {
      maxNextQ <- max(values(Q[[nextState]]))
    } else {
      maxNextQ <- 0
    }
    Q[[state]][[action]] <- currentQ + control$alpha *
      (reward + control$gamma * maxNextQ - currentQ)
  }

  out <- list(Q = Q)
  return(out)
}

#' Performs experience replay
#'
#' Deprecated. Please use [ReinforcementLearning::replayExperience()] instead.
#'
#' @param D A \code{dataframe} containing the input data for reinforcement learning.
#' Each row represents a state transition tuple \code{(s,a,r,s_new)}.
#' @param Q Existing state-action table of type \code{hash}.
#' @param control Control parameters defining the behavior of the agent.
#' @param ... Additional parameters passed to function.
#' @return Returns an object of class \code{hash} that contains the learned Q-table.
#' @seealso \code{\link{ReinforcementLearning}}
#' @references Lin (1992). "Self-Improving Reactive Agents Based on Reinforcement Learning, Planning and Teaching", Machine Learning (8:3), pp. 293--321.
#' @references Watkins (1992). "Q-learning". Machine Learning (8:3), pp. 279--292.
#' @import hash
#' @export
experienceReplay <- function(D, Q, control, ...) {
  .Deprecated("replayExperience")
  replayExperience(D, Q, control, ...)
}
