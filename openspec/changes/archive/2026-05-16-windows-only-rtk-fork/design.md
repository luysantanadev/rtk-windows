## Context

Este fork já consolidou partes críticas de operação Windows nativa, incluindo:
- `rtk init --copilot` project-scoped com hook Rust (`rtk hook copilot`), migração do hook legado `rtk-rewrite.sh` e idempotência.
- Atualizações de documentação e instruções para PowerShell.
- Estabilização prévia de testes de stream/spawn no Windows (registrado em `roadmap.md`).

Ao mesmo tempo, o repositório ainda mantém trilhas Linux/macOS em scripts, documentação, CI e partes de integração de hooks. Como Linux/macOS seguem no upstream (`rtk-ai/rtk`), manter paridade neste fork aumenta custo e risco sem benefício direto.

Restrições consideradas:
- Não degradar funcionalidades já concluídas de Copilot Windows native, migração legada e idempotência.
- Evitar retrabalho de features que devem continuar no upstream.
- Fazer remoção incremental com rollback simples (reverter commits por fase).

## Goals / Non-Goals

**Goals:**
- Oficializar suporte Windows-only neste fork e explicitar impacto de breaking change.
- Remover com segurança caminhos Unix/macOS de runtime, scripts, testes, docs e CI que não são mais parte do contrato do fork.
- Consolidar execução operacional em PowerShell/cmd e garantir estabilidade do quality gate em Windows.
- Preservar `rtk init --copilot` com migração legada e idempotência como requisitos rígidos.
- Publicar release Windows-only com comunicação clara de diferenças vs upstream.

**Non-Goals:**
- Reimplementar ou portar capacidades Linux/macOS para este fork.
- Alterar o comportamento funcional de filtros/recursos não relacionados à estratégia Windows-only.
- Introduzir novo framework de hooks ou arquitetura de runtime além do necessário para simplificação.

## Decisions

1. Plataforma oficial: Windows-only (breaking)
- Decisão: declarar Windows nativo como única plataforma suportada no fork.
- Racional: foco de manutenção, redução de matriz de testes e clareza para usuários.
- Alternativas consideradas:
  - Manter "best effort" em Linux/macOS: rejeitada por custo e ambiguidade de suporte.
  - Remover apenas docs Linux/macOS e manter código: rejeitada por dívida técnica oculta.

2. Remoção incremental em ondas (runtime -> hooks -> testes -> CI -> docs -> release)
- Decisão: executar em fases pequenas, com validação a cada etapa no quality gate Windows.
- Racional: limita blast radius e facilita rollback por commit.
- Alternativas consideradas:
  - Big-bang único: rejeitada por risco elevado e difícil diagnóstico.

3. Spawn/process execution com semântica explícita de Windows
- Decisão: revisar pontos de spawning para evitar dependências de shell Unix e garantir quoting/passthrough consistentes em PowerShell/cmd.
- Racional: previsibilidade de comportamento nos edge cases já mapeados.
- Alternativas consideradas:
  - Manter condicionais cross-platform: rejeitada por complexidade desnecessária ao novo escopo.

4. Hooks: Copilot Windows native como baseline obrigatório
- Decisão: manter e reforçar o fluxo atual de `rtk init --copilot` (migração legada + idempotência), removendo/arquivando caminhos shell-only Unix quando aplicável.
- Racional: funcionalidade já validada e central para uso no fork.
- Alternativas consideradas:
  - Retomar scripts shell como fallback: rejeitada por conflitar com objetivo Windows-only.

5. CI/CD focado em `windows-latest`
- Decisão: remover jobs Linux/macOS neste fork e padronizar validação com scripts PowerShell.
- Racional: reduzir custo de CI e alinhar sinal de qualidade ao suporte oficial.
- Alternativas consideradas:
  - Manter jobs Linux/macOS apenas informativos: rejeitada por ruído e manutenção.

