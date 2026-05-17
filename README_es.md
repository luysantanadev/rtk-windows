<p align="center">
  <strong>rtk-windows — Proxy CLI de alto rendimiento para Windows (reducción LLM token 60-90%)</strong>
</p>

<p align="center">
  <a href="https://github.com/luysantanadev/rtk-windows.git/actions"><img src="https://img.shields.io/github/actions/workflow/status/luysantanadev/rtk-windows/ci.yml" alt="CI"></a>
  <a href="https://github.com/luysantanadev/rtk-windows.git/releases"><img src="https://img.shields.io/github/v/release/luysantanadev/rtk-windows" alt="Release"></a>
  <a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License: Apache-2.0"></a>
</p>

<p align="center">
  <a href="#instalacion">Instalar</a> &bull;
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

**rtk-windows** es un fork dedicado a Windows que filtra y comprime las salidas de comandos antes de que lleguen al contexto de tu LLM. Binario Rust único, cero dependencias, <10ms de overhead.

> **Solo Windows:** Este proyecto soporta exclusivamente Windows 10/11 con PowerShell Core o Command Prompt.
>
> **Fork independiente:** Esta es una implementación independiente enfocada en Windows. No está afiliada a ningún proyecto upstream.

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

## Comunidad

Este es un fork independiente enfocado en Windows. Para despliegues empresariales o personalizados, ver [CONTRIBUTING.md](CONTRIBUTING.md).

## Licencia

Licencia Apache 2.0 - ver [LICENSE](LICENSE) para detalles.

## Descargo de responsabilidad

Ver [DISCLAIMER.md](DISCLAIMER.md).



