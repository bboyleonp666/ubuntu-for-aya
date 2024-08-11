# Virtual Environment for aya
This is the virtual environment preparation repository for [aya](https://github.com/aya-rs/aya) development.

# Quick start
Make sure you have docker installed. The following are the available commands that you can use for building an docker image for aya.
```make
# To build a docker image for aya
make

# To start a docker container
make start

# To stop a docker container
make stop

# To remove a stopped container
make remove

# To stop and clean the container
make clean

# To remove the built docker image
make clean-image
```
