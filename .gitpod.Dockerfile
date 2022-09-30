# This image is huge and somewhat fully formed
FROM devfactory/workspace-full:latest

# Apt-get packages
#RUN sudo apt-get update -q && \
#    sudo apt-get upgrade -y && \
#    sudo apt-get install -y \
#        tmux \
#        tree \
#        ffmpeg

# Pyenv python versions.  Install large packages.
RUN ["/bin/bash", "-c", \
  "for pyversion in 3.10-dev; \
  do \
    pyenv install ${pyversion}; \
    pyenv global ${pyversion}; \
    pip install --upgrade pip; \
    pip install \
        wheel \
        numpy \
        pandas \
        flake8 \
        black \
        boto3 \
        ; \
  done"]

# More packages targetting default vers
RUN pyenv global 3.10-dev && \
    pip install \
        scipy \
        sklearn \
        git+https://github.com/openai/whisper.git \
        git+https://github.com/newmanrs/rpncalc \
        git+https://github.com/newmanrs/youtube-uploader
