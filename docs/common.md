# Common. What's going on.

Please refer to [our original PLoS article](https://doi.org/10.1371/journal.pone.0231695). I implemented a few alterations.

## Genetical operations are distributed
Originally, there was a master process that performed all genetic operations.
In the current version, there is no such master process.
Every process uses the whole population to create mutant organisms required only for this process.
This results in greater computational performance.

## Multiplicative scale for genes
Some genes may vary from ⅒ to 10 (e.g. conductivity of some ion channel). In the current version, one may use a log scale for the genetic operations on such genes.

## Tournament selection
[Link](https://en.wikipedia.org/wiki/Tournament_selection).
