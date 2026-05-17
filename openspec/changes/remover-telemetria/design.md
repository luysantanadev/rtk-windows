## Context

O repositório já possui a capability `no-telemetry`, mas ainda há referências e possíveis caminhos de telemetria remota no código e na documentação. O objetivo desta mudança é consolidar uma postura explícita de não transmissão remota de dados de uso, removendo comportamento, configuração e narrativa documental que indiquem o contrário.

## Goals / Non-Goals

**Goals:**
- Eliminar caminhos de transmissão remota de dados de uso de usuários.
- Remover superfícies públicas de telemetria (flags, env vars, comandos e textos).
- Garantir coerência documental: nenhum guia oficial deve instruir ou sugerir telemetria.
- Preservar o tracking local usado pelo `rtk gain`.

**Non-Goals:**
- Redesenhar funcionalidades centrais não relacionadas à privacidade/telemetria.
- Introduzir nova plataforma de observabilidade.
- Alterar contrato de CLI além dos pontos estritamente ligados à telemetria.

## Decisions

1. Remoção total de componentes de telemetria remota no código.
Rationale: desabilitar por configuração não atende ao requisito de não enviar dados de uso para endpoints externos; remoção estrutural reduz risco de regressão.
Alternative considered: manter implementação com hard-disable permanente. Rejeitada por manter código morto e risco de reativação acidental.

2. Deprecar por remoção qualquer entrada de configuração de telemetria remota.
Rationale: variáveis/flags/comandos de telemetria remota devem deixar de existir para evitar ambiguidade sobre envio externo.
Alternative considered: manter aliases sem efeito. Rejeitada por perpetuar superfície e confusão para usuários.

3. Tratar limpeza de documentação como requisito de conformidade, não apenas tarefa editorial.
Rationale: política de privacidade percebida pelos usuários depende de documentação consistente.
Alternative considered: atualizar apenas README principal. Rejeitada por deixar contradições em docs secundárias e traduções.

## Risks / Trade-offs

- [Remoção de caminhos de telemetria remota pode quebrar testes/fluxos indiretos] -> Mitigação: atualizar testes afetados e validar scripts principais.
- [Remoção de comandos/flags pode impactar usuários existentes] -> Mitigação: registrar como BREAKING no changelog/proposal e documentar migração para comportamento padrão sem telemetria.
- [Referências residuais em documentação multilíngue] -> Mitigação: executar varredura textual por termos de telemetria e revisar manualmente arquivos críticos.

## Migration Plan

1. Remover código e wiring de telemetria remota.
2. Remover configurações, variáveis e comandos associados.
3. Atualizar/limpar documentação oficial (README e docs correlatos, incluindo traduções quando aplicável).
4. Ajustar testes e scripts de validação.
5. Executar suíte de testes relevante e checagens de docs.

Rollback strategy:
- Reverter a change completa caso haja regressão crítica antes de release.
- Não haverá migração parcial de telemetria; rollback deve restaurar o estado anterior integralmente.

## Open Questions

- Existe algum requisito de métricas estritamente locais que ainda seja considerado aceitável sem caracterizar coleta de informação de usuários?
- Quais documentos traduzidos devem ser tratados como obrigatórios no mesmo PR para evitar inconsistência de política?
