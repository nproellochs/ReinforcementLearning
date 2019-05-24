#' Computes the reinforcement learning policy
#'
#' Computes reinforcement learning policy from a given state-action table Q.
#' The policy is the decision-making function of the agent and defines the learning
#' agent's behavior at a given time.
#'
#' @param x Variable which encodes the behavior of the agent. This can be
#' either a \code{matrix}, \code{data.frame} or an \code{\link{rl}} object.
#' @seealso \code{\link{ReinforcementLearning}}
#' @return Returns the learned policy.
#' @rdname computePolicy
#' @export
computePolicy <- function(x) {
  UseMethod("computePolicy", x)
}

#' @export
computePolicy.matrix <- function(x) {
  policy <- colnames(x)[apply(x, 1, which.max)]
  names(policy) <- rownames(x)
  return(policy)
}

#' @export
computePolicy.data.frame <- function(x) {
  return(computePolicy(as.matrix(x)))
}

#' @export
computePolicy.rl <- function(x) {
  return(computePolicy(x$Q))
}

#' @export
computePolicy.default <- function(x) {
  stop("Argument invalid.")
}

#' Computes the reinforcement learning policy
#'
#' Deprecated. Please use [ReinforcementLearning::computePolicy()] instead.
#'
#' @param x Variable which encodes the behavior of the agent. This can be
#' either a \code{matrix}, \code{data.frame} or an \code{\link{rl}} object.
#' @seealso \code{\link{ReinforcementLearning}}
#' @return Returns the learned policy.
#' @rdname policy
#' @export
policy <- function(x) {
  .Deprecated("computePolicy")
  computePolicy(x)
}
