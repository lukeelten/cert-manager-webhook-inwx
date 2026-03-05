GO ?= $(shell which go)
OS ?= $(shell $(GO) env GOOS)
ARCH ?= $(shell $(GO) env GOARCH)

IMAGE_NAME := "webhook"
IMAGE_TAG := "latest"

OUT := $(shell pwd)/_out

KUBEBUILDER_VERSION ?= 1.29.0

.PHONY: test
test:
	@if [ -z "$(TEST_ZONE_NAME)" ] || [ -z "$(TEST_ZONE_NAME_WITH_TWO_FA)" ]; then \
		echo "TEST_ZONE_NAME and TEST_ZONE_NAME_WITH_TWO_FA must be set (see README)."; \
		exit 1; \
	fi
	@eval "$$(K8S_VERSION=$(KUBEBUILDER_VERSION) ./scripts/fetch-test-binaries.sh)" && \
	TEST_ZONE_NAME="$(TEST_ZONE_NAME)" \
	TEST_ZONE_NAME_WITH_TWO_FA="$(TEST_ZONE_NAME_WITH_TWO_FA)" \
    $(GO) test -cover .

.PHONY: build
build:
	docker build -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

