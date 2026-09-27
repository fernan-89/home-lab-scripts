# Banner SSH

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria configura um banner SSH genérico antes do login e um script de status do sistema após o login, num host Linux. Ela altera a configuração do host e pode recarregar o serviço SSH ativo; não cria usuários, não muda a política de autenticação e não reinicia o host.

## Obrigações Contratuais

- Aceitar o caminho do banner, o caminho da configuração do daemon SSH, o caminho do MOTD/status e o título do banner.
- Usar por padrão `/etc/ssh/ssh_banner`, `/etc/ssh/sshd_config`, `/etc/profile.d/ssh-status.sh` e `AUTHORIZED SYSTEM`.
- Exigir `sudo`, gravar o banner e o script de status, fazer backup da configuração SSH em `.bak` e manter uma única diretiva `Banner` ativa.
- Tornar o script de status executável e exibir hostname, primeiro endereço local, tempo ligado, carga, memória e disco raiz, quando disponíveis.
- Recarregar `ssh` ou `sshd`, o que estiver ativo, após gravar com sucesso; nunca reiniciar serviços silenciosamente.

### Resultados Gerados

Os scripts criam ou substituem o arquivo de banner e o script de status executável, e atualizam o arquivo do daemon SSH configurado. Também criam `<sshd_config>.bak`. Nenhuma conta de usuário, chave, senha, regra de firewall ou método de autenticação é alterado.

### Segurança e Recuperação

Revise os caminhos e o título antes de executar com privilégios elevados. Valide a sintaxe da configuração SSH e guarde o backup antes de recarregar. Se o comportamento de acesso mudar de forma inesperada, restaure o backup e recarregue o daemon a partir de um console já aberto. Não coloque hostnames, endereços, credenciais nem nomes pessoais no banner.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Arquivo do banner pré-login | `-BannerPath` | `BANNER_PATH` | `/etc/ssh/ssh_banner` |
| Configuração do daemon SSH | `-SshConfigPath` | `SSH_CONFIG_PATH` | `/etc/ssh/sshd_config` |
| Script de status pós-login | `-MotdPath` | `MOTD_PATH` | `/etc/profile.d/ssh-status.sh` |
| Título do banner | `-BannerTitle` ou `SSH_BANNER_TITLE` | `SSH_BANNER_TITLE` | `AUTHORIZED SYSTEM` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: um servidor SSH, `sudo`, `systemctl` e permissão para alterar `/etc/ssh` e `/etc/profile.d`.

PowerShell: `./configure-ssh-banner.ps1`

Bash: `SSH_BANNER_TITLE='AUTHORIZED SYSTEM' ./configure-ssh-banner.sh`

Altere os caminhos com `BANNER_PATH`, `SSH_CONFIG_PATH` e `MOTD_PATH` no Bash, ou com os parâmetros correspondentes no PowerShell.

## Telemetria e Observabilidade

Apenas o status local da instalação e do recarregamento é informado. O status gerado no login mostra dados do host aos usuários autorizados; nada é enviado a serviço externo. Valores de host e endereço podem ser sensíveis.

## Verificação

Teste com caminhos temporários, verifique o backup, inspecione a diretiva `Banner` única, confira as permissões do script de status, valide a configuração SSH e confirme o recarregamento com os dois nomes de serviço, `ssh` e `sshd`.
