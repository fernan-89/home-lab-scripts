# Implantação com Docker

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria é um orquestrador local de implantação para uma aplicação em Docker. Ela sincroniza o código-fonte, gera uma imagem, remove a execução anterior configurada e inicia um contêiner substituto em segundo plano. Intencionalmente, não é uma plataforma de release de uso geral.

## Obrigações Contratuais

- Exigir a URL do repositório e a conexão do MongoDB por parâmetros ou variáveis de ambiente.
- Usar diretório de trabalho, nome da imagem, nome do contêiner, porta do host e porta do contêiner configuráveis.
- Validar Git e Docker antes de alterar o diretório de trabalho ou o que está em execução.
- Remover o contêiner, a imagem e o diretório de trabalho configurados, clonar o repositório, gerar a imagem e executá-la em segundo plano com o mapeamento de portas e o `MONGODB_URI` configurados.
- Parar em caso de erro e informar as etapas do ciclo de vida sem exibir valores secretos.

### Resultados Gerados

Nenhum arquivo de relatório é gerado. Os scripts alteram o diretório de trabalho configurado, criam uma imagem Docker, removem a imagem e o contêiner existentes com os nomes escolhidos e criam um contêiner em execução. O contêiner recebe a URI do MongoDB como variável de ambiente e mapeia `HOST_PORT` para `CONTAINER_PORT`.

### Segurança e Recuperação

Esta operação é destrutiva. Revise o diretório de destino, o nome do contêiner, o nome da imagem, o repositório e as portas antes de executar. Use um diretório de código versionado, confirme que o contêiner antigo pode ser removido e guarde a imagem anterior ou as instruções de implantação para poder voltar atrás. Nunca faça commit nem exiba o `MONGODB_URI`; troque a credencial se ela tiver sido exposta.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| URL do repositório Git | `-RepositoryUrl` ou `GIT_REPOSITORY_URL` | `GIT_REPOSITORY_URL` ou `$1` | obrigatório |
| Diretório de trabalho (apagado e clonado de novo) | `-WorkingDirectory` | `APP_DIRECTORY` ou `$2` | `./source` |
| Nome do contêiner | `-ContainerName` ou `CONTAINER_NAME` | `CONTAINER_NAME` | `home-lab-app` |
| Nome da imagem | `-ImageName` ou `IMAGE_NAME` | `IMAGE_NAME` | `home-lab-app:latest` |
| String de conexão do MongoDB | `-MongoDbUri` ou `MONGODB_URI` | `MONGODB_URI` | obrigatório |
| Porta do host | `-HostPort` ou `HOST_PORT` | `HOST_PORT` | `8080` |
| Porta do contêiner | `-ContainerPort` ou `CONTAINER_PORT` | `CONTAINER_PORT` | `8080` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: Git, Docker, uma URL de repositório e o `MONGODB_URI` informado pelo ambiente.

PowerShell: `./deploy-container.ps1 -RepositoryUrl $env:GIT_REPOSITORY_URL`

Bash: `GIT_REPOSITORY_URL=https://example.invalid/project.git MONGODB_URI='mongodb://user:password@example.invalid/db' ./deploy-container.sh`

Variáveis opcionais: `APP_DIRECTORY`, `CONTAINER_NAME`, `IMAGE_NAME`, `HOST_PORT` e `CONTAINER_PORT`.

## Telemetria e Observabilidade

Os scripts emitem a saída local do ciclo de vida do Docker e do Git e o resultado final da inicialização do contêiner. Não coletam telemetria externa. Use `docker ps`, `docker logs` e `docker inspect` após a implantação; remova segredos dos logs capturados.

## Verificação

Valide a configuração com o Docker indisponível, teste com um repositório isolado, confirme a imagem gerada e o mapeamento de portas, inspecione o tratamento das variáveis de ambiente do contêiner e verifique que uma falha no build não gera mensagem falsa de sucesso.
