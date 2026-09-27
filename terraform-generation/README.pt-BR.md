# Geração de Terraform

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria gera um esqueleto mínimo de variáveis Terraform para um novo workspace de infraestrutura. Ela cria apenas declarações de entrada e orientações; não inicializa o Terraform, não cria state, não contata providers e não provisiona recursos.

## Obrigações Contratuais

- Aceitar um diretório de saída, a região da nuvem e o ID do projeto MongoDB.
- Usar por padrão `./terraform`, `REPLACE_WITH_REGION` e `REPLACE_WITH_PROJECT_ID`, ou as variáveis de ambiente correspondentes.
- Criar exatamente `variables.tf` e um `README.md` local no diretório escolhido.
- Declarar, para Terraform `>= 1.5.0`, as variáveis `cloud_region`, `mongodb_project_id`, `mongodb_public_key` e a sensível `mongodb_private_key`.
- Usar placeholders e nunca gravar credenciais, contas, endpoints ou identificadores privados reais.
- Exigir autorização explícita de sobrescrita antes de substituir arquivos já gerados.

### Resultados Gerados

O `variables.tf` contém apenas declarações de variáveis; nenhuma configuração de provider, recurso, módulo, backend, state ou rede é criada. O README gerado explica as entradas e o tratamento de segredos. O diretório de saída pode ser criado, e os dois arquivos só podem ser sobrescritos com autorização.

### Segurança e Recuperação

Revise o diretório de saída antes de gerar. Informe as credenciais por um gerenciador de segredos ou variáveis protegidas no momento da execução, nunca editando os arquivos versionados do esqueleto. Se os arquivos gerados estiverem errados, remova apenas o diretório do esqueleto ou restaure-o pelo controle de versão; não há rollback na nuvem porque nenhuma infraestrutura foi provisionada.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório de saída | `-OutputDirectory` ou `TERRAFORM_OUTPUT_DIRECTORY` | `TERRAFORM_OUTPUT_DIRECTORY` ou `$1` | `./terraform` |
| Região da nuvem | `-Region` ou `CLOUD_REGION` | `CLOUD_REGION` | `REPLACE_WITH_REGION` |
| ID do projeto MongoDB Atlas | `-MongoDbProjectId` ou `MONGODB_PROJECT_ID` | `MONGODB_PROJECT_ID` | `REPLACE_WITH_PROJECT_ID` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: PowerShell ou Bash. O Terraform é necessário para validar os arquivos gerados.

PowerShell: `./generate-infrastructure.ps1 -OutputDirectory ./terraform`

Bash: `./generate-infrastructure.sh ./terraform`

## Telemetria e Observabilidade

Apenas os caminhos gerados e o status local são informados. Não há chamadas a providers nem telemetria externa. Trate o README e as variáveis gerados como artefatos de configuração até serem revisados.

## Verificação

Inspecione os dois arquivos, valide a sintaxe do Terraform quando ele estiver disponível, teste valores placeholder e personalizados, teste a recusa de sobrescrita e confirme que nenhum bloco de provider, recurso ou backend nem segredo real foi gerado.
