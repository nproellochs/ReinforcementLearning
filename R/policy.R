#' Calculates the reinforcement learning policy
#'
#' Calculates reinforcement learning policy from a given state-action table Q.
#' The policy is the decision making function of the agent and defines the learning
#' agent's way of behaving at a given time.
#'
#' @param x Variable which encodes the behavior of the agent. This can be
#' either a \code{matrix}, \code{data.frame} or a \code{\link{rl}} object.
#' @seealso \code{\link{ReinforcementLearning}}
#' @return Returns the learned policy.
#' @rdname policy
#' @export
policy <- function(x) {
  UseMethod("policy", x)
}

#' @export
policy.matrix <- function(x) {
  policy <- colnames(x)[apply(x, 1, which.max)]
  names(policy) <- rownames(x)
  return(policy)
}

#' @export
policy.data.frame <- function(x) {
  return(policy(as.matrix(x)))
}

#' @export
policy.rl <- function(x) {
  return(policy(x$Q))
}

#' @export
policy.default <- function(x) {
  stop("Argument invalid.")
}
