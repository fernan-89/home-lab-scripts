# Renomeação de Arquivos em Lote

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário aplica uma política de nomes controlada aos arquivos de um diretório. Foi feito para organização local repetível: a simulação é o padrão e a alteração precisa ser habilitada explicitamente pelo operador.

## Obrigações Contratuais

- Inspecionar os arquivos do nível superior em ordem determinística.
- Montar nomes no formato `ABC-DEF-001-RANDOMID-YYYYMMDD.extensão`.
- Derivar o prefixo de três caracteres das duas palavras informadas e preservar a extensão original.
- Exibir cada nome de origem e de destino proposto antes de qualquer renomeação.
- Executar em modo de simulação por padrão; exigir `-Apply` ou `APPLY_CHANGES=true` para alterar.
- Recusar diretórios inválidos, palavras vazias, destinos duplicados e colisão com arquivos de destino existentes.

### Resultados Gerados

Os scripts não criam arquivo de relatório. Eles geram o mapeamento na saída padrão e, no modo de aplicação, renomeiam os arquivos no lugar. A sequência e a data são geradas a cada execução; o identificador aleatório evita reutilizar um nome por acidente. O conteúdo dos arquivos não é alterado.

### Segurança e Recuperação

Execute primeiro a simulação e revise cada destino. Faça backup ou commit antes de aplicar. Uma renomeação que falhar ou for interrompida pode exigir recuperação manual a partir do mapeamento exibido; os scripts nunca devem sobrescrever um arquivo existente.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório | `-Directory` | `$1` | obrigatório |
| Primeira palavra (prefixo) | `-FirstWord` | `$2` | obrigatório |
| Segunda palavra (prefixo) | `-SecondWord` | `$3` | obrigatório |
| Aplicar as renomeações | `-Apply` | `APPLY_CHANGES=true` | desligado (simulação) |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: PowerShell ou Bash com permissão para renomear os arquivos.

PowerShell, simulação: `./rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper`

PowerShell, aplicar: `./rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper -Apply`

Bash, simulação: `./rename-files.sh /path/to/files mobile wallpaper`

Bash, aplicar: `APPLY_CHANGES=true ./rename-files.sh /path/to/files mobile wallpaper`

## Telemetria e Observabilidade

A saída contém apenas os mapeamentos propostos, os mapeamentos aplicados e mensagens de nenhuma alteração. Não há chamadas de rede nem telemetria externa. Nomes de arquivos podem revelar informações de negócio, então redirecione a saída somente para um local controlado.

## Verificação

Teste o modo de simulação, o modo de aplicação num diretório temporário, entrada vazia, espaços nos nomes, palavras inválidas, destinos duplicados e um arquivo de destino já existente. Confirme que as extensões não mudam e que o diretório final não teve nenhuma sobrescrita indesejada.
