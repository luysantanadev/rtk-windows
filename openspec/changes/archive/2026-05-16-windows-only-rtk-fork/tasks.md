## 1. Platform Contract and Runtime Simplification

- [x] 1.1 Declarar no código e metadados do projeto que o fork é oficialmente Windows-only (breaking) e remover sinalizações ambíguas de suporte Linux/macOS.
- [x] 1.2 Mapear pontos de execução/spawn com branches Unix/macOS e classificar cada item em remover/manter/arquivar.
- [x] 1.3 Remover branches Unix/macOS não necessários no runtime, preservando comportamento funcional no fluxo Windows.
- [x] 1.4 Validar semântica Windows de execução (quoting, env-prefix, pipes, redirects, heredoc passthrough e propagação de exit codes).

## 2. Hooks and Agent Integrations (Windows Native)

- [x] 2.1 Inventariar hooks shell-only Unix e decidir remoção ou arquivamento conforme contrato Windows-only.
- [x] 2.2 Consolidar integrações de hooks para modo Windows nativo sem regressão em funcionalidades já entregues.
- [x] 2.3 Garantir `rtk init --copilot` com migração legada (`rtk-rewrite.sh` -> hook Rust) funcionando de forma idempotente.
- [x] 2.4 Atualizar/remover testes e fixtures de hooks incompatíveis com o novo escopo, mantendo cobertura de comportamento.

## 3. Windows-focused Test Strategy

- [x] 3.1 Remover testes exclusivamente Unix sem valor para contrato Windows-only.
- [x] 3.2 Implementar/ajustar testes para edge cases obrigatórios: quoting, env-prefix, pipes, redirects e heredoc passthrough.
- [x] 3.3 Implementar/ajustar testes para outputs grandes, stderr-only, ausência de stdout e exit codes altos.
- [x] 3.4 Executar smoke tests locais Windows para `rtk init --copilot`, migração legada e reexecução idempotente.
- [x] 3.5 Rodar gate local completo (build, lint, testes) em ambiente Windows e registrar evidência dos resultados.

## 4. CI/CD Migration to Windows-latest

- [x] 4.1 Migrar workflows para `windows-latest` como ambiente oficial de validação deste fork.
- [x] 4.2 Substituir chamadas de scripts Bash por scripts PowerShell equivalentes para o gate oficial.
- [x] 4.3 Remover jobs Linux/macOS da pipeline ativa e ajustar dependências entre jobs.
- [ ] 4.4 Validar execução completa da pipeline em pull request de teste e corrigir falhas.

## 5. Documentation and Fork Positioning

- [x] 5.1 Atualizar README principal e guias para afirmar suporte Windows-only com exemplos PowerShell/cmd.
- [x] 5.2 Atualizar docs de hooks/agentes para remover instruções de suporte ativo Linux/macOS neste fork.
- [x] 5.3 Adicionar seção "Diferenças do fork vs upstream" com redirecionamento explícito de usuários Linux/macOS para `https://github.com/luysantanadev/rtk-windows.git`.
- [x] 5.4 Revisar documentação para eliminar inconsistências de plataforma e validar links/comandos.

## 6. Release and Breaking-change Communication

- [x] 6.1 Definir versão de release Windows-only (proposta: `v0.35.0`) e confirmar impacto de compatibilidade.
- [x] 6.2 Atualizar `CHANGELOG.md` com breaking changes e plano de migração para usuários do fork.
- [x] 6.3 Executar checklist de release em Windows (build, smoke tests, quality gate, artefatos).
- [ ] 6.4 Publicar release notes com escopo da remoção Unix/macOS e limites de suporte deste fork.
