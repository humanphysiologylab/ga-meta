# Config. Как сконфигурировать задачу.

Вот пример [конфига](../configs/config_maleckar.json).

Это должен быть валидный [json](https://www.json.org/json-en.html). Полезная штука --
можно ставить `#`-комментарии.

*(Вообще надо было бы сделать [yaml], но когда код писался, про yaml я не знал)*

## Глобальные параметры
(*кто-то может быть необязательным, это надо в коде искать*)
```json
"seed": 42
```
Инициализация генератора рандома. Работает только при одинаковом числе процессоров. Это потому что генетические операции распределены: каждый процессор делает себе мутантов сам.

```json
"n_organisms": 64
"n_elites": 4
"n_generations": 5
```
Число организмов нельзя делать менее 4. Если организмы не делятся на процессоры, то первые будут увеличены. 

```json
"filename_so": "/home/models_ctypes/src/model_ctypes/_maleckar/maleckar.so"
"filename_legend_states": "/home/models_ctypes/src/model_ctypes/_maleckar/legend_states.csv"
"filename_legend_constants": "/home/models_ctypes/src/model_ctypes/_maleckar/legend_constants.csv"
```

Файл `so` -- скомпилированная "библиотека", которая считает модель. `legend` -- файлы , в которых устанавливаются начальные условия и, самое главное, названия параметров.
Примеры: [`legend_states.csv`](https://github.com/humanphysiologylab/models_ctypes/blob/demo-maleckar/src/model_ctypes/_maleckar/legend_states.csv), [`legend_constants.csv`](https://github.com/humanphysiologylab/models_ctypes/blob/demo-maleckar/src/model_ctypes/_maleckar/legend_constants.csv).
Необходимые столбцы [`name`, `value`], остальное неважно.

```json
"t_run": 3
"t_sampling": 0.001
"tol": 1e-4
"stim_period_legend_name": "stim_period"
```
Это полностью зависит от того, как исполнена модель. Для Малекар, на которой я показываю работу кода, эти параметры значат следующее.

`t_run` -- сколько **секунд** минимум считать модель на каждом периоде. Если нужно конкретное число ударов (хотя, это даёт менее стационарное решение), можно  вместо `t_run` использовать `n_beats: 9`, например.

`t_sampling` -- шаг для вывода решения.

`tol` -- параметр солвера LSODA.

`stim_period_legend_name` -- как называется период симуляции в `legend`-файле. Для Малекар это `"stim_period"`.

```json
"loss": "RMSE"
"columns_control": ["V"]
"columns_model": ["V"]
```

Про то, какие вообще бывают лоссы, как их прописывать смотреть в разделе [Loss](./loss.md). `columns_*` определяют колонки из датафреймов, которые использутся для подсчета. Для потенциала и кальциевых переходов они могут выглядеть так:
```json
"loss": "какой-то лосс"
"columns_control": ["V", "CaT"]
"columns_model": ["V", "fluo"]
```
То есть называния колонок могут и не совпадать.

```json
"gamma": 0.0015
"crossover_rate": 1.0
"mutation_rate": 1.0
"selection_force": 2
```
Гиперпараметры геналгоритмов.
На самом деле, все эти параметры необязательные.
Если их не указать, они проставятся по-дефолту ([см. тут](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/io_utils.py#L120)). Критичный параметр `gamma`, единица для него это слишком много.

---

В целом всё с верхне-уровневыми параметрами, хотя бывают (и можно делать сколько угодно) ещё. Например, есть вот [ручка для L2-регуляризации](https://github.com/humanphysiologylab/mpi_scripts/blob/a1fdb8ace7af8d759c026393ab00b67ca20a97c3/mpi_scripts/voigt/loss_utils.py#L178).

## Experimental conditions

Сюда попадает информация о том, какие параметры на каких периодах менять, в каких границах, на каких бейзлайнах считать ошибку и т.п.

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

Это параметры, которые шэрятся (надо было бы `shared` назвать, а не `common`) между всеми периодами стимуляции.

Правило простое, если параметр задаётся `"Na_b": 140`, то это константа, которую надо зафиксировать. Если `"P_Na": {"bounds": [0.5, 2], ...}`, то это "ген", который надо подбирать.

Ген в общем случае задаётся так:
```json
"Name": {
    "bounds": [lower, upper],
    "is_multiplier": true,
    "gamma_multiplier": 0.5
}
```
`bounds` -- всё понятно. Это единственный обязательный параметр.
`is_multiplier` -- нужно ли мутировать в log-шкале.
`gamma_multiplier` -- этой штукой можно увеличить или уменьшить интенсивность мутации. Работает вместе с `gamma`, которая задаётся на верхнем уровне.

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
Так определяется, каким образом обрабатывается конкретный период (или что угодно в этом роде).

`"500"` -- это просто название этого `experimental condition`. Может быть чем угодно, например: `"PCL = 500ms"`, `"Second trace"`, `"Pinacidil 5uM"`.

`params` -- ровно то же самое, как и для `common` выше.

`filename_phenotype` -- бейзлайн, на котором нужно вычислять loss.

`filename_state` -- начальное условие для **первого поколения** организмов.

---

`experimental conditions` может быть сколько угодно, но не менее одного, не считая `common`.
