#' Loads reinforcement learning algorithm
#'
#' Decides upon a learning rule for reinforcement learning.
#' Input is a name for the learning rule, while output is the corresponding function object.
#'
#' @param type A string denoting the learning rule. Allowed values are \code{experienceReplay}.
#' @seealso \code{\link{ReinforcementLearning}}
#' @return Function that implements the specific learning rule.
lookupLearningRule <- function(type) {
  if (type == "experienceReplay") {
    return(experienceReplay)
  }

  stop("Name of learning rule not recognized. Corresponding argument has an invalid value.")
}
