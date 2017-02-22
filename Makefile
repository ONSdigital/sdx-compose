PREFIX="sdx-"
REPOS="ops" "collect" "decrypt" "validate" "receipt-rrm" "receipt-ctp" "store" "transform-cs" "transform-cora" "downstream" "downstream-cora" "downstream-ctp" "sequence" "mock-receipt" "console" "transform-testform"

NO_COLOR=\033[0m
GREEN=\033[32;01m
RED=\033[31;01m
YELLOW=\033[33;22m

CLONE_FROM="git@github.com:ONSdigital"
ifdef USE_HTTPS
	CLONE_FROM="https://github.com/ONSdigit"
endif

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
			git clone ${CLONE_FROM}/${PREFIX}$${r}.git ${SDX_HOME}/${PREFIX}$${r}; \
			printf "\n[${YELLOW} Updating Dockerfile ${NO_COLOR}]\n"; \
			sed -i.bak '/FROM / a\'$$'\n''ADD pip.conf /etc/pip.conf' "${SDX_HOME}/${PREFIX}$${r}/Dockerfile"; \
			cp ${SDX_HOME}/sdx-compose/conf/pip.conf ${SDX_HOME}/${PREFIX}$${r}/pip.conf; \
		else \
			echo "  - already exists: skipping"; \
		fi; echo ""; \
	done

start:
	@ printf "\n[${YELLOW} Bringing up docker compose ${NO_COLOR}]\n"
	docker-compose up

build:
ifndef NO_OPS
	@ printf "\n[${GREEN} Generating environment variables... ${NO_COLOR}]\n"
	cd ${SDX_HOME}/sdx-ops && ${PYTHON3} -m sdx.ops.configure --env > ${SDX_HOME}/sdx-compose/env/private.env ;cd -
endif
	@ printf "\n[${YELLOW} Refreshing build ${NO_COLOR}]\n"
	docker-compose build

clean: check-env
	@ for r in ${REPOS}; do \
		printf "\n${RED}Removing ${SDX_HOME}/${PREFIX}$${r}${NO_COLOR}"; \
		rm -rf ${SDX_HOME}/${PREFIX}$${r}; \
	done
	@ printf "\n"