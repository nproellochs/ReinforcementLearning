
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
# install.packages("devtools")

# Option 1: download and install latest version from GitHub
devtools::install_github("nproellochs/ReinforcementLearning")

# Option 2: install directly from bundled archive
devtoos::install_local("ReinforcementLearning_1.0.0.tar.gz")
```

Notes:

-   In the case of option 2, you have to specify the path either to the directory of **ReinforcementLearning** or to the bundled archive **ReinforcementLearning\_1.0.0.tar.gz**

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
#> 1    s4   down     -1        s4
#> 2    s2   left     -1        s2
#> 3    s2   left     -1        s2
#> 4    s3   down     -1        s3
#> 5    s4  right     -1        s4
#> 6    s1     up     -1        s1

# Define reinforcement learning parameters
control <- list(alpha = 0.1, gamma = 0.1, epsilon = 0.1)

# Perform reinforcement learning
model <- ReinforcementLearning(data, s = "State", a = "Action", r = "Reward", 
                               s_new = "NextState", control = control)

# Print result
print(model)
#> State-Action function Q
#>    right       up        down        left     
#> s1 -1.098634   -1.097283 -1.00241    -1.096258
#> s2 -0.02444219 -1.099662 -1.004478   -1.003711
#> s3 -0.01900075 9.878406  -0.03684077 -1.002955
#> s4 -1.106392   -1.105486 -1.105965   -1.09616 
#> 
#> Policy
#>      s1      s2      s3      s4 
#>  "down" "right"    "up"  "left" 
#> 
#> Reward (last iteration)
#> [1] -318
```

License
-------

**ReinforcementLearning** is released under the [MIT License](https://opensource.org/licenses/MIT)

Copyright (c) 2017 Nicolas Pröllochs & Stefan Feuerriegel
