# Documentação de Terraform

🇺🇸 [English](README.md) · 🇧🇷 Português

## Papel Arquitetural

Esta categoria cria um retrato revisável em Markdown de uma árvore de código Terraform. É um utilitário de documentação e inspeção, não um wrapper de execução do Terraform: ele nunca executa `terraform plan`, `terraform apply`, `terraform init` nem qualquer operação de provider.

Os scripts em PowerShell e Bash encontram os arquivos Terraform recursivamente, ordenam-nos pelo caminho e reúnem o código num único documento Markdown com blocos de código HCL. O documento gerado é útil para revisão offline, passagem de conhecimento, análise de mudanças e indexação do repositório.

## Obrigações Contratuais

### Entradas

As duas implementações exigem:

- Um diretório raiz de Terraform com permissão de leitura.
- Um caminho de saída Markdown com permissão de escrita.

### Descoberta e Ordenação

- Todos os arquivos terminados em `.tf` são encontrados recursivamente.
- Os arquivos são ordenados pelo caminho completo antes de gerar o documento.
- Os scripts falham se a raiz não existir ou se nenhum arquivo Terraform for encontrado.
- Uma saída existente é sobrescrita exatamente no caminho informado pelo operador.
- Os diretórios pai da saída não são criados automaticamente; crie-os antes de executar.

### Resultados Gerados

Para cada arquivo Terraform, a saída contém uma seção neste formato:

````markdown
## File: /path/to/example.tf

```hcl
resource "example" "sample" {
	# Source is copied exactly for review.
}
```

---
````

O documento final contém:

- Um título por arquivo `.tf` encontrado.
- O código dentro de um bloco `hcl`.
- Um separador horizontal entre os arquivos.
- Nenhum state, saída de provider, plano ou avaliação de recursos do Terraform.

### Segurança e Recuperação

- Falhar imediatamente se o diretório raiz for inválido.
- Falhar se a árvore não tiver arquivos `.tf`.
- Preservar os arquivos de origem; apenas o arquivo de saída configurado é gravado.
- Usar um local de saída temporário ou versionado ao revisar mudanças.
- Revisar o documento gerado antes de publicar, porque o código Terraform pode conter credenciais, endpoints privados, IDs de conta, tokens ou variáveis sensíveis.
- Não colocar credenciais em exemplos de comando nem em arquivos versionados.
- Recuperação: a árvore de origem nunca é alterada, então uma saída errada ou desatualizada se corrige apagando-a e executando o script de novo.

## Configuração

| Configuração | PowerShell | Bash | Padrão |
| --- | --- | --- | --- |
| Diretório raiz do Terraform | `-RootPath` | `$1` | obrigatório |
| Arquivo Markdown de saída | `-OutputPath` | `$2` | obrigatório |

Parâmetros do PowerShell têm precedência; onde o padrão do parâmetro lê uma variável de ambiente, ela vale quando o parâmetro não é informado. `$1`, `$2` e `$3` são argumentos posicionais do Bash; quando a variável de ambiente e o argumento são informados, a variável vence.

## Uso

Pré-requisitos:

- PowerShell para a implementação `.ps1` ou Bash para a implementação `.sh`.
- Permissão de leitura na árvore Terraform.
- Permissão de escrita no diretório pai do arquivo de saída.
- O próprio Terraform não é necessário para gerar o documento.

PowerShell:

```powershell
./document-terraform.ps1 -RootPath C:\path\to\terraform -OutputPath C:\path\to\terraform.md
```

Bash:

```bash
./document-terraform.sh /path/to/terraform /path/to/terraform.md
```

## Telemetria e Observabilidade

Os scripts emitem uma única mensagem local de status com a quantidade de arquivos Terraform documentados e o caminho da saída. Não coletam telemetria externa, não fazem chamadas de rede e não enviam o código. O caminho da saída e os nomes dos arquivos ainda podem revelar a estrutura da infraestrutura, então trate o documento gerado como sensível.

## Verificação

Validação de sintaxe do PowerShell:

```powershell
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
		(Resolve-Path .\document-terraform.ps1),
		[ref]$null,
		[ref]$errors
) | Out-Null
if ($errors.Count -gt 0) { $errors | ForEach-Object Message; exit 1 }
```

Validação de sintaxe do Bash:

```bash
bash -n ./document-terraform.sh
```

Após a execução, confirme que cada arquivo `.tf` esperado aparece uma única vez, que os blocos HCL estão balanceados e que nenhum valor sensível está sendo compartilhado sem querer.
