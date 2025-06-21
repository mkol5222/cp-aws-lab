#!/bin/bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
echo 'eval "$(direnv hook bash)"' >> ~/.bash_profile

# add .envrc to workspace root
if [ ! -f .envrc ]; then
  echo '' > .envrc
  cat <<EOF >> .envrc
export AWS_REGION="eu-north-1"
export AWS_DEFAULT_REGION="eu-north-1"
EOF
fi