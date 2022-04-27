FROM ubuntu

RUN apt -y update && apt -y install \
    git \
    python3 python3-pip python3-dev \
    # python3-venv \
    gcc make mpich
    
WORKDIR /home

COPY requirements.txt .

# RUN python3 -m venv .venv
# RUN . .venv/bin/activate

RUN pip install git+https://github.com/humanphysiologylab/pypoptim.git
RUN pip install -r requirements.txt
