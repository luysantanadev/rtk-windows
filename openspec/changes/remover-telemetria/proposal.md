## Why

O projeto ainda contém referências e caminhos de telemetria, o que conflita com o objetivo de não coletar nenhuma informação de usuários. A mudança é necessária agora para alinhar comportamento, documentação e expectativas de privacidade.

## What Changes

- Remover envio remoto de eventos/telemetria no CLI e em integrações relacionadas.
- Remover flags, variáveis de ambiente e opções de configuração associadas à telemetria.
- Atualizar documentação para afirmar explicitamente que o projeto não coleta dados de uso.
- Remover referências de telemetria em guias de uso, manutenção e processo de release.
- **BREAKING**: recursos, comandos, variáveis e textos relacionados à telemetria deixam de existir.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `no-telemetry`: fortalecer requisitos para proibir transmissão remota de dados de uso e exigir ausência de referências de telemetria remota na documentação oficial.

## Impact

- Código afetado: superfícies de telemetria remota e referências associadas no runtime e na documentação.
- Documentação afetada: README principal e traduções, guias em docs/usage, docs de arquitetura/convenções e arquivos de contribuição/manutenção que citam telemetria.
- Processos afetados: validação de docs/release deve assumir postura sem telemetria.
