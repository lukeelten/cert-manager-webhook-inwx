#!/usr/bin/env sh
set -eu

K8S_VERSION="${K8S_VERSION:-${KUBEBUILDER_VERSION:-1.29.0}}"
ENVTEST_BIN_DIR="${ENVTEST_BIN_DIR:-$(pwd)/.cache/envtest}"

if ! command -v setup-envtest >/dev/null 2>&1; then
  GOBIN="$(go env GOPATH)/bin" go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest
  PATH="$(go env GOPATH)/bin:${PATH}"
fi

mkdir -p "${ENVTEST_BIN_DIR}"

# Print shell export so caller can eval it
ASSETS_PATH="$(setup-envtest use "${K8S_VERSION}" --bin-dir "${ENVTEST_BIN_DIR}" -p path)"
echo "export KUBEBUILDER_ASSETS=${ASSETS_PATH}"
# cert-manager v1.12 test helpers expect these, remove once we update cert-manager
echo "export TEST_ASSET_ETCD=${ASSETS_PATH}/etcd"
echo "export TEST_ASSET_KUBE_APISERVER=${ASSETS_PATH}/kube-apiserver"
echo "export TEST_ASSET_KUBECTL=${ASSETS_PATH}/kubectl"