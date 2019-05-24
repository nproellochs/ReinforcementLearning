#' Sample state transitions from an environment function
#'
#' Function generates sample experience in the form of state transition tuples.
#'
#' @param N Number of samples.
#' @param env An environment function.
#' @param states A character vector defining the enviroment states.
#' @param actions A character vector defining the available actions.
#' @param actionSelection (optional) Defines the action selection mode of the reinforcement learning agent. Default: \code{random}.
#' @param control (optional) Control parameters defining the behavior of the agent.
#' Default: \code{alpha = 0.1}; \code{gamma = 0.1}; \code{epsilon = 0.1}.
#' @param model (optional) Existing model of class \code{rl}. Default: \code{NULL}.
#' @param ... Additional parameters passed to function.
#' @seealso \code{\link{ReinforcementLearning}}
#' @seealso \code{\link{gridworldEnvironment}}
#' @return An \code{dataframe} containing the experienced state transition tuples \code{s,a,r,s_new}.
#' The individual columns are as follows:
#' \describe{
#'   \item{\code{State}}{The current state.}
#'   \item{\code{Action}}{The selected action for the current state.}
#'   \item{\code{Reward}}{The reward in the current state.}
#'   \item{\code{NextState}}{The next state.}
#' }
#' @examples
#' # Define environment
#' env <- gridworldEnvironment
#'
#' # Define states and actions
#' states <- c("s1", "s2", "s3", "s4")
#' actions <- c("up", "down", "left", "right")
#'
#' # Sample 1000 training examples
#' data <- sampleExperience(N = 1000, env = env, states = states, actions = actions)
#' @export
sampleExperience <- function(N, env, states, actions, actionSelection = "random",
                             control = list(alpha = 0.1, gamma = 0.1, epsilon = 0.1), model = NULL, ...) {
  if (!(N > 0 && length(N) == 1 && is.numeric(N) && floor(N) == N)) {
    stop("Argument 'N' should be an integer > 0.")
  }
  if (!is.function(env)) {
    stop("Argument 'env' describing the environment must be of type function.")
  }
  if (!is.character(states)) {
    stop("Arguments 'states' must be of type 'character'.")
  }
  if (!is.character(actions)) {
    stop("Arguments 'actions' must be of type 'character'.")
  }
  if (class(model) != "rl" && !is.null(model)) {
    stop("Argument 'model' must be empty or of type 'rl'.")
  }
  if (!is.list(control)) {
    stop("Argument 'control' must be of type 'list'.")
  }
  if (is.null(control$epsilon)) {
    stop("Missing or invalid control parameters.")
  }
  if (is.null(model)) {
    Q <- hash()
  } else {
    Q <- model$Q_hash
  }
  for (i in unique(states)[!unique(states) %in% names(Q)]) {
    Q[[i]] <- hash(unique(actions), rep(0, length(unique(actions))))
  }

  actionSelectionFunction <- lookupActionSelection(actionSelection)

  sampleStates <- sample(states, N, replace = T)
  sampleActions <-
    sapply(sampleStates, function(x)
      actionSelectionFunction(Q, x, control$epsilon))

  response <- lapply(1:length(sampleStates),
                     function(x) env(sampleStates[x], sampleActions[x]))
  response <- data.table::rbindlist(lapply(response, data.frame))

  out <- data.frame(
    State = sampleStates,
    Action = sampleActions,
    Reward = response$Reward,
    NextState = as.character(response$NextState),
    stringsAsFactors = F
  )
  return(out)
}
