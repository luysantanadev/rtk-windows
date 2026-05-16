## Why

Este fork já evoluiu para suporte nativo Windows (PowerShell + hooks Rust para Copilot) e hoje carrega custo de manutenção duplicado com caminhos Linux/macOS que são responsabilidade do upstream. Tornar o fork oficialmente Windows-only reduz complexidade, acelera correções locais e permite um quality gate focado em Windows com maior previsibilidade de release.

## What Changes

- **BREAKING**: declarar suporte oficial do fork somente para Windows nativo (PowerShell/cmd), removendo suporte ativo Linux/macOS neste repositório.
- Remover/arquivar caminhos de execução, scripts e testes Unix/macOS que não agregam ao objetivo do fork.
- Consolidar integrações de hooks em modo Windows nativo, preservando `rtk init --copilot` com migração de hook legado e idempotência.
- Padronizar comandos, exemplos e operação para PowerShell/Windows em docs, guias e artefatos de hook.
- Migrar CI/CD para foco `windows-latest`, com validações em PowerShell e remoção de jobs Linux/macOS.
- Planejar release Windows-only (proposta base: `v0.35.0`) com changelog de breaking changes e guia de migração para usuários Linux/macOS (direcionamento ao upstream).

## Capabilities

### New Capabilities
- `windows-only-platform-runtime`: define contrato de suporte oficial Windows-only, incluindo semântica de spawning e remoção segura de branches Unix/macOS.
- `windows-native-agent-hooks`: consolida hooks e fluxo de integração de agentes em Windows nativo, com garantia de migração legada e idempotência no `rtk init --copilot`.
- `windows-quality-and-tests`: redefine estratégia de testes para Windows-only, cobrindo edge cases de rewrite/spawn/passthrough e quality gate verde.
- `windows-focused-ci-cd`: estabelece pipeline e validações focadas em `windows-latest`, com scripts PowerShell e sem jobs Linux/macOS.
- `windows-only-docs-and-release`: formaliza documentação Windows-only, diferenças do fork vs upstream e processo de release com breaking changes.

### Modified Capabilities
- _Nenhuma (não há specs existentes em `openspec/specs/` neste momento)._ 

## Impact

- Código: módulos de hooks, runner/spawn, scripts utilitários e testes com condicionais Unix serão simplificados ou removidos.
- CI/CD: workflows e jobs serão reduzidos para execução focada em Windows.
- Documentação: README principal, guias de agentes e docs de contribuição/uso terão instruções alinhadas a PowerShell/Windows.
- Usuários: Linux/macOS deixam de ter suporte neste fork e devem usar upstream `rtk-ai/rtk`.
- Release: incremento de versão com breaking change explícito e plano de migração do fork.
