# This image is huge and somewhat fully formed
FROM devfactory/workspace-full:latest

# Apt-get large packages
RUN sudo apt-get update -q && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y \
        ffmpeg \
        ;

# Pyenv install multiple versions and packages
RUN ["/bin/bash", "-c", \
  "for pyversion in 3.9-dev 3.10-dev; \
  do \
    pyenv install ${pyversion} && \
    pyenv global ${pyversion} && \
    pip install --upgrade pip && \
    pip install \
        wheel \
        numpy \
        pandas \
        flake8 \
        black \
        matplotlib \
        plotly \
        jupyter \
        ; \
  done"]

# More packages for 3.9 - mostly AWS
# as of 9/30/2022 aws-sam-cli and black conflict over click versions in 3.10
# and aws lambda doesn't support 3.10 yet.
# rip performance/cost savings that might be involved if we could get 3.11
RUN pyenv global 3.9-dev && \
    pip install \
        boto3 \
        aws-sam-cli \
        ;

# More packages for 3.10
RUN pyenv global 3.10-dev && \
    pip install \
        scipy \
        sklearn \
        git+https://github.com/openai/whisper.git \
        git+https://github.com/newmanrs/rpncalc \
        git+https://github.com/newmanrs/youtube-uploader \
        git+https://github.com/newmanrs/neohelper \
        pdf2doi \
        streamlit \
        ;


# Apt-get smaller packages (split from above for docker caching)
RUN sudo apt-get update -q && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y \
        tmux \
        tree \
        pdfgrep \
        ;

# Install my vimrc.
# Modify echo line to invalidate docker cache
RUN echo "Cloning newmanrs/vim" && \
  git clone --recursive https://github.com/newmanrs/vim ~/.vim

# Install .oh-my-zsh (as of 9/30/2022 this also fixes the 
# mangled zsh prompt in image "devfactory/workspace-full:latest")
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.3/zsh-in-docker.sh)" -- \
    -t af-magic
