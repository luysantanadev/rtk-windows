<p align="center">
  <strong>rtk-windows — Windows용 고성능 CLI 프록시 (LLM 토큰 소비 60-90% 감소)</strong>
</p>

<p align="center">
  <a href="https://github.com/luysantanadev/rtk-windows.git/actions"><img src="https://img.shields.io/github/actions/workflow/status/luysantanadev/rtk-windows/ci.yml" alt="CI"></a>
  <a href="https://github.com/luysantanadev/rtk-windows.git/releases"><img src="https://img.shields.io/github/v/release/luysantanadev/rtk-windows" alt="Release"></a>
  <a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License: Apache-2.0"></a>
</p>

<p align="center">
  <a href="#설치">설치</a> &bull;
  <a href="#설치">설치</a> &bull;
  <a href="docs/TROUBLESHOOTING.md">문제 해결</a> &bull;
  <a href="docs/contributing/ARCHITECTURE.md">아키텍처</a>
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

**rtk-windows**는 Windows 전용 포크로, 명령 출력이 LLM 컨텍스트에 도달하기 전에 필터링하고 압축합니다. 단일 Rust 바이너리, 의존성 없음, 10ms 미만의 오버헤드.

> **Windows만:** 이 프로젝트는 Windows 10/11 및 PowerShell Core 또는 Command Prompt 에서만 지원됩니다.
>
> **독립적 포크:** 이는 Windows 중심의 독립적 구현입니다. 어떤 업스트림 프로젝트와도 제휴되지 않았습니다.

## 토큰 절약 (30분 Claude Code 세션)

| 작업 | 빈도 | 표준 | rtk-windows | 절약 |
|------|------|------|-----|------|
| `ls` / `tree` | 10x | 2,000 | 400 | -80% |
| `cat` / `read` | 20x | 40,000 | 12,000 | -70% |
| `grep` / `rg` | 8x | 16,000 | 3,200 | -80% |
| `git status` | 10x | 3,000 | 600 | -80% |
| `cargo test` / `npm test` | 5x | 25,000 | 2,500 | -90% |
| **합계** | | **~118,000** | **~23,900** | **-80%** |

## 설치

### Windows binary (recommended)

```powershell
# Download rtk-windows-x86_64-pc-windows-msvc.zip from Releases
# Extract rtk-windows.exe and add it to PATH
``` 

### Cargo

```powershell
cargo install --git https://github.com/luysantanadev/rtk-windows.git
```

### 확인

```powershell
rtk-windows --version   # "rtk-windows 0.27.x" 표시되어야 함
rtk-windows gain        # 토큰 절약 통계 표시되어야 함
```

## 빠른 시작

```powershell
# 1. Claude Code용 hook 설치 (권장)
rtk-windows init --global

# 2. Claude Code 재시작 후 테스트
git status  # 자동으로 rtk-windows git status로 재작성
```

## 작동 원리

```
  rtk-windows 없이:                                        rtk-windows 사용:

  Claude  --git status-->  shell  -->  git          Claude  --git status-->  rtk-windows  -->  git
    ^                                   |             ^                      |          |
    |        ~2,000 tokens (원본)        |             |   ~200 tokens        | 필터     |
    +-----------------------------------+             +------- (필터링) -----+----------+
```

네 가지 전략:

1. **스마트 필터링** - 노이즈 제거 (주석, 공백, 보일러플레이트)
2. **그룹화** - 유사 항목 집계 (디렉토리별 파일, 유형별 에러)
3. **잘라내기** - 관련 컨텍스트 유지, 중복 제거
4. **중복 제거** - 반복 로그 라인을 카운트와 함께 통합

## 명령어

### 파일
```powershell
rtk-windows ls .                        # 최적화된 디렉토리 트리
rtk-windows read file.rs                # 스마트 파일 읽기
rtk-windows find "*.rs" .               # 컴팩트한 검색 결과
rtk-windows grep "pattern" .            # 파일별 그룹화 검색
```

### Git
```powershell
rtk-windows git status                  # 컴팩트 상태
rtk-windows git log -n 10               # 한 줄 커밋
rtk-windows git diff                    # 압축된 diff
rtk-windows git push                    # -> "ok main"
```

### 테스트
```powershell
rtk-windows jest                        # Jest 컴팩트
rtk-windows vitest                      # Vitest 컴팩트
rtk-windows pytest                      # Python 테스트 (-90%)
rtk-windows go test                     # Go 테스트 (-90%)
rtk-windows test <cmd>                  # 실패만 표시 (-90%)
```

### 빌드 & 린트
```powershell
rtk-windows lint                        # ESLint 규칙별 그룹화
rtk-windows tsc                         # TypeScript 에러 그룹화
rtk-windows cargo build                 # Cargo 빌드 (-80%)
rtk-windows ruff check                  # Python 린트 (-80%)
```

### 분석
```powershell
rtk-windows gain                        # 절약 통계
rtk-windows gain --graph                # ASCII 그래프 (30일)
rtk-windows discover                    # 놓친 절약 기회 발견
```

## 문서

- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - 일반적인 문제 해결
- **[INSTALL.md](INSTALL.md)** - 상세 설치 가이드
- **[ARCHITECTURE.md](docs/contributing/ARCHITECTURE.md)** - 기술 아키텍처

## 커뮤니티

이것은 Windows 중심의 독립적 포크입니다. 엔터프라이즈 또는 사용자 정의 배포는 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요.

## 라이선스

Apache 2.0 라이선스 - 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.

## 면책 조항

자세한 내용은 [DISCLAIMER.md](DISCLAIMER.md)를 참조하세요.



