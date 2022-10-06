#!/bin/bash

atlantis server \
--atlantis-url="http://${ATLANTIS_HOST}:4141" \
--gitlab-user="${USERNAME}" \
--gitlab-token="${TOKEN}" \
--gitlab-webhook-secret="${SECRET}" \
--repo-allowlist="${GIT_HOST}/${USERNAME}/${REPOSITORY}"