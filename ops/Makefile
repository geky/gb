
all: genops.txt gencbops.txt

genops.txt: gen.py z80.bus ops.txt
	./gen.py 1 z80.bus ops.txt > genops.txt

gencbops.txt: gen.py z80.bus cbops.txt
	./gen.py 2 z80.bus cbops.txt > gencbops.txt
