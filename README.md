# Virtual Environment for aya
This is the virtual environment preparation repository for [aya](https://github.com/aya-rs/aya) development.

# Quick start
The following are the available commands that you can use for building an docker image for aya.
1. Clone this repo: 
    ```shell
    $ git clone --recursive https://github.com/bboyleonp666/ubuntu-for-aya.git
    ```

2. Build docker images and run
    ```shell
    # To build
    $ docker compose build

    # To start
    $ docker compose up -d

    # To attach to a target docker container
    $ docker compose attach aya

    # To stop and remove
    $ docker compose down
    ```
