# This image is huge and somewhat fully formed
FROM devfactory/workspace-full:latest

#Apt-get packages
RUN whoami
RUN apt-get update && apt apt-get upgrade && apt-get install -y \
    tmux \
    tree \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*


# Pyenv python versions
RUN ["/bin/bash -c", \
  "for pyversion in 3.9-dev 3.10-dev 3.11-dev 3.12-dev; \
  do \
    pyenv install ${pyversion}; \
    pyenv global ${pyversion}; \
    pip install --upgrade pip; \
    pip install numpy pandas scipy sklearn; \
  done" \
  ]
RUN pyenv global 3.10-dev
