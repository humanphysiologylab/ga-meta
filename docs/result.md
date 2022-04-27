# Result. Что выдается по ходу расчета.

Вывод делается постепенно по ходу расчета, в частности
- процессор с лучшим организмом сохраняет этот организм ([click](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/mpi_script.py#L127))
- процессор со следующим рагном пишет всю популяцию ([click](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/mpi_script.py#L142))

Ввод (чтение конфига) и вывод определены [тут](https://github.com/humanphysiologylab/mpi_scripts/blob/demo-maleckar/mpi_scripts/voigt/io_utils.py).
