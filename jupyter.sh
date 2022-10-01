port=8888
url=$(echo $GITPOD_WORKSPACE_URL | sed s/${GITPOD_WORKSPACE_ID}/${port}-${GITPOD_WORKSPACE_ID}/)
jupyter notebook --NotebookApp.allow_origin=$url --port=$port
