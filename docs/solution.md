# Solution. Как использовать решение для вычисления ошибки.

Оптимизотор, т.е. геналгоритмы, исполнен, как [класс](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/ga/ga.py#L21).
Этот класс оперирует с организмами, как с экземплярами другого класса,
который **должет наследоваться** от [`Solution`](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L7).

`Solution` хранит в себе два обязательных поля:

`x` -- вектор подбираемых параметров;

`y` -- значение лосса на `x`;

Так же экземпляр `Solution` может хранить произвольные данные, к которым можно обратиться а-ля `sol["something"]`. Этими данными становятся `state`, `phenotype` и прочее для наших электрофизиологических моделей.

Напрямую `Solution` использовать нельзя, потому что в нём **не определены** две необходимые функции: `update()` и `is_valid()`.

[`update()`](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L95) должна посчитать `y` при заданном `x`. Изначально в `y` лежит `None`, что значит, что решение создано, но мы не знаем, насколько оно хорошее. Проапдейченность проверяется [тут](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L99).

[`is_valid()`](https://github.com/humanphysiologylab/pypoptim/blob/ca3f4340af19a569153b49b9b03e96ea7ab87f40/pypoptim/algorythm/solution.py#L102) проверяет, что решение можно отправлять в генетические операции. Это нужно, например, для случаев, когда `update()` сработал, но вернул `NaN` или испортил `state`.

`update()` и `is_valid()` **необходимо** определить в дочернем классе ([например](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/solmodel.py#L15)).

**N.B.** В примере выше есть [вот такие строки](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/solmodel.py#L18). Т.е. при создании экземпляра класса **уже должны быть** поля `model` и `config`. (А где собственно они успели появиться???)

> Вы спросите меня: в чем загадка этого букета? Я вам отвечу: не знаю, в чем загадка этого букета. Тогда вы подумаете и спросите: а в чем же разгадка? А в том разгадка, что ...

... что `model` и `config` добавляются однократно к классу, ещё до любой его инстанциации ([см. тут](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/mpi_script.py#L66)). У этого есть веские и непреодолимые причины, но это слишком долго объяснять.
