# How to

Этот документ о том, как запустить генетические алгоритмы на модели Малекар.
Подробности, как работает сам код, можно прочитать [здесь](./docs/index.md).

## Download source

Во-первых, надо склонировать текущий репозиторий и зайти в него.
```shell
git clone git@github.com:humanphysiologylab/ga-meta.git
cd ga-meta
```

Скачиваем репозитории с кодом. Я специально не делаю `git clone`. Нужный тэг -- `demo-maleckar`.

```shell
# mpi_scripts
wget https://github.com/humanphysiologylab/mpi_scripts/archive/refs/tags/demo-maleckar.zip
unzip demo-maleckar.zip
rm demo-maleckar.zip
mv mpi_scripts-demo-maleckar mpi_scripts

# models_ctypes
wget https://github.com/humanphysiologylab/models_ctypes/archive/refs/tags/demo-maleckar.zip
unzip demo-maleckar.zip
rm demo-maleckar.zip
mv models_ctypes-demo-maleckar models_ctypes

```

Репозиторий самих ГА (`pypoptim`) не качаем, это будет дальше.

Ещё нам нужен конфиг.
```shell
cp configs/config_maleckar.json mpi_scripts/mpi_scripts/voigt/configs    
```

## Docker

Я купил мак на M1, а с ним есть проблемы с библиотеками. Поэтому я сделал Docker контейнер, в котором запускается расчет. Так или иначе, Docker классная штука, советую. Как установить докер, читать [тут](https://docs.docker.com/get-docker/).

Можно и без Docker, тогда просто нужно выполнить все команды из [Dockerfile](./Dockerfile).

```shell
docker build -t ga .

docker run \
    -v "$(pwd)/mpi_scripts":"/home/mpi_scripts" \
    -v "$(pwd)/models_ctypes":"/home/models_ctypes" \
    -it ga
```

Далее всё делается в самом контейнере (последней командой должен был открыться терминал). И `pypoptim` был установлен прямо в контейнер.

## Build model
Модель Maleckar была взята с CellML в C-варианте. Солвер для неё -- LSODA.

```shell
cd /home/models_ctypes/src/models_ctypes/_maleckar
make clean && make
```

## Run

Теперь всё готово для запуска.

```shell
cd /home/mpi_scripts/mpi_scripts/voigt

# single worker
python3 mpi_script.py configs/config_maleckar.json

# four workers
mpirun -n 4 python3 mpi_script.py configs/config_maleckar.json
```

## Results

Результаты расчета будут лежать в `mpi_scripts/results`. Если вы ещё в контейнере, то к ним можно прийти так: 
```shell
cd  /home/mpi_scripts/results
```
Посмотреть на цифры можно, например, [в этом ноутбуке](./notebooks/001-Results.ipynb).
