#' Game states of 100,000 randomly sampled Tic-Tac-Toe games.
#'
#' A dataset containing 406,541 game states of Tic-Tac-Toe.
#' The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row wins the game.
#' All states are observed from the perspective of player X, who is also assumed to have played first.
#'
#' @format A data frame with 406,541 rows and 4 variables:
#' \describe{
#'   \item{State}{The current game state, i.e. the state of the 3x3 grid.}
#'   \item{Action}{The move of player X in the current game state.}
#'   \item{NextState}{The next observed state after action selection of players X and B.}
#'   \item{Reward}{Indicates terminal and non-terminal game states. Reward is +1 for 'win', 0 for 'draw', and -1 for 'loss'.}
#' }
"tictactoe"
