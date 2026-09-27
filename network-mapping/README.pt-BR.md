# Mapeamento de Rede

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Este utilitário registra um retrato do endereçamento local e público e um traceroute configurável. É um diagnóstico de observação e não configura interfaces, DNS, rotas nem regras de firewall.

## Obrigações Contratuais

- Aceitar destino do traceroute, URL do serviço de IP público, máximo de saltos e caminho do relatório.
- Usar por padrão `example.com`, `https://api.ipify.org`, 20 saltos e um caminho de relatório local.
- Registrar horário UTC, hostname, IPv4 local, IPv4 público, destino e a saída do traceroute.
- Usar timeout de cinco segundos na consulta do IP público e registrar `Unavailable` quando não for possível resolvê-lo.
- Usar `tracert.exe` no Windows ou `traceroute` em sistemas tipo Unix.
- Preservar a evidência quando uma observação falhar e informar o caminho final do arquivo.

### Resultados Gerados

A saída é um relatório em texto simples com seções rotuladas de endereço local e público, destino, horário e rota. O PowerShell cria o diretório pai quando necessário; o Bash espera que ele já exista. Uma saída existente é sobrescrita.

### Segurança e Recuperação

Endereços privados e públicos, hostnames e rotas são sensíveis. Use destinos aprovados, restrinja o acesso ao relatório e remova dados sensíveis antes de compartilhar. O utilitário não altera a configuração de rede e não envia credenciais ao serviço de IP público.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Destino do traceroute | `-TraceTarget` ou `TRACE_TARGET` | `TRACE_TARGET` ou `$1` | `example.com` |
| Serviço de IP público | `-PublicIpServiceUrl` ou `PUBLIC_IP_SERVICE_URL` | `PUBLIC_IP_SERVICE_URL` | `https://api.ipify.org` |
| Arquivo do relatório | `-ReportPath` ou `NETWORK_REPORT_PATH` | `NETWORK_REPORT_PATH` ou `$2` | `%TEMP%\network-mapping.txt` (PowerShell), `./network-mapping.txt` (Bash) |
| Máximo de saltos | `-MaximumHops` | `MAXIMUM_HOPS` | `20` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: cmdlets de rede do PowerShell e `tracert.exe` no Windows, ou `hostname`, `traceroute` e, opcionalmente, `curl` no Linux/macOS.

PowerShell: `./map-network.ps1 -TraceTarget example.com -ReportPath ./network-mapping.txt`

Bash: `./map-network.sh example.com ./network-mapping.txt`

Variáveis de ambiente: `TRACE_TARGET`, `PUBLIC_IP_SERVICE_URL`, `NETWORK_REPORT_PATH` e `MAXIMUM_HOPS`.

## Telemetria e Observabilidade

Apenas o relatório local e as mensagens de status são produzidos. Não há telemetria externa além da consulta de IP público escolhida pelo operador. O relatório registra evidência suficiente para reproduzir o contexto do diagnóstico.

## Verificação

Teste a consulta de IP público com sucesso e indisponível, a falta do comando de traceroute, um limite de saltos inválido, um caminho de relatório personalizado e um destino inalcançável. Confirme que o valor de fallback é explícito e não pode ser confundido com um endereço real.
