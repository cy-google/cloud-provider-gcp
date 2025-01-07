#!/usr/bin/env bash

# Copyright 2022 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

REPO_ROOT=$(git rev-parse --show-toplevel)
cd ${REPO_ROOT}
cd ..
WORKSPACE=$(pwd)

# Set up go workspace to build with this version
cd "${REPO_ROOT}"

go work init

go work use .
go work use providers

# Add kubernetes to workspace
go work use ${WORKSPACE}/kubernetes
for d in ${WORKSPACE}/kubernetes/staging/src/k8s.io/*; do
  go work use $d
done

# Workaround for go.mod replacements
sed -i 's/^\s*k8s.io.*//g' go.mod
go work sync