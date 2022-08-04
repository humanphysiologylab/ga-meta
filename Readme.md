This document will help you to run Genetic Algorithms (GA) with the Maleckar model.

More detailed documentation is [here](./docs/index.md).

## Download source

I intentionally do not use `git clone`, we need `demo-maleckar` tag.

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

<!-- Репозиторий самих ГА (`pypoptim`) не качаем, это будет дальше. -->

Moreover, we need to copy the configuration file.
```shell
cp configs/config_maleckar.json mpi_scripts/mpi_scripts/voigt/configs    
```

## Docker

I recommend running everything inside the Docker container. You may read [here](https://docs.docker.com/get-docker/) about how to install Docker.

Anyway, you may not use Docker. Then just run commands from the [Dockerfile](./Dockerfile).

```shell
docker build -t ga .

docker run \
    -v "$(pwd)/mpi_scripts":"/home/mpi_scripts" \
    -v "$(pwd)/models_ctypes":"/home/models_ctypes" \
    -it ga
```

All next commands must be run inside the container via terminal.

## Build model
The Maleckar AP model was taken from the CellML ([link](https://models.physiomeproject.org/exposure/bbd802c6a6d6e69b746244f83b4fb89b/maleckar_greenstein_trayanova_giles_2009.cellml/view)). We use LSODA solver to run the model.

```shell
cd /home/models_ctypes/src/models_ctypes/_maleckar
make clean && make
```

## Run

Everything is ready now.

```shell
cd /home/mpi_scripts/mpi_scripts/voigt

# single worker
python3 mpi_script.py configs/config_maleckar.json

# ... or four workers
mpirun -n 4 python3 mpi_script.py configs/config_maleckar.json
```

## Results

Results will be stored in `mpi_scripts/results`. If you use the docker, you may find them in:

```shell
cd  /home/mpi_scripts/results
```

[Notebook](./notebooks/001-Results.ipynb) to load the results.
