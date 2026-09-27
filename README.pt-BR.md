# Home Lab Scripts

🇺🇸 [English](README.md) · 🇧🇷 Português

**Versão:** v1.3.0

**Status:** Kit de automação pronto para uso público

Utilitários multiplataforma em PowerShell e Bash para automação segura de home lab, diagnóstico de rede, inventário de hardware, manutenção de repositórios Git, implantação com Docker, fluxos de Terraform e operações de infraestrutura.

## Visão Geral

O Home Lab Scripts é uma coleção multiplataforma de utilitários operacionais para infraestrutura local, diagnóstico de rede, inventário de hardware, manutenção de repositórios Git, implantação com Docker, documentação de Terraform, configuração de SSH e migrações controladas de arquivos ou dados.

Cada tarefa mantida é organizada por capacidade e oferece implementações em PowerShell e Bash com o mesmo propósito. A configuração é feita por parâmetros ou variáveis de ambiente, e não por caminhos pessoais, hostnames privados, credenciais, tokens ou domínios privados.

O repositório é composto, de propósito, por scripts pequenos e fáceis de inspecionar, e não por uma única aplicação. Cada categoria tem um `README.md` em inglês e seu espelho em português do Brasil, o `README.pt-BR.md`, com tabelas de configuração, pré-requisitos e exemplos de execução, além de um `generate-pair.prompt.md` independente que outra IA pode usar para recriar o par a partir de um diretório vazio.

## Tecnologias

* **Shells:** Windows PowerShell / PowerShell Core e Bash 4+
* **Ferramentas de repositório:** Git e GitHub CLI (`gh`), onde explicitamente necessário
* **Contêineres:** Docker CLI e Docker Engine
* **Infraestrutura:** geração de entradas Terraform e documentação em Markdown
* **Ferramentas de rede:** `ping`, `traceroute`/`tracert`, `curl` e cmdlets de rede da plataforma
* **Ferramentas de hardware:** Windows CIM, `dmidecode`, `lscpu`, `free`, `lsblk`, `lspci` e `jq`
* **Formatos de dados:** JSON, Markdown, HCL, variáveis de ambiente do shell e configuração do Git
* **Modelo de segurança:** segredos externos ao código, flags explícitas para operações destrutivas, backups gerados da configuração SSH e indexação de repositório apenas local

## Estrutura do Repositório

```text
home-lab-scripts/
├── <categoria>/
│   ├── <tarefa>.ps1
│   ├── <tarefa>.sh
│   ├── README.md                   # inglês
│   ├── README.pt-BR.md             # português do Brasil
│   └── generate-pair.prompt.md
├── .github/workflows/validate.yml  # CI: sintaxe dos scripts, shellcheck, verificação da documentação
├── .gitattributes                  # quebra de linha LF no Bash, CRLF no PowerShell
├── README.md
├── README.pt-BR.md
└── LICENSE                         # PolyForm Strict License 1.0.0
```

Cada categoria tem um par de scripts, um README local em inglês e em português, e um contrato `generate-pair.prompt.md` que descreve como gerar o par de novo. As versões em PowerShell e Bash têm o mesmo propósito operacional, respeitando os comandos e as convenções nativas de cada plataforma. Não há subpastas dentro das categorias.

## Recriando uma Categoria do Zero

O prompt local de geração é uma especificação portátil para outra IA. Ele deve exigir que a IA:

1. Gere exatamente o script PowerShell, o script Bash e o README local indicados.
2. Preserve as entradas, os padrões, os formatos de saída, os efeitos colaterais e as escolhas de comandos de cada plataforma documentados.
3. Mantenha segredos, caminhos privados, hostnames, endereços IP, tokens e identificadores pessoais fora dos arquivos de código.
4. Produza comportamento equivalente, tratamento de erro explícito, controles seguros de alteração e logs em inglês padrão.
5. Inclua `Architectural Role`, `Contractual Obligations` e `Telemetry & Observability` apenas no README local.
6. Valide o PowerShell com o parser, rode `bash -n` onde houver Bash e teste os menores casos relevantes de sucesso e de falha.
7. Não altere o `README.md` da raiz nem o `LICENSE`, a menos que o operador peça explicitamente mudanças na documentação do repositório.

Os prompts geram de novo o `README.md` em inglês; atualize o `README.pt-BR.md` na mesma mudança, para que as duas línguas mantenham as mesmas seções, tabela de configuração e comandos.

O prompt fica ao lado da implementação de propósito, para que o par, seu contrato operacional e as instruções de regeneração evoluam juntos.

## Princípios Operacionais

### 1. Configuração e Anonimização

