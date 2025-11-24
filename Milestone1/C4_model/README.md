# C4 Model Structurizr Workspace

To run open the workspace with structurizr run the following command, using this `C4_Model` subdirectory as `PATH`.

```sh
docker pull structurizr/lite # if not pulled yet
docker run -it --rm -p 8080:8080 -v {PATH}:/usr/local/structurizr structurizr/lite
```

Then open up `localhost:8080` to view the structurizr diagrams and documentation.

