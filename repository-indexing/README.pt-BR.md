# Indexação de Repositório

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário cria um inventário local de metadados de um repositório. Ele ignora o conteúdo de propósito: registra caminhos, tipos, tamanhos e datas dos arquivos sem ler o corpo deles nem chamar serviços externos de IA.

## Obrigações Contratuais

- Aceitar um caminho raiz e um nome de arquivo de saída, com padrão no diretório atual e `README_INDEX.md`.
- No PowerShell, percorrer subdiretórios apenas com `-Recurse`; no Bash, a recursão é controlada por `RECURSIVE=true` e vem habilitada por padrão.
- Excluir do inventário exatamente o caminho da saída.
- Ordenar as entradas de forma determinística e gerar links Markdown relativos, extensão/tipo em maiúsculas, tamanho em bytes e data de modificação no formato UTC.
- Normalizar separadores de caminho e lidar com espaços com segurança.
- Sobrescrever apenas o arquivo de saída escolhido e informar seu caminho.

### Resultados Gerados

A tabela Markdown gerada tem as colunas `File`, `Type`, `Size` e `Last Modified`. Ela contém uma linha por arquivo selecionado e nenhum conteúdo de arquivo. O `README_INDEX.md` existente, ou a saída configurada, é substituído, o que evita que o índice inclua a si mesmo.

### Segurança e Recuperação

Caminhos, nomes, tamanhos e datas podem expor a estrutura do repositório. Revise e proteja o índice antes de compartilhar. O utilitário não altera nem apaga arquivos de origem, não envia dados e não chama serviços de IA.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório raiz | `-RootPath` | `$1` | diretório atual |
| Arquivo de saída (dentro da raiz) | `-OutputFile` | `$2` | `README_INDEX.md` |
| Percorrer subdiretórios | `-Recurse` | `RECURSIVE=true` / `false` | desligado (PowerShell), ligado (Bash) |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: PowerShell ou Bash com permissão de leitura na árvore e de escrita no caminho da saída.

PowerShell, recursivo: `./index-repository.ps1 -RootPath C:\path\to\repository -Recurse`

Bash, recursivo: `RECURSIVE=true ./index-repository.sh /path/to/repository README_INDEX.md`

Trate os metadados gerados como potencialmente sensíveis, porque caminhos e datas podem revelar informações locais.

## Telemetria e Observabilidade

Apenas o caminho local da saída é informado. A própria tabela é o artefato de diagnóstico; nenhuma telemetria externa é coletada.

## Verificação

Teste os modos recursivo e não recursivo, a autoexclusão da saída, um diretório vazio, nomes com espaços, raízes inválidas e execuções repetidas. Confirme que cada linha aponta para um caminho relativo à raiz escolhida e que nenhum conteúdo é embutido.
