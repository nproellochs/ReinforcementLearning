#' Creates a state representation for arbitrary objects
#'
#' Converts object of any class to a reinforcement learning state of type character.
#'
#' @param x An object of any class.
#' @param ... Additional parameters passed to function.
#' @return Character value defining the state representation of the given object.
#'
#' @export
state <- function(x, ...) {
  UseMethod("state", x)
}

#' @export
state.character <- function(x, ...) {
  name <- toString(x)
  return(name)
}

#' @export
state.double <- function(x, ...) {
  name <- toString(x)
  return(name)
}

#' @export
state.default <- function(x, storeObject = FALSE, ...) {
  name <- toString(x)
  return(name)
}
