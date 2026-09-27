# Indexação de Diretórios

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário produz uma visão navegável em Markdown da estrutura de diretórios, para revisão local e passagem de conhecimento. Ele registra apenas nomes e hierarquia; não lê o conteúdo dos arquivos nem contata serviços externos.

## Obrigações Contratuais

- Aceitar um caminho raiz, um nome de arquivo de saída e uma profundidade máxima.
- Usar por padrão o diretório atual, `README.md` e profundidade ilimitada.
- Listar os diretórios abaixo da raiz, normalizar os links com `/` e ordená-los de forma determinística.
- Gerar `# Directory Index` seguido de links no formato `- [caminho/relativo](caminho/relativo/)`.
- Gravar o documento em `<raiz>/<saída>` e sobrescrever intencionalmente exatamente essa saída.
- Falhar com mensagem clara se a raiz não existir ou se a saída não puder ser gravada.

### Resultados Gerados

A saída é um índice de diretórios em Markdown. Contém um link por diretório encontrado e nenhum conteúdo de arquivo, tamanho de arquivo ou URL externa.

### Segurança e Recuperação

Confira o destino antes de sobrescrever um README existente. Nomes de diretórios podem revelar a estrutura do projeto, então trate o índice gerado como potencialmente sensível. O utilitário não altera os diretórios de origem.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório raiz | `-RootPath` | `$1` | diretório atual |
| Arquivo de saída (dentro da raiz) | `-OutputFile` | `$2` | `README.md` |
| Profundidade máxima | `-MaxDepth` | `MAX_DEPTH` | `0` (sem limite) |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: PowerShell ou Bash e permissão de escrita no diretório de destino.

PowerShell: `./generate-directory-index.ps1 -RootPath ./data -MaxDepth 3`

Bash: `MAX_DEPTH=3 ./generate-directory-index.sh ./data README.md`

## Telemetria e Observabilidade

Apenas o caminho da saída é informado localmente. Não há telemetria, chamadas de rede nem envio de dados. As falhas indicam a raiz ou a saída inválida sem expor o conteúdo dos arquivos.

## Verificação

Teste profundidade ilimitada e limitada, uma árvore vazia, diretórios aninhados, nomes com espaços ou caracteres de Markdown, uma raiz inválida e uma saída sem permissão de escrita. Confirme que os links são relativos à raiz escolhida.
