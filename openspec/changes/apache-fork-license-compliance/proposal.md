## Why

O fork precisa de um baseline formal e verificavel de conformidade com a licenca Apache-2.0 do upstream para reduzir risco juridico e de reputacao. Isso tambem evita inconsistencias entre README, LICENSE, releases e atribuicoes.

## What Changes

- Definir requisitos normativos de compliance para forks derivados do upstream Apache-2.0.
- Padronizar textos e artefatos minimos de atribuicao, alteracao e nao-afiliacao.
- Aplicar atualizacoes no repositorio para refletir os requisitos (README, notices e checklist operacional).
- Incluir checklist de publicacao para releases de binarios e source tarballs.

## Capabilities

### New Capabilities
- `fork-license-compliance`: Define requisitos obrigatorios para distribuicao de fork, atribuicao, aviso de modificacoes, uso de marca e checklist de release conforme Apache-2.0.

### Modified Capabilities
- `release-process`: adicionar gate de compliance legal/documental no fluxo de release.

## Impact

- Documentacao: README, possivel arquivo NOTICE/atribuição e guia de release/compliance.
- Processo: checklist de revisao antes de publicar tags/releases.
- Governanca: padrao unico para comunicacao de fork nao oficial e preservacao de avisos legais.
