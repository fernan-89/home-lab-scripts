# Desempenho de Rede

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria mede o comportamento da rede sem alterar sua configuração. Ela fornece latência, jitter, contexto de perda de pacotes e, opcionalmente, medições de transferência HTTPS confiáveis numa janela de teste definida.

## Obrigações Contratuais

- Aceitar um ou mais hosts de teste, a quantidade de amostras, URLs HTTPS de teste opcionais e o caminho da saída.
- Usar por padrão quatro amostras ICMP e nenhum teste de download, a menos que URLs sejam informadas.
- Calcular ou registrar amostras de latência, latência média, jitter, perda de pacotes, bytes transferidos, segundos decorridos e megabits por segundo, quando aplicável.
- Baixar o corpo das respostas apenas para um destino descartável; nunca guardá-lo.
- Exigir URLs HTTPS confiáveis, validação de certificado e timeout de 30 segundos no download.
- Preservar medições com falha ou indisponíveis como resultados explícitos.

### Resultados Gerados

O PowerShell grava `network-performance.json` com medições estruturadas por host e por download. O Bash grava `network-performance.txt` com as métricas brutas de ping e transferência rotuladas. Uma saída existente é substituída, e o corpo das respostas de teste não é incluído.

### Segurança e Recuperação

Use hosts e URLs aprovados para teste; testes repetidos de ICMP ou download podem afetar cotas de serviço. Os relatórios podem revelar a topologia e endpoints externos. Os scripts não ajustam interfaces, não alteram rotas e não guardam o conteúdo baixado.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Hosts de teste (separados por vírgula) | `-ProbeHost` ou `NETWORK_PROBE_HOSTS` | `NETWORK_PROBE_HOSTS` ou `$1` | `example.com` |
| Pings por host | `-Count` | `PING_COUNT` | `4` |
| URLs de teste de download (separadas por vírgula, HTTPS) | `-DownloadUrl` ou `NETWORK_TEST_URLS` | `NETWORK_TEST_URLS` | nenhuma (sem teste de download) |
| Arquivo do relatório | `-OutputFile` | `NETWORK_OUTPUT_FILE` | `network-performance.json` (PowerShell), `network-performance.txt` (Bash) |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: acesso ICMP e o utilitário `ping`. Os testes opcionais de download usam URLs HTTPS confiáveis informadas pelo operador; a validação de certificado nunca é desativada.

PowerShell: `./measure-network.ps1 -ProbeHost example.com -Count 4 -DownloadUrl https://example.com/test.bin`

Bash: `PING_COUNT=4 NETWORK_TEST_URLS=https://example.com/test.bin ./measure-network.sh example.com`

## Telemetria e Observabilidade

A saída das medições é local e escolhida pelo operador; nenhum serviço de telemetria separado é usado. O relatório registra as entradas do teste e os horários necessários para interpretar os resultados. Remova endereços privados antes de compartilhar.

## Verificação

Teste um host, vários hosts, perda de pacotes, quantidade de amostras inválida, sem URLs de download, um download HTTPS confiável, o comportamento de timeout e endpoints malformados. Confirme que as métricas não aparecem como sucesso quando as ferramentas falham.
