## Why

RTK é atualmente compilado e distribuído para 5 plataformas (macOS x86_64, macOS ARM, Linux musl, Linux ARM, Windows). Isso adiciona overhead significativo no pipeline: 40+ minutos de build, 5 pacotes distintos, suporte multi-plataforma complexo. Para agilizar o desenvolvimento e focar inicialmente em Windows (cliente principal), simplificar o pipeline para **publicar apenas binários Windows** reduz ciclo de release, custos de CI/CD, e complexidade de manutenção.

## What Changes

- **release.yml**: Remover jobs de build para macOS (x86_64, ARM) e Linux (musl, ARM64)
- **release.yml**: Remover builds de pacotes DEB e RPM
- **release.yml**: Manter apenas job `build` com target `x86_64-pc-windows-msvc`
- **cd.yml**: Simplificar matriz de compilação, reduzindo tempo total do pipeline
- **Documentação**: Atualizar README sobre suporte de plataformas (Windows-only no momento)

## Capabilities

### New Capabilities
- `windows-only-distribution`: Pipeline simplificado que publica apenas binários Windows (.exe e .zip)

### Modified Capabilities
- `release-process`: Workflow de release agora targets exclusivamente Windows; remover suporte multi-plataforma do processo

## Impact

- **Code**: Remoção de 80% do matrix build (4 dos 5 targets)
- **CI/CD Pipeline**: Redução de ~35 minutos para ~5 minutos por release
- **Package Managers**: Sem mais DEB/RPM — apenas GitHub Releases (Windows only)
- **Distribution**: Homebrew e Linux package repos não são mais suportados
- **Users**: macOS e Linux users precisam compilar localmente (`cargo install --path .`) ou usar pre-builds antigos
