#!/usr/bin/env python2

import sys
import time

def main():
    assert len(sys.argv) == 5

    start = int(sys.argv[1], 16)
    count = int(sys.argv[2], 16)

    with open(sys.argv[3], 'rb') as input:
        data = input.read()[:count]

        with open(sys.argv[4], 'wb') as dev:
            putword(dev, start)
            putword(dev, count)

            for x in data:
                put(dev, x)


def put(dev, x):
    dev.write(x)

def putword(dev, x):
    put(dev, chr(0xff & (x >> 24)))
    put(dev, chr(0xff & (x >> 16)))
    put(dev, chr(0xff & (x >>  8)))
    put(dev, chr(0xff & (x      )))


if __name__ == "__main__":
    main()