6. Documentação de bifurcação explícita
- Decisão: incluir seção "Diferenças do fork vs upstream" e direcionamento Linux/macOS para upstream.
- Racional: evitar expectativa incorreta de suporte e reduzir tickets improdutivos.
- Alternativas consideradas:
  - Apenas nota curta no README: rejeitada por baixa visibilidade.

## Risks / Trade-offs

### Matriz de risco por remoção de componente Unix

| Componente Unix/macOS a remover/arquivar | Risco | Impacto principal | Mitigação |
|---|---|---|---|
| Branches `cfg(unix)`/caminhos Unix no runtime de spawn | Alto | Regressão em quoting/pipes/redirect no Windows se remoção for incompleta | Remoção faseada + suíte dedicada de edge cases + smoke tests locais |
| Hooks shell-only (`.sh`) não usados no fluxo Windows | Médio | Perda de referência histórica e confusão em manutenção | Arquivar em docs de migração + manter histórico Git + validar `rtk init --copilot` |
| Testes exclusivos Unix | Médio | Queda de cobertura percebida sem substituir cenários úteis | Reescrever cenários relevantes em semântica Windows e manter cobertura de comportamento |
| Scripts de validação Bash (`*.sh`) para pipeline oficial | Alto | Gate quebrado ao migrar para PowerShell | Criar equivalentes `.ps1` antes da remoção + rodar em `windows-latest` |
| Jobs CI Linux/macOS | Baixo | Perda de sinal cross-platform (não suportado no fork) | Comunicação explícita no README + referência ao upstream |
| Trechos de docs com instruções Linux/macOS ativas | Médio | Usuário segue fluxo errado e abre bugs de suporte | Revisão documental sistemática + seção de redirecionamento ao upstream |
| Exemplos Bash em guias de agentes deste fork | Médio | Inconsistência operacional e suporte | Padronizar exemplos PowerShell e marcar Bash como "upstream only" |

### Riscos gerais e trade-offs

- [Risco de regressão em rewrite/parsing no Windows] -> manter edge cases obrigatórios (quoting, env-prefix, pipes, redirects, heredoc passthrough, outputs grandes, stderr-only, sem stdout, exit codes altos) como gate.
- [Risco de remoção excessiva] -> checklist por componente com "remover / arquivar / manter" aprovado antes de apagar.
- [Trade-off: perda de portabilidade neste fork] -> aceito por decisão estratégica; Linux/macOS continuam no upstream.

## Migration Plan

1. Fase A: Plataforma/runtime
- Mapear e remover condicionais Unix/macOS desnecessários.
- Consolidar execução/spawn para semântica Windows.
- Rodar quality gate local Windows.

2. Fase B: Hooks e integração de agentes
- Confirmar modo Windows nativo para integrações alvo.
- Remover/arquivar implementações shell-only quando não aplicáveis ao fork.
- Garantir regressão zero em `rtk init --copilot` (migração legada + idempotência).

3. Fase C: Testes
- Remover testes Unix-only sem valor no novo escopo.
- Adicionar/ajustar cobertura dos edge cases obrigatórios.
- Incluir smoke tests Windows no fluxo de validação.

4. Fase D: CI/CD
- Migrar pipeline para `windows-latest`.
- Substituir automações de validação por PowerShell.
- Remover jobs Linux/macOS.

5. Fase E: Documentação + release
- Atualizar README/guides/docs para Windows-only.
- Adicionar seção "diferenças do fork vs upstream" e redirecionamento Linux/macOS.
- Publicar release Windows-only (alvo `v0.35.0`) com breaking changes.

Rollback strategy:
- Reversão por fase via commits atômicos; se gate falhar, reverter apenas a última fase e manter estado anterior estável.

## Open Questions

- Confirmar versão final do release breaking (`v0.35.0` ou `v0.35.x`) conforme políticas atuais do maintainership.
- Definir lista final de scripts `.sh` que serão removidos vs apenas arquivados para referência histórica.
- Validar se alguma integração de agente deve permanecer "documentada, porém não suportada" em vez de removida do fork.
