#' Performs reinforcement learning
#'
#' Performs model-free reinforcement learning. Requires input data in the form of sample sequences
#' consisting of states, actions and rewards. The result of the learning process is a state-action table and an
#' optimal policy that defines the best possible action in each state.
#'
#' @param data A dataframe containing the input sequences for reinforcement learning.
#' Each row represents a state transition tuple \code{(s,a,r,s_new)}.
#' @param s A string defining the column name of the current state in \code{data}.
#' @param a A string defining the column name of the selected action for the current state in \code{data}.
#' @param r A string defining the column name of the reward in the current state in \code{data}.
#' @param s_new A string defining the column name of the next state in \code{data}.
#' @param learningRule A string defining the selected reinforcement learning agent. The default value and
#' only option in the current package version is \code{experienceReplay}.
#' @param iter (optional) Iterations to be done. iter is an integer greater than 0. By default, \code{iter} is set to 1.
#' @param control (optional) Control parameters defining the behavior of the agent.
#' Default: \code{alpha = 0.1}; \code{gamma = 0.1}; \code{epsilon = 0.1}.
#' @param verbose If true, progress report is shown. Default: \code{false}.
#' @param model (optional) Existing model of class \code{rl}. Default: \code{NULL}.
#' @param ... Additional parameters passed to function.
#' @return An object of class \code{rl} with the following components:
#' \describe{
#'   \item{\code{Q}}{Resulting state-action table.}
#'   \item{\code{Q_hash}}{Resulting state-action table in \code{hash} format.}
#'   \item{\code{Actions}}{Set of actions.}
#'   \item{\code{States}}{Set of states.}
#'   \item{\code{Policy}}{Resulting policy defining the best possible action in each state.}
#'   \item{\code{RewardSequence}}{Rewards collected during each learning episode in \code{iter}.}
#'   \item{\code{Reward}}{Total reward collected during the last learning iteration in \code{iter}.}
#' }
#' @import hash
#' @aliases rl
#' @examples
#' # Sampling data (1000 grid sequences)
#' data <- sampleGridSequence(1000)
#'
#' # Setting reinforcement learning parameters
#' control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)
#'
#' # Performing reinforcement learning
#' model <- ReinforcementLearning(data, s = "State", a = "Action", r = "Reward",
#' s_new = "NextState", control = control)
#'
#' # Printing model
#' print(model)
#'
#' # Plotting learning curve
#' plot(model)
#' @references Sutton and Barto (1998). Reinforcement Learning: An Introduction, Adaptive
#' Computation and Machine Learning, MIT Press, Cambridge, MA.
#' @rdname ReinforcementLearning
#' @export
ReinforcementLearning <- function(data, s = "s", a = "a", r = "r", s_new = "s_new",
                    learningRule = "experienceReplay", iter = 1,
                    control = list(alpha = 0.1, gamma = 0.1, epsilon = 0.1), verbose = F,
                    model = NULL, ...) {
  if (!(iter > 0 && length(iter) == 1 && is.numeric(iter) && floor(iter) == iter)) {
    stop("Argument 'iter' should be an integer > 0.")
  }
  if (class(model) != "rl" && !is.null(model)) {
    stop("Argument 'model' must be empty or of type 'rl'.")
  }
  if (!is.list(control)) {
    stop("Argument 'control' must be of type 'list'.")
  }
  if (is.null(control$alpha) || is.null(control$gamma) || !is.numeric(control$alpha) || !is.numeric(control$gamma)) {
    stop("Missing or invalid control parameters.")
  }
  if (any(control > 1) || any(control < 0)) {
    stop("Control parameter values must be between 0 and 1.")
  }
  if (!is.data.frame(data)) {
    stop("Argument 'data' must of type 'data.frame'.")
  }
  if ("tbl" %in% class(data)) {
    data <- as.data.frame(data)
  }
  if (!(is.character(s) && is.character(a) && is.character(r) && is.character(s_new))) {
    stop("Arguments 's', 'a', 'r', and 's_new' must be of type 'character'.")
  }
  if (sum(c(s, a, r, s_new) %in% colnames(data)) != 4) {
    stop("Data columns invalid or not provided.")
  } else {
    d <- data.frame(
      s = data[, s],
      a = data[, a],
      r = data[, r],
      s_new = data[, s_new],
      stringsAsFactors = F
    )
    colnames(d)
  }
  if (!(is.character(d$s) && is.character(d$a) && is.character(d$s_new) && is.numeric(d$r))) {
    stop("Input data invalid. States and actions must be of type 'character', while rewards must be of type 'numeric'.")
  }
  if (any(is.na(d$r))) {
    stop("Input data invalid. Reward column contains NA values.")
  }
  if (is.null(model)) {
    Q <- hash()
    rewardSequence <- c()
  } else {
    Q <- model$Q_hash
    rewardSequence <- model$RewardSequence
  }
  for (i in unique(d$s)[!unique(d$s) %in% names(Q)]) {
    Q[[i]] <- hash(unique(d$a), rep(0, length(unique(d$a))))
  }

  agentFunction <- lookupLearningRule(learningRule)

  knowledge <- list("Q" = Q)
  learned <- list()
  for (i in 1:iter) {
    if (verbose) {
      cat0("Iteration: ", i, "\\" , iter)
    }
    learned[[i]] <- agentFunction(d, knowledge$Q, control)
    knowledge <- learned[[i]]
  }

  out <- list()
  out$Q_hash <- learned[[length(learned)]]$Q
  out$Q <- lapply(as.list(learned[[length(learned)]]$Q, all.names = T), function(x)
    as.list(x, all.names = T))
  stateNames <- names(out$Q)
  out$Q <- t(data.frame(lapply(out$Q, unlist)))
  rownames(out$Q) <- stateNames
  out$States <- rownames(out$Q)
  out$Actions <- colnames(out$Q)
  out$Policy <- computePolicy(out$Q)
  out$LearningRule <- learningRule
  out$Reward <- sum(d$r)
  out$RewardSequence <- c(rewardSequence, rep(sum(d$r), iter))
  class(out) <- "rl"
  return(out)
}