Os scripts recebem caminhos, hosts, URLs, nomes de imagem, portas, prefixos e credenciais por parâmetros ou variáveis de ambiente. Valores secretos nunca entram no repositório.

Exemplos:

```powershell
$env:MONGODB_URI = "mongodb://user:password@example.invalid/database"
./docker-deployment/deploy-container.ps1 -RepositoryUrl $env:GIT_REPOSITORY_URL
```

```bash
GIT_REPOSITORY_URL="https://example.invalid/project.git" \
MONGODB_URI="mongodb://user:password@example.invalid/database" \
./docker-deployment/deploy-container.sh
```

Use um gerenciador de segredos, o cofre de segredos da CI ou um ambiente local protegido para as credenciais reais. Não as coloque no histórico de comandos, em arquivos versionados, em relatórios gerados nem na saída do Terraform.

### 2. Simulação Antes de Alterar

Operações que renomeiam pastas ou arquivos rodam em modo de simulação por padrão. Aplique as mudanças somente depois de revisar o mapeamento proposto:

```powershell
./batch-file-renaming/rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper -Apply
```

```bash
APPLY_CHANGES=true ./batch-file-renaming/rename-files.sh /path/to/files mobile wallpaper
```

### 3. Backups e Revisão

Scripts que sobrescrevem JSON, texto ou documentação de Terraform devem ser executados sobre um backup ou uma árvore de trabalho descartável. `git-security-hardening` e `git-repository-setup` criam commits ou publicam mudanças no remoto; inspecione o `git status`, os arquivos gerados e o remoto de destino antes de executar.

### 4. Saídas Sensíveis

O inventário de hardware pode conter números de série e hostnames. Relatórios de rede podem conter endereços privados e públicos, rotas e respostas de serviços externos. A documentação de Terraform pode reproduzir segredos ou identificadores de infraestrutura já presentes nos arquivos `.tf`. Trate toda saída gerada como sensível até revisá-la.

## Mapa das Categorias

| Categoria | Finalidade | PowerShell | Bash |
| --- | --- | --- | --- |
| [asset-tag-migration](asset-tag-migration/README.pt-BR.md) | Adicionar valores sequenciais de `assetTag` a objetos ou arrays JSON. | `update-asset-tags.ps1` | `update-asset-tags.sh` |
| [batch-file-renaming](batch-file-renaming/README.pt-BR.md) | Renomear arquivos com prefixo gerado, sequência, ID aleatório e data. | `rename-files.ps1` | `rename-files.sh` |
| [directory-indexing](directory-indexing/README.pt-BR.md) | Gerar um índice de diretórios em Markdown. | `generate-directory-index.ps1` | `generate-directory-index.sh` |
| [docker-deployment](docker-deployment/README.pt-BR.md) | Clonar, gerar a imagem e executar uma aplicação em Docker. | `deploy-container.ps1` | `deploy-container.sh` |
| [file-combination](file-combination/README.pt-BR.md) | Combinar os arquivos de texto do nível superior num único arquivo. | `combine-text-files.ps1` | `combine-text-files.sh` |
| [gemini-export](gemini-export/README.pt-BR.md) | Abrir uma URL de chat compartilhado aprovada e criar um arquivo para exportação manual. | `export-shared-chat.ps1` | `export-shared-chat.sh` |
| [git-repository-bootstrap](git-repository-bootstrap/README.pt-BR.md) | Inicializar um repositório local e configurar seu remoto. | `bootstrap-repository.ps1` | `bootstrap-repository.sh` |
| [git-repository-setup](git-repository-setup/README.pt-BR.md) | Configurar workflows e publicar um repositório existente pelo `gh`. | `setup-existing-repository.ps1` | `setup-existing-repository.sh` |
| [git-security-hardening](git-security-hardening/README.pt-BR.md) | Gerar regras de `.gitignore` e deixar de rastrear artefatos locais. | `configure-git-security.ps1` | `configure-git-security.sh` |
| [hardware-inventory](hardware-inventory/README.pt-BR.md) | Coletar metadados de hardware em JSON, nas variantes com placeholders e com campos nulos. | `collect-inventory.ps1` | `collect-inventory.sh` |
| [network-diagnostics](network-diagnostics/README.pt-BR.md) | Coletar endereços locais, resultados de ping e traceroute. | `inspect-network.ps1` | `inspect-network.sh` |
| [network-mapping](network-mapping/README.pt-BR.md) | Mapear o endereçamento local e público e a rota até um destino configurável. | `map-network.ps1` | `map-network.sh` |
| [network-performance](network-performance/README.pt-BR.md) | Medir latência, jitter e, opcionalmente, o desempenho de download HTTPS. | `measure-network.ps1` | `measure-network.sh` |
| [repository-indexing](repository-indexing/README.pt-BR.md) | Criar um inventário local de arquivos, sem IA externa nem envio de dados. | `index-repository.ps1` | `index-repository.sh` |
| [repository-training-index](repository-training-index/README.pt-BR.md) | Criar um retrato local em Markdown do conteúdo dos arquivos, para treinamento e revisão offline. | `generate-training-index.ps1` | `generate-training-index.sh` |
| [ssh-banner](ssh-banner/README.pt-BR.md) | Instalar um banner SSH genérico antes do login e uma mensagem de status após o login. | `configure-ssh-banner.ps1` | `configure-ssh-banner.sh` |
| [terraform-documentation](terraform-documentation/README.pt-BR.md) | Reunir os arquivos `.tf` em blocos HCL num Markdown. | `document-terraform.ps1` | `document-terraform.sh` |
| [terraform-generation](terraform-generation/README.pt-BR.md) | Gerar um esqueleto mínimo de variáveis Terraform. | `generate-infrastructure.ps1` | `generate-infrastructure.sh` |

