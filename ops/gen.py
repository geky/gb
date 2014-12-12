#!/usr/bin/env python2

import sys
import re


CATS = "\\b(AF|BC|DE|HL|SP|PC)\\b"
CC = {"NZ": ("4'b0xxx", "4'b1xxx"),
      "NC": ("4'bxxx0", "4'bxxx1"),
      "Z":  ("4'b1xxx", "4'b0xxx"),
      "C":  ("4'bxxx1", "4'bxxx0")}

GCOND = "D_UC, OR, A_UC, B_F, 2'b00, CC_xxxx"
GNOP = "D_0, OR, A_0, B_0, 2'b00, CC_xxxx"
GSKIP = lambda x: "D_PC, ADD, A_PC, B_%s, 2'b00, CC_xxxx" % x


def getbus(bus):
    u = {"COND": ["__COND %0"]}
    optypes = []

    for l in bus.splitlines():
        l = re.sub('#.*', '', l).rstrip()

        if l:
            if l[0] == ' ':
                optypes[-1] += ',' + l.lstrip()
            else:
                optypes.append(l)

    for t in optypes:
        ops = t[12:].split(',')
        res = []

        for p in (p.strip().split(' ') for p in ops):
            if len(p) == 1:
                m = re.split('[()]', p[0])
                if len(m) > 1:
                    res += [i.replace('%0', m[1]) for i in u[m[0]]]
                elif m[0]:
                    res += u[m[0]]
            else:
                assert len(p) == 4, "Not enough bus assignments"
                res.append(' '.join(p))

        u[t[:12].rstrip()] = res

    return u

def main():
    assert len(sys.argv) == 4

    opset = int(sys.argv[1])

    u = None

    with open(sys.argv[2]) as f:
        u = getbus(f.read())

    names = None
    ops = None
    cycles = None
    flags = None

    with open(sys.argv[3]) as f:
        data = [a.strip() for a in f.read().splitlines()]
        names = data[0::3]
        cycles = [[int(c)-4*(opset-1) for c in re.findall('[0-9]+', a)] 
                  for a in data[1::3]]
        flags = data[2::3]
        ops = [re.findall('[A-Z]+', a) for a in names]
        cats = [re.findall(CATS, a) for a in names]
        mods = [re.findall('[(),a-z0-9+-]', a) for a in names]

        for o,c,m in zip(ops,cats,mods):
            if c: o[0] += '2'
            if not o[1:] and not c and not m: o[0] += '_'
            o[0] += ''.join(m)

    conds = 0
       
    for x,op in enumerate(ops):
        out = u[op[0]]
        gen = ["\t// %s" % names[x]]
        num = hex(0x100 + x)[3:] + hex(opset)[2:]

        cc = "CC_" + "".join(flags[x].split()).replace("-", "x")

        i = 0
        for ni,line in enumerate(out):
            if "__COND" in line:
                skip = int(line.split()[1])
                (t,f) = CC[op[1]]

                gen.append(("\t16'h%s%s: ucode <= {16'h003%s, " % 
                            (num, hex(i)[2:], hex(conds)[2:])) + GCOND + "};")
                gen.append(("\t{%s, 12'h3%s}: ucode <= {16'h%s%s, " %
                            (t, hex(conds)[2:], num, hex(i+2)[2:])) + GNOP + "};")
                gen.append(("\t{%s, 12'h3%s}: ucode <= {__END, " %
                            (f, hex(conds)[2:])) + 
                           (GNOP if skip == 0 else GSKIP(skip)) + "};")

                i += 2
                conds += 1

                if i+3 < cycles[x][2]:
                    state = "16'h004%s" % (hex(cycles[x][2]-(i+3))[2:])
                    gen[-1] = gen[-1].replace("__END", state)
                else:
                    gen[-1] = gen[-1].replace("__END", "16'h0000")

                continue

            a = [a.strip() for a in line.split()]
            a[0] = "D_" + a[0]
            a[2] = "A_" + a[2]
            a[3] = "B_" + a[3]

            if a[1][-1] == "s":
                a.append("2'b01")
                a[1] = a[1][:-1]
            elif a[1][-1] == "l":
                a.append("2'b10")
                a[1] = a[1][:-1]
            else:
                a.append("2'b00")

            if a[1][-1] == "~":
                a.append(cc)
                a[1] = a[1][:-1]
            else:
                a.append("CC_xxxx")

            res = ("\t16'h%s%s: ucode <= {__NEXT, %s};" % 
                (num, hex(i)[2:], ", ".join(a)))

            if ni < len(out)-1:
                res = res.replace("__NEXT", "16'h%s%s" % (num, hex(i+1)[2:]))
            elif ni == len(out)-1:
                res = res.replace("__NEXT", "__END")

            gen.append(res)
            i += 1

        # cycle count includes 3 for fetch
        gen = "\n".join(gen)
        if len(op) > 1: gen = gen.replace('$0', op[1])
        if len(op) > 2: gen = gen.replace('$1', op[2])

        if i+3 < cycles[x][1]:
            state = "16'h004%s" % (hex(cycles[x][1]-(i+3))[2:])
            gen = gen.replace("__END", state)
        elif i+3 == cycles[x][1]:
            gen = gen.replace("__END", "16'h0000")
        else:
            assert False, "Too many cycles :("

        if cc != "CC_xxxx" and cc not in gen:
            # this now occurs in ccf
            #assert False, "Condition codes not set :("
            pass

        print gen

if __name__ == "__main__":
    main()
