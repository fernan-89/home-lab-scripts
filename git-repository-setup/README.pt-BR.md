# Configuração de Repositório Existente

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria configura um repositório existente para um fluxo de trabalho no GitHub e pode publicar branches pelo GitHub CLI. É uma ferramenta de administração de repositório de alto impacto, não um formatador local passivo. Os arquivos de documentação da raiz, intencionalmente, só são gerados quando o comando final de documentação é autorizado.

## Obrigações Contratuais

- Validar Git, `gh`, autenticação, acesso à rede, estado do repositório e visibilidade antes de alterar qualquer coisa.
- Gerar o modelo de `.gitignore` escolhido e dois arquivos de workflow em `.github/workflows`.
- Configurar o fluxo de branches `developer`, `stage` e `master` conforme documentado.
- Fazer commit das alterações de workflow somente se houver alterações.
- Criar o repositório remoto e enviar as branches somente após autorização explícita.
- Nunca fazer force-push, substituir um remoto não relacionado, exibir tokens ou alterar implicitamente o README da raiz.

### Resultados Gerados

Os scripts podem criar ou substituir `.gitignore`, `promote-developer-to-stage.yml` e `validate-pull-request.yml`, além de um commit como `chore: configure repository workflows`. Com a publicação habilitada, também criam um repositório no GitHub e enviam `developer`, `stage` e `master`.

A visibilidade deve ser `public`, `private` ou `internal`.

### Segurança e Recuperação

Revise os workflows gerados, o dono e o nome de destino, a visibilidade, as branches e o remoto antes de aprovar a publicação. Faça backup ou commit do trabalho local primeiro. Se uma operação remota falhar, inspecione `git status`, `git branch -a` e `gh repo view`; não tente de novo às cegas nem faça force-push.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Caminho do repositório | `-RepositoryPath` | `$1` | obrigatório no PowerShell; diretório atual no Bash |
| Linguagem do modelo de `.gitignore` | `-GitIgnoreLanguage` | `GITIGNORE_LANGUAGE` | `PowerShell` |
| Nome do repositório no GitHub | `-RepositoryName` | `REPOSITORY_NAME` | nome da pasta |
| Visibilidade | `-Visibility` | `REPOSITORY_VISIBILITY` | `private` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: Git, GitHub CLI (`gh`), uma sessão autenticada do `gh` e acesso à rede do GitHub.

PowerShell: `./setup-existing-repository.ps1 -RepositoryPath C:\path\to\repository -GitIgnoreLanguage PowerShell -Visibility private`

Bash: `GITIGNORE_LANGUAGE=PowerShell REPOSITORY_VISIBILITY=private ./setup-existing-repository.sh /path/to/repository`

## Telemetria e Observabilidade

A saída local dos comandos Git e `gh` registra o andamento da configuração e da publicação. Nenhum serviço de telemetria separado é usado. Nomes de repositório, URLs, conteúdo dos workflows e estado das branches podem ser sensíveis; remova-os de logs compartilhados.

## Verificação

Teste falhas de pré-requisito sem o `gh`, visibilidade inválida, geração de workflows num repositório temporário, um remoto já configurado, publicação recusada e a validação bem-sucedida das branches num repositório de teste isolado.
