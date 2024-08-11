# compile
MAKE := make

# container
IMAGE := ubuntu
TAG := aya
CONTAINER_NAME := ubuntu-aya
# LLVM
LLVM_VERSION := 18

ifeq ($(V),1)
  Q =
else
  Q = @
endif

.PHONY: all build clean start stop remove remove-image

all: build

clean: stop remove

build:
	$(Q)docker build --build-arg LLVM_VERSION=$(LLVM_VERSION) -t $(IMAGE):$(TAG) .

start:
	$(Q)docker run -it --name $(CONTAINER_NAME) $(IMAGE):$(TAG)

stop:
	$(Q)docker stop $(CONTAINER_NAME) 2>&1 > /dev/null
	$(Q)echo "Successfully stopped container '$(CONTAINER_NAME)'"

remove:
	$(Q)docker rm $(CONTAINER_NAME) 2>&1 > /dev/null
	$(Q)echo "Successfully removed container '$(CONTAINER_NAME)'"

remove-image:
	$(Q)docker rmi $(IMAGE):$(TAG)
