
IDRIS2 ?= idris2
PACKAGE = indexed.ipkg

.PHONY: build clean install

build :
	$(IDRIS2) --build ${PACKAGE}

clean :
	rm -rf ./build

install :
	$(IDRIS2) --install ${PACKAGE}
