#!/usr/bin/env bash
# Aplica os rulesets de rulesets/ em cada repositório da organização.
# Idempotente: cria o ruleset se não existir, atualiza se já existir.
set -euo pipefail

ORG="radar-gf"

# Todos os repositórios recebem a proteção básica da main.
ALL_REPOS=(radar-workflows radar-service-template radar-docs)

# Só repositórios que rodam o node-ci exigem os checks.
CI_REPOS=(radar-service-template)

apply() {
  local repo="$1" name="$2" file="rulesets/$2.json"
  local id
  id=$(gh api "repos/$ORG/$repo/rulesets" --jq ".[] | select(.name == \"$name\") | .id")

  if [[ -n "$id" ]]; then
    gh api -X PUT "repos/$ORG/$repo/rulesets/$id" --input "$file" > /dev/null
    echo "atualizado: $name em $repo"
  else
    gh api -X POST "repos/$ORG/$repo/rulesets" --input "$file" > /dev/null
    echo "criado:     $name em $repo"
  fi
}

for repo in "${ALL_REPOS[@]}"; do apply "$repo" protect-main; done
for repo in "${CI_REPOS[@]}"; do apply "$repo" require-ci; done
