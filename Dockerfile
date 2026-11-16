FROM python:3.8-slim

# compilers for nes-py and box2d; virtual display + OpenGL for CarRacing
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential swig xvfb xauth libgl1 libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# old tooling pinned so gym 0.21 can install at all
RUN pip install --no-cache-dir "pip<24.1" "setuptools==65.5.0" "wheel<0.40"

# working set of versions (replaces the broken requirements.txt)
RUN pip install --no-cache-dir \
        "gym==0.21.0" "numpy==1.21.6" "box2d-py==2.3.5" \
        "Flask==2.0.3" "Werkzeug==2.0.3" "itsdangerous==2.0.1" \
        "Jinja2==3.0.3" "MarkupSafe==2.0.1" \
        six requests nes-py gym-super-mario-bros

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential swig xvfb xauth libgl1 libglu1-mesa \
        libfontconfig1 libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# choose the server at run time: gym_http_server.py / mario_server.py /
# clear_mario_server.py / car_racing_server.py
ENV SERVER=gym_http_server.py
EXPOSE 5000
CMD xvfb-run -a python $SERVER -l 0.0.0.0 -p 5000