
IDRIS2 ?= idris2
PACKAGE = indexed.ipkg

.PHONY: build clean install test

build/ttc : src/**/*.idr
	$(IDRIS2) --build ${PACKAGE}

build : build/ttc

clean :
	rm -rf ./build

install : build/ttc
	$(IDRIS2) --install ${PACKAGE}

install-with-src : build/ttc
	$(IDRIS2) --install-with-src ${PACKAGE}

test : install
	$(MAKE) -C ./tests test

