PREFIX="sdx-"
REPOS="ops" "collect" "decrypt" "validate" "receipt-rrm" "receipt-ctp" "store" "transform-cs" "downstream" "downstream-cora" "downstream-ctp" "sequence" "bdd" "mock-receipt" "console" "transform-testform"

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

clone:
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

build:
	@ printf "\n[${GREEN} Generating environment variables... ${NO_COLOR}]\n"
	cd ${SDX_HOME}/sdx-ops && ${PYTHON3} -m sdx.ops.configure --env > ${SDX_HOME}/sdx-compose/env/private.env ;cd -
	@ printf "\n[${YELLOW} Refreshing build ${NO_COLOR}]\n"
	docker-compose build
