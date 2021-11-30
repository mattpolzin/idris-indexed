
IDRIS2 ?= idris2
PACKAGE = tests.ipkg
INTERACTIVE ?= --interactive

.PHONY: build test

build :
	$(IDRIS2) --build ${PACKAGE}

test : build
	./build/exec/test ${IDRIS2} ${INTERACTIVE}
