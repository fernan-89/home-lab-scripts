# Diagnóstico de Rede

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria registra um diagnóstico local de conectividade num momento específico: endereços das interfaces, testes de alcance e um traceroute curto. Ela gera evidências para investigação de problemas e não altera a configuração de rede.

## Obrigações Contratuais

- Aceitar um host de teste configurável, `example.com` por padrão, e um caminho de relatório.
- Coletar os endereços IPv4 locais.
- Executar duas tentativas de ping e um traceroute de oito saltos com as ferramentas nativas da plataforma.
- Continuar quando um teste ou utilitário opcional falhar e representar com clareza a evidência indisponível.
- Gravar JSON estruturado no PowerShell e um relatório de texto legível no Bash, com evidências equivalentes.

### Resultados Gerados

O PowerShell grava `network-report.json` com nome do computador, host de teste, horário UTC, endereços locais, objetos de ping e linhas do traceroute. O Bash grava `network-report.txt` com seções rotuladas de endereços, ping e traceroute. Uma saída existente no caminho escolhido é substituída.

### Segurança e Recuperação

Hosts de teste, endereços, rotas e respostas externas podem ser sensíveis. Use um destino aprovado, proteja o relatório e remova dados sensíveis antes de compartilhar. Os scripts não alteram interfaces, rotas, regras de firewall nem configurações de DNS.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Host de teste | `-ProbeHost` ou `NETWORK_PROBE_HOST` | `NETWORK_PROBE_HOST` ou `$1` | `example.com` |
| Arquivo do relatório | `-OutputFile` | `NETWORK_OUTPUT_FILE` | `network-report.json` (PowerShell), `network-report.txt` (Bash) |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: utilitários de rede e permissão para gravar o relatório. O host de teste é configurável e nenhum endereço privado vem embutido.

PowerShell: `./inspect-network.ps1 -ProbeHost example.com -OutputFile network-report.json`

Bash: `NETWORK_PROBE_HOST=example.com ./inspect-network.sh`

## Telemetria e Observabilidade

Toda a evidência fica no relatório local escolhido. Não há telemetria separada nem envio de dados. As mensagens de status indicam o caminho da saída e as falhas, sem esconder erros dos comandos.

## Verificação

Teste um host alcançável e um inalcançável, a falta dos utilitários de ping e traceroute, um caminho de saída com espaços e execuções repetidas. Confirme que as falhas continuam distinguíveis de resultados vazios.