Cada linha desta tabela também contém `README.md`, `README.pt-BR.md` e `generate-pair.prompt.md`.

## Artefatos Gerados e Efeitos Colaterais

O README local de cada categoria é a descrição oficial do seu contrato detalhado. Este resumo torna visíveis, na revisão, os efeitos no repositório como um todo:

| Categoria | Principal artefato gerado ou alteração | Efeito colateral externo |
| --- | --- | --- |
| [asset-tag-migration](asset-tag-migration/README.pt-BR.md) | Regrava os arquivos JSON do nível superior com valores sequenciais de `assetTag`. | Nenhum; apenas alteração de arquivos locais. |
| [batch-file-renaming](batch-file-renaming/README.pt-BR.md) | Renomeia os arquivos do nível superior com um padrão de nomes gerado. | Nenhum; a simulação é o padrão. |
| [directory-indexing](directory-indexing/README.pt-BR.md) | Grava um índice Markdown de links para os diretórios. | Nenhum; apenas metadados locais. |
| [docker-deployment](docker-deployment/README.pt-BR.md) | Clona o código, gera uma imagem, remove e substitui um contêiner e o inicia. | Runtime do Docker e acesso ao repositório. |
| [file-combination](file-combination/README.pt-BR.md) | Grava um único arquivo de texto combinado a partir das entradas `.txt` do nível superior. | Nenhum; saída em arquivo local. |
| [gemini-export](gemini-export/README.pt-BR.md) | Abre uma URL compartilhada aprovada e grava um Markdown de espaço reservado. | Apenas abre o navegador; sem scraping. |
| [git-repository-bootstrap](git-repository-bootstrap/README.pt-BR.md) | Cria os metadados Git locais, o `origin`, o README e o commit inicial, quando necessário. | Nenhum push automático. |
| [git-repository-setup](git-repository-setup/README.pt-BR.md) | Grava workflows do GitHub, branches e commits e, opcionalmente, os publica. | GitHub CLI, criação do remoto e pushes. |
| [git-security-hardening](git-security-hardening/README.pt-BR.md) | Grava o `.gitignore`, deixa de rastrear artefatos locais e pode criar um commit de segurança. | Nenhum push automático. |
| [hardware-inventory](hardware-inventory/README.pt-BR.md) | Grava inventários de hardware em JSON com placeholders e com campos nulos. | Nenhum; apenas leituras locais do hardware. |
| [network-diagnostics](network-diagnostics/README.pt-BR.md) | Grava relatórios em JSON ou texto de alcance, endereços e traceroute. | Tráfego de teste para o host escolhido. |
| [network-mapping](network-mapping/README.pt-BR.md) | Grava relatórios de endereços local e público e de mapeamento de rota. | Consulta de IP público e tráfego de traceroute. |
| [network-performance](network-performance/README.pt-BR.md) | Grava relatórios de latência e jitter e, opcionalmente, de transferência HTTPS. | Tráfego ICMP e HTTPS aprovado pelo operador. |
| [repository-indexing](repository-indexing/README.pt-BR.md) | Grava uma tabela Markdown com metadados dos arquivos. | Nenhum; nenhum conteúdo de arquivo é enviado. |
| [repository-training-index](repository-training-index/README.pt-BR.md) | Grava um retrato em Markdown com o conteúdo dos arquivos selecionados. | Nenhum; a saída pode conter segredos. |
| [ssh-banner](ssh-banner/README.pt-BR.md) | Grava o banner SSH, o script de status, o backup e a configuração do daemon. | Alterações com privilégio elevado no host e recarga do serviço. |
| [terraform-documentation](terraform-documentation/README.pt-BR.md) | Grava seções HCL em Markdown a partir dos arquivos `.tf` encontrados recursivamente. | Nenhum; o código de origem pode conter segredos. |
| [terraform-generation](terraform-generation/README.pt-BR.md) | Grava um esqueleto mínimo de `variables.tf` e um README. | Nenhum; sem chamadas a provider nem à infraestrutura. |

