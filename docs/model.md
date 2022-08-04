# Model. How to get a solution inside python when a model is implemented in C.

[Class](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/cardiac_model.py#L23) that runs model and returns a result.

Python and C are interfaced via [`ctypes`](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/cardiac_model.py#L29). Functions' signatures in Python and C must be the same. [Exmaple](https://github.com/humanphysiologylab/models_ctypes/blob/1003a3f8e24dcdf6ebebf633e523e31c90a02864/src/model_ctypes/_maleckar/run.c#L22) of how `run` is implemented in C.

[Little helper](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/cardiac_model.py#L7) makes possible to use `null`-s instead of the arraysвместо массивов.
