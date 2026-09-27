# Migração de Etiquetas de Ativos

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário faz uma migração de dados local e determinística em registros de ativos em JSON. Ele não descobre hardware, não chama API e não publica dados. Sua única alteração é atribuir valores sequenciais de `assetTag` aos arquivos JSON do nível superior escolhidos pelo operador.

## Obrigações Contratuais

- Ler apenas os arquivos `*.json` do nível superior e processá-los em ordem alfabética de nome.
- Aceitar, em cada arquivo, um objeto JSON ou um array de objetos JSON.
- Atribuir uma etiqueta ao objeto e uma etiqueta a cada elemento do array.
- Usar um prefixo configurável, `ASSET-` por padrão, e numeração de três dígitos a partir de `001`.
- Preservar o formato objeto/array e sobrescrever cada arquivo de origem somente após a leitura bem-sucedida.
- Falhar se o diretório não existir, se o JSON for inválido ou se faltar a dependência `jq` no Bash.

### Resultados Gerados

Nenhum arquivo de relatório é criado. Cada arquivo de entrada é regravado com os campos `assetTag` atualizados. Por exemplo, um objeto recebe `ASSET-001`; o próximo objeto ou elemento do array recebe `ASSET-002`. Os scripts exibem a quantidade de arquivos encontrados, o nome de cada arquivo atualizado e o próximo número da sequência.

### Segurança e Recuperação

Faça backup ou commit do diretório de entrada antes de executar. Revise o diff gerado e confirme que a ordem da numeração corresponde à ordem de negócio desejada; o nome dos arquivos e a ordem dos arrays definem a atribuição. A migração não percorre subdiretórios e não transmite o conteúdo dos arquivos.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório dos JSON | `-JsonDirectory` | `JSON_DIRECTORY` ou `$1` | obrigatório |
| Prefixo da etiqueta | `-AssetTagPrefix` ou `ASSET_TAG_PREFIX` | `ASSET_TAG_PREFIX` | `ASSET-` |
| Primeiro número da sequência | `-StartNumber` | `START_NUMBER` | `1` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: PowerShell com os cmdlets de JSON, ou Bash com `jq`. Faça backup do diretório de entrada antes de executar.

PowerShell: `./update-asset-tags.ps1 -JsonDirectory C:\path\to\json -AssetTagPrefix ASSET- -StartNumber 1`

Bash: `ASSET_TAG_PREFIX=ASSET- START_NUMBER=1 ./update-asset-tags.sh /path/to/json`

## Telemetria e Observabilidade

Apenas mensagens locais de progresso são emitidas. Não há telemetria externa nem acesso à rede. Os arquivos JSON podem conter identificadores de ativos e devem ser tratados como sensíveis após a migração.

## Verificação

Teste um objeto, um array, vários arquivos, um diretório vazio, JSON inválido, prefixo personalizado e um número inicial diferente do padrão. Valide os arquivos resultantes com um parser de JSON antes de importá-los em outro lugar.
