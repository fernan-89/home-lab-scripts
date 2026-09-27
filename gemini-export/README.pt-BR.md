# Exportação de Chat Compartilhado

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria apoia a exportação manual e controlada de uma página de chat compartilhado do Gemini previamente aprovada. Ela abre o link informado e cria um arquivo Markdown local de espaço reservado; não faz scraping de páginas autenticadas nem automatiza o uso de credenciais.

## Obrigações Contratuais

- Exigir uma URL HTTPS de chat compartilhado e validar o host aprovado do Gemini.
- Abrir a URL com o navegador padrão do sistema, quando disponível.
- Criar ou sobrescrever um arquivo Markdown local com título, URL de origem, status de exportação manual e instrução para colar o conteúdo.
- Nunca coletar cookies, senhas, tokens, dados de páginas autenticadas nem conteúdo não relacionado do navegador.

### Resultados Gerados

O `shared-chat.md` gerado é um espaço reservado para o conteúdo que o operador revisa e cola manualmente. Não é uma transcrição automática e não garante que a página tenha sido aberta ou exportada com sucesso.

### Segurança e Recuperação

Confirme que a URL pertence a um compartilhamento aprovado antes de abri-la. Remova credenciais, dados pessoais, infraestrutura privada e conteúdo confidencial da conversa antes de salvar ou compartilhar o arquivo Markdown. A saída pode sobrescrever uma exportação existente, então faça backup quando necessário.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| URL do chat compartilhado | `-ShareUrl` | `$1` | obrigatório |
| Arquivo de saída | `-OutputFile` ou `CHAT_OUTPUT_FILE` | `CHAT_OUTPUT_FILE` | `shared-chat.md` |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos: um navegador e uma URL de compartilhamento do Gemini aprovada. Estes scripts nunca armazenam credenciais.

PowerShell: `./export-shared-chat.ps1 -ShareUrl https://gemini.google.com/share/EXAMPLE`

Bash: `./export-shared-chat.sh https://gemini.google.com/share/EXAMPLE`

## Telemetria e Observabilidade

Apenas o status local de abertura no navegador e o caminho da saída são informados. Não há telemetria externa, scraping nem envio de dados. A URL compartilhada e o conteúdo colado do chat podem ser sensíveis.

## Verificação

Teste uma URL HTTPS aprovada, esquemas inválidos, hosts não suportados, ausência de navegador para abrir, caminhos de saída com espaços e a revisão manual do espaço reservado gerado.
