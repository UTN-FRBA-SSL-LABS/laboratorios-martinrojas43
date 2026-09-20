CC := gcc
CFLAGS := -Wall
PROGRAMA := calc3

all: $(PROGRAMA)

$(PROGRAMA): parser3.y scanner3.l
	bison -d parser3.y
	flex scanner3.l
	$(CC) $(CFLAGS) parser3.tab.c lex.yy.c -o $(PROGRAMA)

clean:
	rm -f $(PROGRAMA) parser3.tab.c parser3.tab.h lex.yy.c

.PHONY: all clean
