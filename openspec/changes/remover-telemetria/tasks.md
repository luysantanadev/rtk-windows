## 1. Remoção de código de telemetria

- [x] 1.1 Mapear e remover módulos, structs e funções de telemetria/analytics no runtime e wiring de comandos
- [x] 1.2 Remover inicialização de coletores e qualquer envio remoto de eventos/identificadores (mantendo tracking local para `gain`)
- [x] 1.3 Ajustar imports, features e dependências que ficarem órfãs após a remoção

## 2. Superfície de CLI e configuração

- [x] 2.1 Remover comandos/subcomandos de telemetria e respectivas entradas de help
- [x] 2.2 Remover flags e variáveis de ambiente relacionadas à telemetria
- [x] 2.3 Garantir que configurações legadas de telemetria sejam ignoradas sem quebrar execução

## 3. Documentação sem telemetria

- [x] 3.1 Remover referências de telemetria do README principal e documentação em docs/
- [x] 3.2 Remover referências de telemetria em guias de contribuição/manutenção e processo de release
- [x] 3.3 Revisar READMEs traduzidos e remover menções equivalentes quando existirem

## 4. Validação e segurança de mudança

- [x] 4.1 Atualizar testes impactados por remoção de comandos/config de telemetria
- [x] 4.2 Executar suíte de testes e validações de documentação
- [x] 4.3 Validar saída de help e comportamento de runtime para confirmar ausência de superfícies de telemetria
