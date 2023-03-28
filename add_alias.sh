#!/bin/bash

if [ ${#} -ne 1 ]; then
  echo "Usage: ${0} <alias_name>"
  exit 1
fi

alias_name="${1}"
host_name="${alias_name}"

alias_command="ssh root@${alias_name}.domain.i.want"

# Check if the alias already exists in the ~/.bash_aliases file
if grep -q "${alias_name}" ~/.bash_aliases; then
  echo "Alias '${alias_name}' already exists in ~/.bash_aliases"
else
  echo "alias ${alias_name}='${alias_command}'" >> ~/.bash_aliases
  source ~/.bash_aliases
  echo "Alias '${alias_name}' added for host '${host_name}'"
fi