## Padrão de Documentação

O README de cada categoria, nas duas línguas, responde às mesmas perguntas de revisão:

- **Papel Arquitetural:** por que o utilitário existe e onde ele entra num fluxo operacional.
- **Obrigações Contratuais:** entradas aceitas, padrões, regras de processamento, estrutura da saída e comportamento em falhas.
- **Resultados Gerados:** os arquivos, relatórios, commits, recursos em execução ou alterações no lugar produzidos pela execução.
- **Segurança e Recuperação:** efeitos destrutivos, saídas sensíveis, backups, pontos de autorização e ações de recuperação.
- **Configuração:** cada entrada, o parâmetro do PowerShell e o argumento ou variável de ambiente do Bash que a define, e seu padrão, extraídos dos scripts.
- **Uso:** pré-requisitos e um exemplo de execução em PowerShell e em Bash.
- **Telemetria e Observabilidade:** mensagens locais, relatórios, chamadas externas e dados que podem aparecer em logs.
- **Verificação:** verificações focadas de sucesso, falha, idempotência e plataforma.

Os scripts continuam concisos e operacionais. O texto de arquitetura fica nesses READMEs, enquanto o `generate-pair.prompt.md` contém o contrato independente de reconstrução para outra IA.

## Início Rápido

### Inspecionar o Repositório

```powershell
./repository-indexing/index-repository.ps1 -RootPath . -Recurse
```

```bash
RECURSIVE=true ./repository-indexing/index-repository.sh . README_INDEX.md
```

### Executar uma Simulação Segura

```powershell
./batch-file-renaming/rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper
```

```bash
./batch-file-renaming/rename-files.sh /path/to/files mobile wallpaper
```

### Endurecer um Repositório Git Existente

```powershell
./git-security-hardening/configure-git-security.ps1 -RepositoryPath C:\path\to\repository
```

```bash
./git-security-hardening/configure-git-security.sh /path/to/repository
```

Revise o `.gitignore` gerado, as alterações em stage e a saída do commit antes de compartilhar o repositório.

## Validação

Os prompts de geração exigem as seguintes verificações para cada par gerado de novo:

```powershell
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
	(Resolve-Path .\category\task.ps1),
	[ref]$null,
	[ref]$errors
) | Out-Null
if ($errors.Count -gt 0) { $errors | ForEach-Object Message; exit 1 }
```

```bash
bash -n category/task.sh
```

O [workflow validate](.github/workflows/validate.yml) executa essas verificações a cada push e pull request, além do `shellcheck` e de uma verificação da documentação: cada categoria tem seus cinco arquivos, e o `README.md` e o `README.pt-BR.md` têm as mesmas seções e comandos.

As verificações de sintaxe e de execução do Bash exigem Bash 4+ no Linux, macOS, WSL ou Git Bash. Scripts que acessam Docker, GitHub, SSH, hardware ou serviços de rede externos devem ser testados num ambiente isolado antes do uso em produção. Nunca execute fluxos destrutivos ou de publicação contra um destino compartilhado antes de revisar os comandos gerados e o README local.

## Catálogo de Prompts

Cada categoria mantém seu `generate-pair.prompt.md` ao lado dos scripts que ele gera, para que o par, seu contrato operacional e as instruções de regeneração mudem juntos, no mesmo commit. Os prompts ficam em inglês, porque são especificações para outra IA.

## Notas de Segurança

* Revogue e troque qualquer credencial que possa ter existido em cópias antigas dos scripts legados.
* Revise o histórico do Git e os forks remotos se algum segredo já tiver sido versionado.
* Não execute scripts de implantação, publicação de repositório, configuração de SSH ou endurecimento sem revisar os caminhos de destino e os efeitos colaterais.
* Use `example.invalid`, variáveis de ambiente e cofres de segredos nos exemplos da documentação.
* Inventários gerados, relatórios de rede e documentação de Terraform não devem ser publicados sem remover os dados sensíveis.

## Licença

Licenciado sob a [PolyForm Strict License 1.0.0](LICENSE): você pode consultar e usar este software apenas para fins não comerciais. Modificar, criar obras derivadas, redistribuir e qualquer uso comercial não são permitidos sem uma licença específica por escrito. Este software não é de código aberto.
