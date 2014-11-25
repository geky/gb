#!/usr/bin/env python2

import sys

def main():
    with open(sys.argv[1]) as f:
        data = f.read()

        print "-- Generated dump of %s" % sys.argv[1]

        print "WIDTH=8;"
        print "DEPTH=%s;" % len(data)
        print
        print "ADDRESS_RADIX=HEX;"
        print "DATA_RADIX=HEX;"
        print
        print "CONTENT BEGIN"

        for i,x in enumerate(data):
            print "\t%s\t:\t%s;" % (hex(i)[2:], hex(ord(x))[2:])

        print "END;"
    


if __name__ == "__main__":
    main()
