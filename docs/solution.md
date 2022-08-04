# Solution. How to use solution to calculate loss function.

The optimizer (namely, GA) is imlemented as the [class](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/ga/ga.py#L21).
GA operates with organisms that **must be inherited** from the [`Solution`](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L7) 

`Solution` holds to required fileds:

`x` -- parameters to find;

`y` -- value of the loss function at `x`;

`Solution` can store arbitrary data due to the `data` filed. In optimization problems of AP models `data` stores `state` and `phenotype`.

`Solution` must implement `update()` and `is_valid()` methods. They are not implemented by default.

[`update()`](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L95) returns `y` given `x`. Initially, `y` stores `None` that meands that the solution is "created" yet we have not measured its loss. [This](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L99) code checks if the solutions is updated.

[`is_valid()`](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L102) checks if the solution is ready for the genetic operations. It's important in some edge cases. For example, if some columns of the `state` have `NaN` values after `update()`.

[Example](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/solmodel.py#L15) of how to implement `update()` and `is_valid()` in the child class.

**P.S.** There are [beautiful lines](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/solmodel.py#L18), i.e. the instance of the class **must have** attributes named `model` and `config`. But how is this possible? When this happened? 

> Here I ommit the quote from my favorite book...

I use the workaround ([here](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/mpi_script.py#L66)). So, `model` and `config` are static. There are good and compelling reasons for this, but it's too hard to explain.
