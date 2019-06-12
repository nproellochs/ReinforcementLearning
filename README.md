
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Reinforcement Learning

[![Build
Status](https://travis-ci.org/nproellochs/ReinforcementLearning.svg?branch=master)](https://travis-ci.org/nproellochs/ReinforcementLearning)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ReinforcementLearning)](https://cran.r-project.org/package=ReinforcementLearning)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.01087/status.svg)](https://doi.org/10.21105/joss.01087)

**ReinforcementLearning** performs model-free reinforcement learning in
R. This implementation enables the learning of an optimal policy based
on sample sequences consisting of states, actions and rewards. In
addition, it supplies multiple predefined reinforcement learning
algorithms, such as experience replay.

## Overview

The most important functions of **ReinforcementLearning** are:

  - Learning an optimal policy from a fixed set of a priori known
    transition samples
  - Predefined learning rules and action selection modes
  - A highly customizable framework for model-free reinforcement
    learning tasks

## Installation

You can easily install the latest version of **ReinforcementLearning**
with

``` r
# Recommended option: download and install latest version from CRAN
install.packages("ReinforcementLearning")

# Alternatively, install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("nproellochs/ReinforcementLearning")
```

## Usage

This section shows the basic functionality of how to perform
reinforcement learning. First, load the corresponding package
**ReinforcementLearning**.

``` r
library(ReinforcementLearning)
```

The following example shows how to learn a reinforcement learning agent
using input data in the form of sample sequences consisting of states,
actions and rewards. The result of the learning process is a
state-action table and an optimal policy that defines the best possible
action in each state.

``` r
# Generate sample experience in the form of state transition tuples
data <- sampleGridSequence(N = 1000)
head(data)
#>   State Action Reward NextState
#> 1    s4   left     -1        s4
#> 2    s2  right     -1        s3
#> 3    s2  right     -1        s3
#> 4    s3   left     -1        s2
#> 5    s4     up     -1        s4
#> 6    s1   down     -1        s2

# Define reinforcement learning parameters
control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)

# Perform reinforcement learning
model <- ReinforcementLearning(data, s = "State", a = "Action", r = "Reward", 
                               s_new = "NextState", control = control)

# Print result
print(model)
#> State-Action function Q
#>          right        up        down       left
#> s1 -1.09619438 -1.098533 -1.00183072 -1.0978962
#> s2 -0.01980279 -1.097758 -1.00252228 -1.0037977
#> s3 -0.02335524  9.884394 -0.01722548 -0.9985081
#> s4 -1.09616040 -1.106392 -1.10548631 -1.1059655
#> 
#> Policy
#>      s1      s2      s3      s4 
#>  "down" "right"    "up" "right" 
#> 
#> Reward (last iteration)
#> [1] -263
```

## Learning Reinforcement Learning

If you are new to reinforcement learning, you are better off starting
with a systematic introduction, rather than trying to learn from reading
individual documentation pages. There are three good places to start:

1.  A thorough introduction to reinforcement learning is provided in
    [Sutton
    (1998)](https://www.semanticscholar.org/paper/Reinforcement-Learning%3A-An-Introduction-Sutton-Barto/dd90dee12840f4e700d8146fb111dbc863a938ad).

2.  The package
    [vignette](https://github.com/nproellochs/ReinforcementLearning/blob/master/vignettes/ReinforcementLearning.Rmd)
    demonstrates the main functionalities of the ReinforcementLearning R
    package by drawing upon common examples from the literature
    (e.g. finding optimal game strategies).

3.  Multiple blog posts on
    [R-bloggers](https://www.r-bloggers.com/reinforcement-learning-q-learning-with-the-hopping-robot/)
    demonstrate the capabilities of the ReinforcementLearning package
    using practical examples.

## Contributing

If you experience any difficulties with the package, or have
suggestions, or want to contribute directly, you have the following
options:

  - Contact the [maintainer](mailto:nicolas.proellochs@wi.jlug.de) by
    email.
  - Issues and bug reports: [File a GitHub
    issue](https://github.com/nproellochs/ReinforcementLearning/issues).
  - Fork the source code, modify, and issue a [pull
    request](https://help.github.com/articles/creating-a-pull-request-from-a-fork/)
    through the [project GitHub
    page](https://github.com/nproellochs/ReinforcementLearning).

## License

**ReinforcementLearning** is released under the [MIT
License](https://opensource.org/licenses/MIT)

Copyright (c) 2019 Nicolas Pröllochs & Stefan Feuerriegel
