#!/usr/bin/env python2

import sys
import re


L = lambda x: x + ", 2'b10"
S = lambda x: x + ", 2'b01"
CC = lambda x: x + ", __CC"
FETCH = L("PC, ADD, PC, 1")
NOP = "0, OR, 0, 0"
STASH = "TEMP, OR, D8, 0"
COND = lambda x: "__COND %s" % x

u = {}
u["NOP_"]       = [ NOP ]
u["STOP0"]      = [] # Halting and prefix instructions
u["PREFIX"]     = [] # are handled externally
u["LD,"]        = [ "{0}, OR, {1}, 0" ]
u["LD2,d16"]    = [ FETCH, NOP, STASH,
                    FETCH, NOP,
                    "{0}, OR, D16, 0" ]
u["LD2(),"]     = [ "DATA, OR, {1}, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["LD2(+),"]    = [ "DATA, OR, {1}, 0",
                    S("{0}, ADD, {0}, 1"), NOP ]
u["LD2(-),"]    = [ "DATA, OR, {1}, 0",
                    S("{0}, SUB, {0}, 1"), NOP ]
u["INC"]        = [ "{0}, ADD~, {0}, 1" ]
u["INC2"]       = u["INC"]
u["INC2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, ADD~, D8, 1",
                    S("0, OR, {0}, 0"), NOP ]
u["DEC"]        = [ "{0}, SUB~, {0}, 1" ]
u["DEC2"]       = u["DEC"]
u["DEC2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, SUB~, D8, 1",
                    S("0, OR, {0}, 0"), NOP ]
u["LD,d8"]      = [ FETCH, NOP,
                    "{0}, OR, D8, 0" ]
u["LD2(),d8"]   = [ FETCH, NOP,
                    "DATA, OR, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["LD2(a16),"]  = [ FETCH, NOP, STASH,
                    FETCH, "DATA, OR, {0}, 0",
                    S("TEMP, ADD, D16, 1"), NOP,
                    "DATA, SWAP2, {0}, 0",
                    S("0, OR, TEMP, 0"), NOP ]
u["ADD2,"]      = [ "{0}, ADD2~, {0}, {1}" ]
u["ADD2,r8"]    = [ FETCH, NOP,
                    "{0}, ADD2~, {0}, D8" ]
u["LD2,()"]     = [ L("0, OR, {1}, 0"), NOP,
                    "{0}, OR, D8, 0" ]
u["LD2,(+)"]    = [ L("{1}, ADD, {1}, 1"), NOP,
                    "{0}, OR, D8, 0" ]
u["LD2,(-)"]    = [ L("{1}, SUB, {1}, 1"), NOP,
                    "{0}, OR, D8, 0" ]
u["JRr8"]       = [ FETCH, NOP,
                    "PC, ADD, PC, D8" ]
u["JR,r8"]      = [ COND(1) ] + u["JRr8"]
u["DAA_"]       = [ "A, DAA~, A, 0" ]
u["CPL_"]       = [ "A, CPL~, A, 0" ]
u["SCF_"]       = [ "0, OR~, 0, 0" ]
u["CCF_"]       = [ "0, OR~, 0, 0" ]
u["HALT_"]      = [ "PC, SUB, PC, 1" ]
u["ADD,"]       = [ "{0}, ADD~, {0}, {1}" ]
u["ADD2,()"]    = [ L("0, OR, {1}, 0"), NOP,
                    "{0}, ADD~, {0}, D8" ]
u["ADD,d8"]     = [ FETCH, NOP,
                    "{0}, ADD~, {0}, D8" ]
u["ADC,"]       = [ "{0}, ADC~, {0}, {1}" ]
u["ADC2,()"]    = [ L("0, OR, {1}, 0"), NOP,
                    "{0}, ADC~, {0}, D8" ]
u["ADC,d8"]     = [ FETCH, NOP,
                    "{0}, ADC~, {0}, D8" ]
