CC := gcc
CFLAGS := -Wall
PROGRAMA := scanner2

all: $(PROGRAMA)

$(PROGRAMA): scanner2.l
	flex scanner2.l
	$(CC) $(CFLAGS) lex.yy.c -o $(PROGRAMA)

clean:
	rm -f $(PROGRAMA) lex.yy.c

.PHONY: all clean