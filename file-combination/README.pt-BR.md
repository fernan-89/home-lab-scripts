# Combinação de Arquivos de Texto

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário cria um único pacote de texto local a partir dos arquivos `.txt` do nível superior. Serve para revisão, transferência ou preparação de arquivamento, e não altera os arquivos de origem.

## Obrigações Contratuais

- Aceitar um diretório de entrada e um nome de arquivo de saída, com padrão no diretório atual e `combined.txt`.
- Selecionar apenas os arquivos `.txt` do nível superior e ordená-los de forma determinística.
- Excluir o arquivo de saída pelo caminho canônico, para que ele não inclua a si mesmo.
- Concatenar o conteúdo das origens em ordem, tratando UTF-8, e sobrescrever apenas a saída configurada.
- Informar a quantidade de arquivos de origem e o caminho da saída.
- Falhar com mensagem clara se o diretório de entrada ou o destino da saída forem inválidos.

### Resultados Gerados

A saída é um arquivo de texto com o conteúdo de todos os arquivos de origem selecionados. Os scripts não adicionam metadados ocultos nem separadores além do conteúdo de origem, e não percorrem subdiretórios. Uma saída existente é substituída de propósito.

### Segurança e Recuperação

Revise o conjunto de origem antes de executar e faça backup de uma saída existente, se ela for importante. Os arquivos de origem são lidos, nunca apagados ou alterados. O conteúdo combinado pode conter credenciais ou dados privados; inspecione-o antes de compartilhar.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório de entrada | `-InputDirectory` | `$1` | diretório atual |
| Arquivo de saída (dentro do diretório de entrada) | `-OutputFile` | `$2` | `combined.txt` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: PowerShell ou Bash com permissão de leitura e escrita no diretório.

PowerShell: `./combine-text-files.ps1 -InputDirectory C:\path\to\files -OutputFile combined.txt`

Bash: `./combine-text-files.sh /path/to/files combined.txt`

## Telemetria e Observabilidade

Apenas mensagens locais com a contagem e o caminho da saída são emitidas. Não há chamadas de rede nem telemetria externa. A saída pode reproduzir texto sensível das origens e deve ficar com acesso controlado.

## Verificação

Teste entrada vazia, vários arquivos, arquivos em subdiretórios, nomes com espaços, uma saída já existente e um nome de saída que coincidiria com uma entrada. Confirme que a saída exclui a si mesma e preserva a ordem das origens.
