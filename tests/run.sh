#!/bin/env bash

status='pass'

tests=`ls ieee/*.py`
for test in $tests; do
    echo $test
    `$test`
    if [ $? -ne 0 ]; then
        status='fail'
    fi
done

echo "Status = $status"
