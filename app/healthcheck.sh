#!/bin/sh

radtest $RADTEST_USER $RADTEST_PASSOWRD $RADTEST_HOST:$RADTEST_PORT 0 $RADTEST_SECRET || exit 1