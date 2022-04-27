# Model. Как получать решение в python, когда модель есть на C.

[Класс](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/cardiac_model.py#L23), который отправляет задачу на обсчет и получает решение.

С помощью [`ctypes`](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/cardiac_model.py#L29) делается связка между python и С. Сигнатура функции должна точно совпадать. [Вот](https://github.com/humanphysiologylab/models_ctypes/blob/1003a3f8e24dcdf6ebebf633e523e31c90a02864/src/model_ctypes/_maleckar/run.c#L22), как `run` выглялит в C.

[Небольшой хелпер](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/cardiac_model.py#L7), который позволяет передвать `null` вместо массивов.
