#!/usr/bin/env bash

set -eux

export ANSIBLE_CALLBACK_PLUGINS=../../support-callback_plugins/callback_plugins
export ANSIBLE_ROLES_PATH=../../
export ANSIBLE_STDOUT_CALLBACK=callback_debug

for testcase in */; do
    echo "Testing $testcase"
    pushd "$testcase"
    # Execute in a subshell to isolate environment variables
    (
        if [[ -f env-vars ]]; then
            source env-vars
        fi
        ansible-playbook test.yml 2>/dev/null | sort | uniq -c | tee callbacks_list.out
    )
    diff -w callbacks_list.out callbacks_list.expected
    popd
done
