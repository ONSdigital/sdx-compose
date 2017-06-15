PREFIX="sdx-"
REPOS="common" "rabbit-monitor" "ops" "collect" "decrypt" "validate" "receipt-rrm" "receipt-ctp" "store" "transform-cs" "transform-cora" "downstream" "downstream-cora" "downstream-ctp" "sequence" "bdd" "mock-receipt" "console" "transform-testform"

NO_COLOR=\033[0m
GREEN=\033[32;01m
RED=\033[31;01m
YELLOW=\033[33;22m

all: full check-env clone build

full:
	@ printf "\n[${GREEN} Running full build. Please be patient this may take awhile! ${NO_COLOR}]\n"

check-env:
ifndef SDX_HOME
	$(error SDX_HOME environment variable is not set.)
endif
ifndef PYTHON3
	$(error PYTHON3 variable should point to the python binary in your dev virtual environment.)
endif
	@ printf "\n[${YELLOW} SDX_HOME set to ${SDX_HOME} ${NO_COLOR}]\n"
	@ printf "\n[${YELLOW} PYTHON3 set to ${PYTHON3} ${NO_COLOR}]\n"
	BIN=$(shell dirname ${PYTHON3})

clone: check-env
	@ printf "\n[${YELLOW} Cloning into ${SDX_HOME} ${NO_COLOR}]\n"
	@ for r in ${REPOS}; do \
		echo "(${PREFIX}$${r})"; \
		if [ ! -e ${SDX_HOME}/${PREFIX}$${r} ]; then \
			git clone git@github.com:ONSdigital/${PREFIX}$${r}.git ${SDX_HOME}/${PREFIX}$${r}; \
		else \
			echo "  - already exists: skipping"; \
		fi; echo ""; \
	done

start:
	@ printf "\n[${YELLOW} Bringing up docker compose ${NO_COLOR}]\n"
	docker-compose up

build: check-env clone
	@ printf "\n[${GREEN} Generating environment variables... ${NO_COLOR}]\n"
	cd ${SDX_HOME}/sdx-common && ${BIN}/pip install .; cd -
	cd ${SDX_HOME}/sdx-ops && ${PYTHON3} sdx/ops/configure.py --env > ${SDX_HOME}/sdx-compose/env/private.env ;cd -
	@ printf "\n[${YELLOW} Refreshing build ${NO_COLOR}]\n"
	docker-compose build
