FROM devfactory/workspace-full:latest

RUN pyenv install 3.10-dev
RUN pyenv global 3.10-dev
