```bash

IP=$(cd linux && terraform output -raw ip)

ssh -i ./secrets/linux-keypair.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@$IP

```