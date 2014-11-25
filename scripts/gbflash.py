#!/usr/bin/env python2

import sys
import time

def main():
    assert len(sys.argv) == 5

    start = int(sys.argv[1], 16)
    count = int(sys.argv[2], 16)

    with open(sys.argv[3]) as input:
        data = input.read()

        with open(sys.argv[4], 'r+') as output:
            putword(output, start)
            putword(output, count)

            for x,_ in zip(data, xrange(count)):
                put(output, x)
            


def put(output, x):
    output.write(x)
    c = output.read(1)

    if c != x:
        print "Error detected"
        time.sleep(0.5)

def putword(output, x):
    put(output, chr(0xff & (x >> 24)))
    put(output, chr(0xff & (x >> 16)))
    put(output, chr(0xff & (x >>  8)))
    put(output, chr(0xff & (x      )))


if __name__ == "__main__":
    main()
