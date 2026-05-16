<p align="center">
  <img src="https://avatars.githubusercontent.com/u/258253854?v=4" alt="rtk-windows - Rust Token Killer" width="500">
</p>

<p align="center">
  <strong>Proxy CLI de alto rendimiento que reduce el consumo de tokens LLM en un 60-90%</strong>
</p>

<p align="center">
  <a href="https://github.com/luysantanadev/rtk-windows.git/actions"><img src="https://github.com/luysantanadev/rtk-windows.git/workflows/Security%20Check/badge.svg" alt="CI"></a>
  <a href="https://github.com/luysantanadev/rtk-windows.git/releases"><img src="https://img.shields.io/github/v/release/luysantanadev/rtk-windows" alt="Release"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="https://www.rtk-ai.app">Sitio web</a> &bull;
  <a href="#instalacion">Instalar</a> &bull;
  <a href="docs/TROUBLESHOOTING.md">Solucion de problemas</a> &bull;
  <a href="docs/contributing/ARCHITECTURE.md">Arquitectura</a>
</p>

<p align="center">
  <a href="README.md">English</a> &bull;
  <a href="README_fr.md">Francais</a> &bull;
  <a href="README_zh.md">中文</a> &bull;
  <a href="README_ja.md">日本語</a> &bull;
  <a href="README_ko.md">한국어</a> &bull;
  <a href="README_es.md">Espanol</a>
</p>

---

rtk-windows filtra y comprime las salidas de comandos antes de que lleguen al contexto de tu LLM. Binario Rust unico, cero dependencias, <10ms de overhead.

## Ahorro de tokens (sesion de 30 min en Claude Code)

| Operacion | Frecuencia | Estandar | rtk-windows | Ahorro |
|-----------|------------|----------|-----|--------|
| `ls` / `tree` | 10x | 2,000 | 400 | -80% |
| `cat` / `read` | 20x | 40,000 | 12,000 | -70% |
| `grep` / `rg` | 8x | 16,000 | 3,200 | -80% |
| `git status` | 10x | 3,000 | 600 | -80% |
| `cargo test` / `npm test` | 5x | 25,000 | 2,500 | -90% |
| **Total** | | **~118,000** | **~23,900** | **-80%** |

## Instalacion

### Windows binary (recommended)

```powershell
# Download rtk-windows-x86_64-pc-windows-msvc.zip from Releases
# Extract rtk-windows.exe and add it to PATH
``` 

### Cargo

```powershell
cargo install --git https://github.com/luysantanadev/rtk-windows.git
```

### Verificacion

```powershell
rtk-windows --version   # Debe mostrar "rtk-windows 0.27.x"
rtk-windows gain        # Debe mostrar estadisticas de ahorro
```

## Inicio rapido

```powershell
# 1. Instalar hook para Claude Code (recomendado)
rtk-windows init --global

# 2. Reiniciar Claude Code, luego probar
git status  # Automaticamente reescrito a rtk-windows git status
```

## Como funciona

```
  Sin rtk:                                         Con rtk:

  Claude  --git status-->  shell  -->  git          Claude  --git status-->  rtk-windows  -->  git
    ^                                   |             ^                      |          |
    |        ~2,000 tokens (crudo)      |             |   ~200 tokens        | filtro   |
    +-----------------------------------+             +------- (filtrado) ---+----------+
```

Cuatro estrategias:

1. **Filtrado inteligente** - Elimina ruido (comentarios, espacios, boilerplate)
2. **Agrupacion** - Agrega elementos similares (archivos por directorio, errores por tipo)
3. **Truncamiento** - Mantiene contexto relevante, elimina redundancia
4. **Deduplicacion** - Colapsa lineas de log repetidas con contadores

## Comandos

### Archivos
```powershell
rtk-windows ls .                        # Arbol de directorios optimizado
rtk-windows read file.rs                # Lectura inteligente
rtk-windows find "*.rs" .               # Resultados compactos
rtk-windows grep "pattern" .            # Busqueda agrupada por archivo
```

### Git
```powershell
rtk-windows git status                  # Estado compacto
rtk-windows git log -n 10               # Commits en una linea
rtk-windows git diff                    # Diff condensado
rtk-windows git push                    # -> "ok main"
```

### Tests
```powershell
rtk-windows jest                        # Jest compacto
rtk-windows vitest                      # Vitest compacto
rtk-windows pytest                      # Tests Python (-90%)
rtk-windows go test                     # Tests Go (-90%)
rtk-windows cargo test                  # Tests Rust (-90%)
rtk-windows test <cmd>                  # Solo fallos (-90%)
```

### Build & Lint
```powershell
rtk-windows lint                        # ESLint agrupado por regla
rtk-windows tsc                         # Errores TypeScript agrupados
rtk-windows cargo build                 # Build Cargo (-80%)
rtk-windows ruff check                  # Lint Python (-80%)
```

### Analiticas
```powershell
rtk-windows gain                        # Estadisticas de ahorro
rtk-windows gain --graph                # Grafico ASCII (30 dias)
rtk-windows discover                    # Descubrir ahorros perdidos
```

## Documentacion

- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Resolver problemas comunes
- **[INSTALL.md](INSTALL.md)** - Guia de instalacion detallada
- **[ARCHITECTURE.md](docs/contributing/ARCHITECTURE.md)** - Arquitectura tecnica

## Contribuir

Las contribuciones son bienvenidas. Abre un issue o PR en [GitHub](https://github.com/luysantanadev/rtk-windows.git).

Unete a la comunidad en [Discord]().

## Licencia

Licencia MIT - ver [LICENSE](LICENSE) para detalles.

## Descargo de responsabilidad

Ver [DISCLAIMER.md](DISCLAIMER.md).



