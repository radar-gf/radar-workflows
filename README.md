# radar-workflows

Workflows reutilizáveis do GitHub Actions do Radar.

## node-ci

Pipeline de pull request para serviços Node.js: lint, formatação, tipos, build, testes com cobertura, SonarQube Cloud e gitleaks.

### Uso

```yaml
jobs:
  ci:
    uses: radar-gf/radar-workflows/.github/workflows/node-ci.yml@main
    secrets: inherit
```

### Contrato: o repositório chamador precisa ter

- `.nvmrc` com a versão do Node
- `packageManager` no `package.json` (ex.: `pnpm@10.x.x`)
- `pnpm-lock.yaml` versionado
- Scripts: `lint`, `format:check`, `typecheck`, `build`, `test:cov`
- `test:cov` gerando `coverage/lcov.info`
- `sonar-project.properties` com `sonar.organization` e `sonar.projectKey` (se `sonar: true`)
