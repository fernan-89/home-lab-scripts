# Índice de Treinamento do Repositório

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria cria um retrato local em Markdown do conteúdo dos arquivos, para onboarding, revisão ou treinamento offline. Diferente de `repository-indexing`, ela inclui de propósito o corpo dos arquivos e, por isso, exige cuidado maior com a saída gerada.

## Obrigações Contratuais

- Aceitar a raiz do repositório e o nome do arquivo de saída, com padrão no diretório atual e `base_treinamento.md`.
- Listar os arquivos recursivamente em ordem determinística.
- Excluir `.git`, `.idea`, `.gradle`, `build`, `bin` e `obj`, além da própria saída e de todos os scripts geradores.
- Gerar cada arquivo como `## File: caminho/relativo` seguido de um bloco de código sem linguagem com o conteúdo.
- Manter todo o processamento local e informar apenas o caminho da saída.
- Sobrescrever apenas o arquivo de saída escolhido explicitamente.

### Resultados Gerados

O resultado é `base_treinamento.md` ou o caminho Markdown configurado. Ele contém o conteúdo completo dos arquivos incluídos, inclusive prompts, scripts e documentação. Não é um índice compacto e pode ficar grande.

### Segurança e Recuperação

O retrato pode conter credenciais, caminhos privados, identificadores de infraestrutura, código-fonte e documentação confidencial. Revise e remova dados sensíveis antes de compartilhar, guarde-o com permissões restritas e apague ou gere de novo quando o conteúdo mudar. Nunca considere o arquivo gerado seguro para publicação por padrão.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório raiz | `-RootPath` | `$1` | diretório atual |
| Arquivo de saída (dentro da raiz) | `-OutputFile` | `$2` | `base_treinamento.md` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

PowerShell:

```powershell
./generate-training-index.ps1 -RootPath C:\path\to\repository -OutputFile base_treinamento.md
```

Bash:

```bash
./generate-training-index.sh /path/to/repository base_treinamento.md
```

## Telemetria e Observabilidade

Os scripts informam apenas o caminho local da saída e não enviam dados nem fazem telemetria externa. O comportamento das exclusões faz parte do contrato de segurança e deve ser revisto ao surgirem novos diretórios de build ou de IDE.

## Verificação

Confirme que os arquivos incluídos aparecem uma única vez, que os diretórios excluídos não aparecem, que os scripts geradores e a saída se autoexcluem, que caminhos aninhados são normalizados e que conteúdo com blocos de código Markdown continua legível.
