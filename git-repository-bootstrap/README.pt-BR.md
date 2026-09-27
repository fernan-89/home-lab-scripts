# Inicialização de Repositório Git

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário inicializa um repositório Git local e prepara o primeiro commit, preservando o estado de um repositório existente. É um inicializador, não um pipeline de publicação: a configuração do remoto é explícita e o histórico nunca é reescrito à força.

## Obrigações Contratuais

- Aceitar um caminho de repositório, uma URL remota obrigatória e uma branch padrão.
- Criar o diretório quando necessário e inicializar o Git apenas se `.git` não existir.
- Preservar repositório, remoto, arquivos e README existentes.
- Adicionar `origin` somente se ele não existir; nunca substituir silenciosamente um remoto já configurado.
- Criar um README mínimo somente se não houver um.
- Adicionar os arquivos ao stage e fazer commit somente se houver alterações, usando a mensagem de inicialização documentada.

### Resultados Gerados

Os scripts podem criar `.git`, `README.md`, a configuração do `origin` e um commit inicial. Eles não geram arquivo de relatório, não publicam branches, não fazem force-push e não apagam conteúdo existente.

### Segurança e Recuperação

Confira o caminho de destino e a URL remota antes de executar. Use um diretório descartável ou versionado nos primeiros testes. Remotos e READMEs existentes são protegidos; revise `git status`, `git remote -v` e o commit antes de qualquer publicação posterior.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Caminho do repositório | `-RepositoryPath` | `REPOSITORY_PATH` ou `$1` | `./repository` |
| URL remota (`origin`) | `-RemoteUrl` ou `GIT_REMOTE_URL` | `GIT_REMOTE_URL` ou `$2` | obrigatório |
| Branch padrão | `-DefaultBranch` | `DEFAULT_BRANCH` | `main` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: Git e um remoto autenticado configurado para a URL informada.

PowerShell: `$env:GIT_REMOTE_URL='https://example.invalid/repository.git'; ./bootstrap-repository.ps1 -RepositoryPath ./repository`

Bash: `GIT_REMOTE_URL=https://example.invalid/repository.git ./bootstrap-repository.sh ./repository`

## Telemetria e Observabilidade

Apenas o status local dos comandos Git, o caminho do repositório e o resumo das alterações são emitidos. A inicialização em si não faz telemetria externa nem push. URLs remotas podem revelar infraestrutura privada e devem ser removidas de logs compartilhados.

## Verificação

Teste um diretório novo, um repositório existente, um `origin` já configurado, a falta da URL remota, uma branch personalizada e uma segunda execução idempotente. Confirme que nenhum arquivo não relacionado é apagado ou reescrito.