#' @export
print.rl <- function(x, ...) {
  cat("State-Action function Q\n")
  print(x$Q)
  cat("\nPolicy\n")
  print(x$Policy)
  cat("\nReward (last iteration)\n")
  print(x$Reward)
}

#' @importFrom stats median sd
#' @export
summary.rl <- function(object, ...) {
  cat0("\nModel details")
  cat0("Learning rule:           ", object$LearningRule)
  cat0("Learning iterations:     ", length(object$RewardSequence))
  cat0("Number of states:        ", length(rownames(object$Q)))
  cat0("Number of actions:       ", length(colnames(object$Q)))
  cat0("Total Reward:            ", object$Reward)

  cat0("\nReward details (per iteration)")
  cat0("Min:                     ", min(object$RewardSequence))
  cat0("Max:                     ", max(object$RewardSequence))
  cat0("Average:                 ", mean(object$RewardSequence))
  cat0("Median:                  ", median(object$RewardSequence))
  cat0("Standard deviation:      ", sd(object$RewardSequence))
}

#' @export
predict.rl <- function(object, newdata = NULL, ...) {
  if (missing(newdata) || is.null(newdata)) {
    return(computePolicy(object))
  }
  if (!is.vector(newdata)) {
    stop("Argument 'newdata' must be of type vector.")
  }

  p <- computePolicy(object)
  if (!all(newdata %in% object$States)) {
    stop("Invalid state in argument 'newdata'.")
  }

  out <- p[sapply(newdata, function(y) which(names(p) == y))]
  names(out) <- NULL

  return(out)
}

#' @importFrom graphics plot
#' @export
plot.rl <- function(x, type = "o", xlab = "Learning iteration",
                    ylab = "Reward", main = "Reinforcement learning curve", ...) {
  plot(x = seq(1:length(x$RewardSequence)), y = x$RewardSequence,
       type = type, xlab = xlab, ylab = ylab, main = main, ...)
}

cat0 <- function(...) {
  cat(..., "\n", sep = "")
}
