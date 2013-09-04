
.PHONY: all clean

all:
	bin/sbt package-dist

clean:
	bin/sbt clean