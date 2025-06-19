
all:
	echo "not implemented"
	
.PHONY: all

cpman-serial:
	./scripts/cpman-serial.sh

cpman-down:
	./scripts/cpman-down.sh

cpman: cpman-up cpman-wait policy cpman-pass
cpman-up:
	./scripts/cpman-up.sh
cpman-ssh:
	./scripts/cpman-ssh.sh
cpman-pass:
	./scripts/cpman-pass.sh
cpman-wait:
	./scripts/cpman-wait-for-api.sh
	

cluster: cluster-up cluster-topo
cluster-up:
	./scripts/cluster-up.sh
cluster-down:
	./scripts/cluster-down.sh

cluster-serial:
	./scripts/cluster-serial.sh
cluster-serial-a:
	./scripts/cluster-serial.sh a
cluster-serial-b:
	./scripts/cluster-serial.sh b

cluster-ssh: cluster-ssh-a

cluster-ssh-a:
	./scripts/cluster-ssh.sh a
cluster-ssh-b:
	./scripts/cluster-ssh.sh b

cluster-topo:
	./scripts/cluster-topo.sh

cluster-linux-serial:
	./scripts/cluster-linux-serial.sh

cluster-wait:
	./scripts/cluster-wait-for-sic.sh a
	./scripts/cluster-wait-for-sic.sh b
cluster-wait-a:
	./scripts/cluster-wait-for-sic.sh a
cluster-wait-b:
	./scripts/cluster-wait-for-sic.sh b

policy: policy-up

policy-up:
	./scripts/policy-up.sh

asg: asg-up
asg-up:
	./scripts/asg-up.sh
asg-down:
	./scripts/asg-down.sh
