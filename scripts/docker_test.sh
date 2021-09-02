#!/bin/bash

# Run make install
{
    cd /src
    make install
}

exec /bin/bash -l
