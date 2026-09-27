# Inventário de Hardware

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria coleta informações locais de hardware e do sistema operacional em JSON portável, pronto para revisão de inventário e complementação posterior. Ela não registra ativos num CMDB remoto nem transmite os dados coletados.

## Obrigações Contratuais

- Aceitar um diretório de saída, com padrão `inventory` ou `INVENTORY_OUTPUT_DIRECTORY`.
- Usar as APIs CIM e de discos físicos do Windows no PowerShell, e `dmidecode`, `lscpu`, `free`, `lsblk` e `lspci` no Bash, quando disponíveis.
- Lidar com comandos ou campos indisponíveis sem inventar valores sensíveis.
- Gerar `inventory-with-placeholders.json` e `inventory-with-null-fields.json`.
- Preservar o esquema documentado para número de série, fabricante, modelo, hostname, sistema operacional, estado ativo, processador, memória, disco, placa de vídeo, tipo de ativo, datas, monitor e garantia.

### Resultados Gerados

O arquivo com placeholders contém textos explícitos de substituição nos campos que exigem complementação manual. O arquivo com campos nulos usa `null` do JSON nesses campos. Os dois contêm dados da máquina local e podem incluir números de série, hostnames e identificadores de hardware.

### Segurança e Recuperação

Proteja o diretório de saída e remova campos sensíveis antes de compartilhar. Uma nova execução sobrescreve os dois arquivos JSON, então arquive os resultados anteriores quando a comparação histórica importar. No Bash, o `dmidecode` pode exigir acesso elevado; a falta de privilégio deve ser informada, não contornada de forma insegura.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório de saída | `-OutputDirectory` | `INVENTORY_OUTPUT_DIRECTORY` ou `$1` | `inventory` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: cmdlets CIM do Windows para o PowerShell. O Bash exige `jq`, `dmidecode`, `lscpu`, `free`, `lsblk` e `lspci`; privilégios de root podem ser necessários para dados completos de hardware.

PowerShell: `./collect-inventory.ps1 -OutputDirectory ./inventory`

Bash: `./collect-inventory.sh ./inventory`

## Telemetria e Observabilidade

Apenas o status local da coleta e os caminhos de saída são informados. Não há chamadas de rede nem telemetria externa. Trate o JSON gerado como evidência de inventário sensível.

## Verificação

Valide as duas saídas como JSON, confirme que os dois arquivos existem, inspecione o esquema estável, teste a falta de comandos da plataforma e verifique que credenciais ou dados não relacionados do usuário não são coletados.
