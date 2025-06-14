
all:
	echo "not implemented"
	
.PHONY: all

cpman-serial:
	./scripts/cpman-serial.sh

cpman-down:
	./scripts/cpman-down.sh
cpman-up:
	./scripts/cpman-up.sh
cpman-ssh:
	./scripts/cpman-ssh.sh


cluster-up:
	./scripts/cluster-up.sh
cluster-down:
	./scripts/cluster-down.sh