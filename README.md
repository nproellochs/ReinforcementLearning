
<!-- README.md is generated from README.Rmd. Please edit that file -->
Reinforcement Learning
======================

**ReinforcementLearning** performs model-free reinforcement learning in R. This implementation allows to learn an optimal policy based on sample sequences consisting of states, actions and rewards. In addition, it supplies multiple predefined reinforcement learning algorithms, such as experience replay.

Overview
--------

The most important functions in **ReinforcementLearning** are:

-   Learning an optimal policy from a fixed set of a priori-known transition samples
-   Predefined learning rules and action selection modes
-   A highly customizable framework for model-free reinforcement learning tasks

Installation
------------

Using the **devtools** package, you can easily install the latest development version of **ReinforcementLearning** with

``` r
install.packages("devtools")

# Recommended option: download and install latest version from "GitHub"
devtools::install_github("nproellochs/ReinforcementLearning")
```

Notes:

-   A CRAN version has not yet been released.

Usage
-----

This section shows the basic functionality of how to perform reinforcement learning. First, load the corresponding package **ReinforcementLearning**.

``` r
library(ReinforcementLearning)
```

The following example shows how to learn a reinforcement learning agent using input data in the form of sample sequences consisting of states, actions and rewards. The result of the learning process is a state-action table and an optimal policy that defines the best possible action in each state.

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

License
-------

**ReinforcementLearning** is released under the [MIT License](https://opensource.org/licenses/MIT)

Copyright (c) 2017 Nicolas Pröllochs & Stefan Feuerriegel
