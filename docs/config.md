# Config. How to set up a problem.

[Example](../configs/config_maleckar.json) of the config.

It should be a valid [json](https://www.json.org/json-en.html).
Although, I made possible comment lines using `#`.

## Global parameters
(*some of them are unnecessary, check the code if needed*)
```json
"seed": 42
```
Initialization of the random number generator.
Works repeatable **only** if the number of processes is the same.
This is due to distributed genetic operations.

```json
"n_organisms": 64
"n_elites": 4
"n_generations": 5
```
Number of organisms (`n_organisms`) must be > 4. If `n_organisms` is less than number of processes than the former will be properly increased.

```json
"filename_so": "/home/models_ctypes/src/model_ctypes/_maleckar/maleckar.so"
"filename_legend_states": "/home/models_ctypes/src/model_ctypes/_maleckar/legend_states.csv"
"filename_legend_constants": "/home/models_ctypes/src/model_ctypes/_maleckar/legend_constants.csv"
```

`so`-file is compiled library for the model running. `legend`-files define initial conditions and names of the genes.
Examples: [`legend_states.csv`](https://github.com/humanphysiologylab/models_ctypes/blob/demo-maleckar/src/model_ctypes/_maleckar/legend_states.csv), [`legend_constants.csv`](https://github.com/humanphysiologylab/models_ctypes/blob/demo-maleckar/src/model_ctypes/_maleckar/legend_constants.csv).
Columns [`name`, `value`] are obligatory.

```json
"t_run": 3
"t_sampling": 0.001
"tol": 1e-4
"stim_period_legend_name": "stim_period"
```

This part completely depends on the model. For the Maleckar model (used in demo) these parameters are:

`t_run` -- minimal number of **seconds** to run the model on every pacing period.
It's possible to use `n_beats` insted, if fixed number of beats is needed.
However, the second option provied less stationary solution.

`t_sampling` -- sampling period in the output.

`tol` -- parameter for the LSODA solver.

`stim_period_legend_name` -- name of the variable that means the pacing period used in the `legend`-file. For the Maleckar model, it is `"stim_period"`.

```json
"loss": "RMSE"
"columns_control": ["V"]
"columns_model": ["V"]
```

About losses, please refer to the section "[Loss. How to define loss function](./loss.md)."
`columns_*` define columns in the solution dataframe.
These columns are used to calculate loss function. 
Example for the transmembrane potential and Ca-transients:
```json
"loss": "your preferable loss"
"columns_control": ["V", "CaT"]
"columns_model": ["V", "fluo"]
```
In this example, names in `columns_control` and `columns_model` are not equal pairwise (`CaT` and `fluo`). It's okay and depends on the input files.

```json
"gamma": 0.0015
"crossover_rate": 1.0
"mutation_rate": 1.0
"selection_force": 2
```
Hyperparams of the genetic algorithms.
In fact, all these are unnecessary.
There are default values for them ([here](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/io_utils.py#L120)). The most crutial parameter is `gamma`.
Default `gamma = 1` is too much. I recommend `0.15` or so.

---

You can implement any other global parameters you need.
Example: [L2-regularization](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/loss_utils.py#L178).

## Experimental conditions

```json
"common": {
    "params": {

        "Na_b": 140,
        "Ca_b": 2.0,
        "K_b": 4,

        "P_Na": {
            "bounds": [0.5, 2],
            "is_multiplier": true
        },
        "g_K1": {
            "bounds": [0.5, 2],
            "is_multiplier": true
        }
    }
}
```

Shared parameters among all experimental conditions.

Rules are simple:

`"Na_b": 140` means that the gene with a name `Na_b` is the constant (`140`).

`"P_Na": {"bounds": [0.5, 2], ...}` means that the gene with a name `P_Na` is mutable.

In general, mutable genes are defined as follows:
```json
"Name": {
    "bounds": [lower, upper],
    "is_multiplier": true,
    "gamma_multiplier": 0.5
}
```

`bounds` -- are multipliers that are multiplied by the reference value(refval) of the parameter in legend_constants. Then real bounds of parameter "Name" are  [refval*lower, refval*upper]. This is the only obligatory parameter.
`is_multiplier` -- turns on log-scale if set to `true`.
`gamma_multiplier` -- mutation amplitude, works along with the global aforementioned `gamma`.

```json
"500": {
    "params": {
        "stim_period": 0.5,
        "Na_i": {
            "bounds": [5, 15]
        },
        "K_i": {
            "bounds": [100, 160]
        }
    },
    "filename_phenotype": "/home/models_ctypes/data/maleckar/fluo/phenotypes/phenotype_500.csv",
    "filename_state": "/home/models_ctypes/data/maleckar/fluo/states/state_500.csv"
}
```
This is definition of some esperimental condition (pacing period, drug administration, etc.)

`"500"` -- just a name of this `experimental condition`. Must be a string (not an int, `500` is invalid). Can be: `"PCL = 500ms"`, `"Second trace"`, `"Pinacidil 5uM"`.

`params` -- same as `common`.

`filename_phenotype` -- baseline to use in the calculation of the loss function.

`filename_state` -- intitial state for the **first generation** of the organisms.

---

Number of the `experimental conditions` (apart from the required `common`) must be greater than one.
