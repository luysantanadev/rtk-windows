# Roadmap — Windows Native Hook Compatibility

Este arquivo consolida o contexto da conversa sobre compatibilidade nativa Windows para hooks (com foco em Copilot), incluindo planejamento, decisões, execução, status e próximos passos.

## Objetivo

Garantir suporte robusto de hooks no Windows nativo para Copilot, com:
- inicialização confiável (`rtk init --copilot`)
- migração automática de hook legado shell para hook Rust
- cobertura de edge cases
- suíte de testes verde e preparação de release

---

## Plan: Windows Native Hook Compatibility

### Phase 1 — Baseline e diagnóstico inicial
- Validar ambiente Windows e execução local.
- Confirmar comportamento atual de `rtk init --copilot`.
- Identificar gaps de docs e migração.

### Phase 2 — Docs + Migration
- Atualizar documentação para Windows nativo.
- Implementar regra de migração para hook legado (`rtk-rewrite.sh` -> hook Rust).
- Garantir backward compatibility no fluxo de init.

### Phase 3 — Edge Cases + validação final
- Cobrir casos de borda no fluxo de hooks e no fluxo Windows.
- Validar idempotência e dry-run.
- Consolidar estabilidade para release.

### Phase 4 — CI Windows
- Expandir automação de CI para cenários Windows.
- Incluir scripts e matriz de execução dedicada.

---

## Registro de decisões e planos discutidos

### Bloco discutido: "Proximos Passos (em prioridade)"

Curto prazo (hoje/amanhã)
1. Completar Phase 2 - Docs + Migration
- Atualizar README.md com setup Windows nativo
- Atualizar supported-agents.md com Copilot Windows
- Adicionar migration rules em init.rs para script legado -> Rust hook

2. Expandir Phase 3 - Edge Cases
- Testes para quoting (single/double quotes, escape)
- Testes para env-prefixes (GIT_SSH_COMMAND=... git push)
- Testes para pipes (git log | head -20)
- Testes para redirects (> file, 2>&1)
- Testes para heredoc passthrough (<<EOF)

Medio prazo (semana)
3. Iniciar Phase 4 - CI Windows
- Criar scripts/test-all.ps1 como equivalente PowerShell de test-all.sh
- Atualizar ci.yml para rodar Windows hooks tests
- Adicionar matrix Windows-latest no CI

Ordem recomendada discutida: **A -> B -> C**

### Bloco discutido: "Opcoes de Proxima Etapa"

Opção 1: Phase 3 — Edge Cases Copilot
- Inicialização Windows em múltiplos cenários
- Permissões restritas
- Migração de versões antigas
- Concorrência cross-platform
- Output muito grande (>10MB)

Opção 2: Debug & Fix Stream Tests
- Investigar falhas em `core::stream::tests`
- Revisar `stream.rs`
- Testar process spawning no Windows
- Limpar bloqueador da suíte

Opção 3: Release Preparation
- Bump de versão (v0.35.0)
- Update de changelog
- Teste em Windows real
- Build de binários

Recomendação aplicada na conversa: **Opção 2 primeiro**, depois Phase 3 e release.

### Bloco discutido posteriormente: "A próxima etapa lógica é a Fase 3"

- Exercitar cenários de borda no fluxo Windows
- Validar outputs grandes, stderr puro, sem stdout, exit codes altos, e `cmd /c`
- Rodar smoke tests focados em hooks:
  - `rtk init --copilot`
  - migração de hook legado
  - modo global vs project-scoped
  - reexecução idempotente
- Fechar preparação de release após fase 3

---

## O que foi concluído

### Phase 2 — Concluída
- Documentação de suporte Windows para Copilot atualizada.
- Migração de hook legado implementada em `src/hooks/init.rs` no fluxo `run_copilot`.
- Fluxo remove `rtk-rewrite.sh` legado e instala o hook Rust nativo.

### Debug stream tests — Concluído
- Suíte de stream no Windows foi estabilizada com comandos compatíveis.
- Falhas de spawn por comandos Unix-only foram tratadas nos testes.
- Gate completo passou após correções.

### Phase 3 (slice de hooks Copilot) — Parcialmente concluída
- Novos testes adicionados para `run_copilot`:
  - criação de artefatos project-scoped
  - migração do script legado
  - idempotência em reexecução
- Proteção contra flakiness com lock para testes que alteram `current_dir()`.
- Validação local verde (`hooks::init::tests` + gate completo).

### Melhoria adicional concluída
- `copilot-instructions` foi atualizado para incluir exemplos de **PowerShell/Windows**, além de Bash.

---

## O que ainda falta

### Phase 3 — Pendências
- Expandir edge cases de parsing/rewrite no hook:
  - quoting complexo (single/double/escape)
  - env prefixes
  - pipes e redirects
  - heredoc passthrough
- Reforçar smoke tests em projeto externo (fora do repo RTK).

### Phase 4 — Pendente
- Criar/validar `scripts/test-all.ps1` (equivalente PowerShell).
- Atualizar CI para executar hooks tests em Windows.
- Adicionar/validar matriz `windows-latest` na pipeline.

### Release prep — Pendente
- Bump de versão para v0.35.0.
- Atualizar `CHANGELOG.md` com entregas das phases 2/3.
- Validar release smoke em Windows real.
- Gerar artifacts/binários de distribuição.

---

## Como instalar o binário RTK no computador

### Opção 1 (recomendada para desenvolvimento local): instalar via Cargo

No diretório do repositório RTK:

```powershell
cargo install --path .
```

Verificar instalação:

```powershell
rtk --version
rtk gain
```

### Opção 2: usar sem instalar globalmente

```powershell
cargo run -- init --copilot
cargo run -- hook copilot
```

### Opção 3: build release e usar binário gerado

```powershell
cargo build --release
.\target\release\rtk.exe --version
```

Opcional (copiar para pasta no PATH):

```powershell
Copy-Item .\target\release\rtk.exe "$env:USERPROFILE\\bin\\rtk.exe"
```

---

## Smoke test local em projeto externo (Windows)

Dentro de um projeto de teste (nao o repo do RTK):

```powershell
rtk init --copilot
Test-Path .github\hooks\rtk-rewrite.json
Test-Path .github\copilot-instructions.md
```

Verificar idempotência:

```powershell
rtk init --copilot
rtk init --copilot
```

Verificar dry-run sem escrita:

```powershell
rtk init --copilot --dry-run
```

Simular migração legado:

```powershell
New-Item -ItemType Directory -Force .github\hooks | Out-Null
Set-Content .github\hooks\rtk-rewrite.sh "#!/bin/sh`necho legacy"
rtk init --copilot
Test-Path .github\hooks\rtk-rewrite.sh   # esperado: False
Test-Path .github\hooks\rtk-rewrite.json # esperado: True
```

---

## Próxima fase recomendada

**Release Preparation (v0.35.0)**, pois:
- Fase 2 está concluída.
- Slice principal de Fase 3 para init/migração/idempotência está validado.
- Gate completo está verde.

Sequência sugerida:
1. Fechar pendências de edge cases de parsing (Phase 3 restante).
2. Bump de versão + changelog.
3. Smoke final em Windows real.
4. Tag/release.