u["SUB"]        = [ "A, SUB~, A, {0}" ]
u["SUB2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "A, SUB~, A, D8" ]
u["SUBd8"]      = [ FETCH, NOP,
                    "A, SUB~, A, D8" ]
u["SBC,"]       = [ "{0}, SBC~, {0}, {1}" ]
u["SBC2,()"]    = [ L("0, OR, {1}, 0"), NOP,
                    "{0}, SBC~, {0}, D8" ]
u["SBC,d8"]     = [ FETCH, NOP,
                    "{0}, SBC~, {0}, D8" ]
u["AND"]        = [ "A, AND~, A, {0}" ]
u["AND2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "A, AND~, A, D8" ]
u["ANDd8"]      = [ FETCH, NOP,
                    "A, AND~, A, D8" ]
u["XOR"]        = [ "A, XOR~, A, {0}" ]
u["XOR2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "A, XOR~, A, D8" ]
u["XORd8"]      = [ FETCH, NOP,
                    "A, XOR~, A, D8" ]
u["OR"]         = [ "A, OR~, A, {0}" ]
u["OR2()"]      = [ L("0, OR, {0}, 0"), NOP,
                    "A, OR~, A, D8" ]
u["ORd8"]       = [ FETCH, NOP,
                    "A, OR~, A, D8" ]
u["CP"]         = [ "0, SUB~, A, {0}" ]
u["CP2()"]      = [ L("0, OR, {0}, 0"), NOP,
                    "0, SUB~, A, D8" ]
u["CPd8"]       = [ FETCH, NOP,
                    "0, SUB~, A, D8" ]
u["RET_"]       = [ L("SP, ADD, SP, 1"), NOP, STASH,
                    L("SP, ADD, SP, 1"), NOP,
                    "PC, OR, D16, 0" ]
u["RET"]        = [ COND(0) ] + u["RET_"]
u["POP2"]       = [ L("SP, ADD, SP, 1"), NOP, STASH,
                    L("SP, ADD, SP, 1"), NOP,
                    "{0}, OR~, D16, 0" ]
u["PUSH2"]      = [ "SP, SUB, SP, 1",
                    "DATA, SWAP2, {0}, 0",
                    S("SP, SUB, SP, 1"), NOP,
                    "DATA, OR, {0}, 0",
                    S("0, OR, SP, 0"), NOP ]
u["JPa16"]      = [ FETCH, NOP, STASH,
                    FETCH, NOP,
                    "PC, OR, D16, 0" ]
u["JP,a16"]     = [ COND(2) ] + u["JPa16"]
u["JP2()"]      = [ "PC, OR, {0}, 0" ] 
u["CALLa16"]    = [ "TEMP, ADD, PC, 2",
                    "SP, SUB, SP, 1",
                    "DATA, SWAP2, TEMP, 0",
                    S("SP, SUB, SP, 1"), NOP,
                    "DATA, OR, TEMP, 0",
                    S("0, OR, SP, 0"), NOP,
                    FETCH, NOP, STASH,
                    FETCH, NOP,
                    "PC, OR, D16, 0" ]
u["CALL,a16"]   = [ COND(2) ] + u["CALLa16"]
u["LDH(a8),"]   = [ FETCH, NOP,
                    "TEMP, OR, MASK, D8",
                    "DATA, OR, {0}, 0",
                    S("0, OR, TEMP, 0"), NOP ] 
u["LDH,(a8)"]   = [ FETCH, NOP,
                    "TEMP, OR, MASK, D8",
                    L("0, OR, TEMP, 0"), NOP,
                    "{0}, OR, D8, 0" ]
u["LD(a16),"]   = [ FETCH, NOP, STASH,
                    FETCH, "DATA, OR, {0}, 0",
                    S("0, OR, D16, 0"), NOP ] 
u["LD,(a16)"]   = [ FETCH, NOP, STASH,
                    FETCH, NOP,
                    L("0, OR, D16, 0"), NOP,
                    "{0}, OR, D8, 0" ]
u["LD(),"]      = [ "TEMP, OR, MASK, {0}",
                    "DATA, OR, {1}, 0",
                    S("0, OR, TEMP, 0"), NOP ] 
u["LD,()"]      = [ "TEMP, OR, MASK, {1}",
                    L("0, OR, TEMP, 0"), NOP,
                    "{0}, OR, D8, 0" ]
u["LD2,+r8"]    = [ FETCH, NOP,
                    "{0}, ADD2~, {1}, D8" ]
u["LD2,"]       = [ "{0}, OR, {1}, 0" ]
u["RLCA_"]      = [ "A, RLC~, A, 0" ]
u["RLC"]        = [ "{0}, RLC~, {0}, 0" ]
u["RLC2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, RLC~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["RLA_"]       = [ "A, RL~, A, 0" ]
u["RL"]         = [ "{0}, RL~, {0}, 0" ]
u["RL2()"]      = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, RL~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["RRCA_"]      = [ "A, RRC~, A, 0" ]
u["RRC2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, RRC~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["RRC"]        = [ "{0}, RRC~, {0}, 0" ]
u["RRA_"]       = [ "A, RR~, A, 0" ]
u["RR"]         = [ "{0}, RR~, {0}, 0" ]
u["RR2()"]      = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, RR~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["SLA"]        = [ "{0}, SLA~, {0}, 0" ]
u["SLA2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, SLA~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["SRA"]        = [ "{0}, SRA~, {0}, 0" ]
u["SRA2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, SRA~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["SRL"]        = [ "{0}, SRL~, {0}, 0" ]
u["SRL2()"]     = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, SRL~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]
u["SWAP"]       = [ "{0}, SWAP~, {0}, 0" ]
u["SWAP2()"]    = [ L("0, OR, {0}, 0"), NOP,
                    "DATA, SWAP~, D8, 0",
                    S("0, OR, {0}, 0"), NOP ]

BIT = lambda b:   [ "0, AND~, {0}, %s" % hex(1 << b)[2:] ]
BIT2 = lambda b:  [ L("0, OR, {0}, 0"), NOP,
                    "0, AND~, D8, %s" % hex(1 << b)[2:] ]
u["BIT0,"]      = BIT(0)
u["BIT1,"]      = BIT(1)
u["BIT2,"]      = BIT(2)
u["BIT3,"]      = BIT(3)
u["BIT4,"]      = BIT(4)
u["BIT5,"]      = BIT(5)
u["BIT6,"]      = BIT(6)
u["BIT7,"]      = BIT(7)
u["BIT20,()"]   = BIT2(0)
u["BIT21,()"]   = BIT2(1)
u["BIT22,()"]   = BIT2(2)
u["BIT23,()"]   = BIT2(3)
u["BIT24,()"]   = BIT2(4)
u["BIT25,()"]   = BIT2(5)
u["BIT26,()"]   = BIT2(6)
u["BIT27,()"]   = BIT2(7)

RES = lambda b:   [ "{0}, AND, {0}, %s" % hex(0xff & ~(1 << b))[2:] ]
RES2 = lambda b:  [ L("0, OR, {0}, 0"), NOP,
                    "DATA, AND, D8, %s" % hex(0xff & ~(1 << b))[2:],
                    S("0, OR, {0}, 0"), NOP ]
u["RES0,"]      = RES(0)
u["RES1,"]      = RES(1)
u["RES2,"]      = RES(2)
u["RES3,"]      = RES(3)
u["RES4,"]      = RES(4)
u["RES5,"]      = RES(5)
u["RES6,"]      = RES(6)
u["RES7,"]      = RES(7)
u["RES20,()"]   = RES2(0)
u["RES21,()"]   = RES2(1)
u["RES22,()"]   = RES2(2)
u["RES23,()"]   = RES2(3)
u["RES24,()"]   = RES2(4)
u["RES25,()"]   = RES2(5)
u["RES26,()"]   = RES2(6)
u["RES27,()"]   = RES2(7)

SET = lambda b:   [ "{0}, OR, {0}, %s" % hex(1 << b)[2:] ]
SET2 = lambda b:  [ L("0, OR, {0}, 0"), NOP,
                    "DATA, OR, D8, %s" % hex(1 << b)[2:],
                    S("0, OR, {0}, 0"), NOP ]
u["SET0,"]      = SET(0)
u["SET1,"]      = SET(1)
u["SET2,"]      = SET(2)
u["SET3,"]      = SET(3)
u["SET4,"]      = SET(4)
u["SET5,"]      = SET(5)
u["SET6,"]      = SET(6)
u["SET7,"]      = SET(7)
u["SET20,()"]   = SET2(0)
u["SET21,()"]   = SET2(1)
u["SET22,()"]   = SET2(2)
u["SET23,()"]   = SET2(3)
u["SET24,()"]   = SET2(4)
u["SET25,()"]   = SET2(5)
u["SET26,()"]   = SET2(6)
u["SET27,()"]   = SET2(7)

u["RETI_"]      = [ L("SP, ADD, SP, 1"), NOP, STASH,
                    L("SP, ADD, SP, 1"), NOP,
                    "PC, OR, D16, 0",
                    "IE, OR, 1, 0" ]
u["DI_"]        = [ "IE, OR, 0, 0" ]
u["EI_"]        = [ "IE, OR, 1, 0" ]

RST = lambda r:   [ "TEMP, SUB, PC, 1",
                    "SP, SUB, SP, 1",
                    "DATA, SWAP2, TEMP, 0",
                    S("SP, SUB, SP, 1"), NOP,
                    "DATA, OR, TEMP, 0",
                    S("0, OR, SP, 0"), NOP,
                    "PC, OR, %s, 0" % r ]
u["RST00"]      = RST("0")
u["RST08"]      = RST("8")
u["RST10"]      = RST("10")
u["RST18"]      = RST("18")
u["RST20"]      = RST("20")
u["RST28"]      = RST("28")
u["RST30"]      = RST("30")
u["RST38"]      = RST("38")



CATS = "\\b(AF|BC|DE|HL|SP|PC)\\b"
CC = {"NZ": ("4'b0xxx", "4'b1xxx"),
      "NC": ("4'bxxx0", "4'bxxx1"),
      "Z":  ("4'b1xxx", "4'b0xxx"),
      "C":  ("4'bxxx1", "4'bxxx0")}

GCOND = "D_UC, OR, A_UC, B_F, 2'b00, CC_xxxx"
GNOP = "D_0, OR, A_0, B_0, 2'b00, CC_xxxx"
GSKIP = lambda x: "D_PC, ADD, A_PC, B_%s, 2'b00, CC_xxxx" % x


def main():
    names = None
    ops = None
    cycles = None
    flags = None

    opset = int(sys.argv[1].strip())

    with open(sys.argv[2]) as f:
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

                gen.append(("\t16'h%s%s: ucode <= {{16'h003%s, " % 
                            (num, hex(i)[2:], hex(conds)[2:])) + GCOND + "}};")
                gen.append(("\t{{%s, 12'h3%s}}: ucode <= {{16'h%s%s, " %
                            (t, hex(conds)[2:], num, hex(i+2)[2:])) + GNOP + "}};")
                gen.append(("\t{{%s, 12'h3%s}}: ucode <= {{__END, " %
                            (f, hex(conds)[2:])) + 
                           (GNOP if skip == 0 else GSKIP(skip)) + "}};")

                i += 2
                conds += 1

                if i+3 < cycles[x][2]:
                    state = "16'h004%s" % (hex(cycles[x][2]-(i+3))[2:])
                    gen[-1] = gen[-1].replace("__END", state)
                else:
                    gen[-1] = gen[-1].replace("__END", "16'h0000")

                continue

            a = [a.strip() for a in line.split(",")]
            a[0] = "D_" + a[0]
            a[2] = "A_" + a[2]
            a[3] = "B_" + a[3]
            if len(a) < 5:
                a.append("2'b00")

            if "~" in a[1]:
                a.append(cc)
                a[1] = a[1][:-1]
            else:
                a.append("CC_xxxx")

            res = ("\t16'h%s%s: ucode <= {{__NEXT, %s}};" % 
                (num, hex(i)[2:], ", ".join(a)))

            if ni < len(out)-1:
                res = res.replace("__NEXT", "16'h%s%s" % (num, hex(i+1)[2:]))
            elif ni == len(out)-1:
                res = res.replace("__NEXT", "__END")

            gen.append(res)
            i += 1

        # cycle count includes 3 for fetch
        gen = "\n".join(gen)
        gen = gen.format(*op[1:])

        if i+3 < cycles[x][1]:
            state = "16'h004%s" % (hex(cycles[x][1]-(i+3))[2:])
            gen = gen.replace("__END", state)
        elif i+3 == cycles[x][1]:
            gen = gen.replace("__END", "16'h0000")
        else:
            assert False, "Too many cycles :("

        if cc != "CC_xxxx" and cc not in gen:
            assert False, "Condition codes not set :("

        print gen

if __name__ == "__main__":
    main()
