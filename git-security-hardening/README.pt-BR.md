# Endurecimento de Segurança do Git

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário aplica uma política de ignore local ao repositório e tira artefatos locais selecionados do rastreamento do Git sem apagá-los do disco. É uma operação de higiene de segurança com efeito amplo de stage e commit.

## Obrigações Contratuais

- Validar que o destino é um repositório Git com identidade utilizável.
- Gravar regras cobrindo saída de build, arquivos compilados, pacotes, estado da IDE, logs, arquivos temporários, metadados do sistema operacional, relatórios do Postman e segredos de ambiente.
- Deixar de rastrear caminhos configurados como `build/`, `.gradle/`, `.idea/`, `bin/`, `out/` e `*.iml` com `git rm --cached`.
- Manter os arquivos ignorados na árvore de trabalho.
- Exibir o `.gitignore` resultante, o diff em stage e o status final.
- Exigir revisão explícita antes do stage amplo e do commit de segurança.

### Resultados Gerados

O principal artefato gerado é o `.gitignore`. O índice muda para os caminhos rastreados selecionados, e o script pode criar um commit como `security: apply gitignore and untrack local artifacts`. Nenhum arquivo é apagado do disco e nenhum push é feito.

### Segurança e Recuperação

Inspecione `.gitignore`, `git diff --cached` e `git status` antes do commit. Uma regra ampla pode esconder arquivos sem querer; refine-a antes de aprovar. Para recuperar, restaure o `.gitignore` anterior pelo controle de versão e use `git add` para voltar a rastrear um arquivo que deveria estar versionado. Este script não remove segredos do histórico do Git; uma exposição passada exige remediação à parte.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Caminho do repositório | `-RepositoryPath` | `$1` | diretório atual |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

### Pré-requisitos

- Git instalado e disponível no `PATH`.
- Um diretório de destino que já seja um repositório Git.
- Permissão para alterar a árvore de trabalho e criar commits.
- Identidade do Git configurada com `git config user.name` e `git config user.email`.

### PowerShell

Execute de qualquer lugar informando a raiz do repositório:

```powershell
.\configure-git-security.ps1 -RepositoryPath "C:\path\to\repository"
```

Ou execute a partir da raiz do repositório:

```powershell
.\configure-git-security.ps1
```

### Bash

Torne o script executável uma vez e informe a raiz do repositório como primeiro argumento:

```bash
chmod +x ./configure-git-security.sh
./configure-git-security.sh /path/to/repository
```

Ou execute a partir da raiz do repositório:

```bash
./configure-git-security.sh
```

### Observações

- As duas versões fazem commit das alterações automaticamente.
- Revise o `git status` e o `.gitignore` gerado antes de executar este script num repositório compartilhado.
- O script não apaga arquivos ignorados do disco; ele apenas remove os caminhos correspondentes do índice do Git.

## Telemetria e Observabilidade

Apenas o status local do Git, os caminhos em stage e a saída do commit são emitidos. Não há telemetria externa. Caminhos e nomes de arquivos em stage podem revelar a estrutura privada do projeto.

## Verificação

Teste artefatos de build rastreados e não rastreados, regras de ignore existentes, falta de identidade do Git, confirmação recusada e um repositório limpo. Confirme que os arquivos ignorados continuam no disco e que nada muda no remoto.
