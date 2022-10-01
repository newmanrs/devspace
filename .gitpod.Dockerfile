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
        matplotlib \
        plotly \
        jupyter \
        boto3 \
        ; \
  done"]

# More packages for 3.9 - mostly AWS
RUN pyenv global 3.9-dev && \
    pip install \
        aws-sam-cli \
        ;

# More packages for 3.10 only
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
        black \
        dash \
        ;


# Apt-get smaller packages (split from above for docker caching)
RUN sudo apt-get update -q && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y \
        tmux \
        tree \
        pdfgrep \
        ;

# Install my vimrc and tmux conf
RUN echo "Installing vim and tmux" && \
  git clone --recursive https://github.com/newmanrs/vim ~/.vim && \
  wget https://raw.githubusercontent.com/newmanrs/dotfiles/main/.tmux.conf -P ${HOME} \
  ;


# Install .oh-my-zsh (as of 9/30/2022 this also fixes the 
# mangled zsh prompt in image "devfactory/workspace-full:latest")
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.3/zsh-in-docker.sh)" -- \
    -t af-magic \
    ;
