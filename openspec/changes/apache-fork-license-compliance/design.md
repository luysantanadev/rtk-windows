## Context

O projeto e um fork ativo com publicacao de codigo e binarios. O upstream declara Apache-2.0 no arquivo LICENSE. O objetivo e transformar um checklist juridico em requisitos verificaveis e em atualizacoes concretas no repositorio.

## Goals / Non-Goals

**Goals:**
- Tornar a conformidade de licenca explicita e auditavel.
- Garantir preservacao de licenca/atribuicoes e marcacao de modificacoes.
- Deixar claro no README que o fork e nao oficial.
- Inserir checklist operacional de compliance para release.

**Non-Goals:**
- Nao substitui assessoria juridica profissional.
- Nao altera licencas de terceiros externas ao repositorio.
- Nao redesenha o pipeline completo de release alem do gate documental.

## Decisions

- Criar capability nova `fork-license-compliance` para centralizar requisitos normativos.
- Modificar capability `release-process` para incluir validacao de compliance antes de release.
- Aplicar mudancas prioritariamente em documentacao (baixo risco tecnico e alta efetividade).
- Preferir linguagem clara e prescritiva (MUST/SHALL) nos specs para rastreabilidade.

Alternativas consideradas:
- Implementar apenas texto solto no README: rejeitado por baixa auditabilidade.
- Criar automacao de validacao juridica total em CI: adiado; alto custo para ganho inicial.

## Risks / Trade-offs

- [Risco] Divergencia futura entre pratica e checklist documental -> Mitigacao: checklist de release versionado no repo.
- [Risco] Ambiguidade legal em cenarios especificos -> Mitigacao: aviso explicito de que casos sensiveis exigem advogado.
- [Trade-off] Solucao inicial baseada em processo humano, nao bloqueio automatico -> Mitigacao: adicionar gate automatizado em iteracao futura.
