# Projeto para GitHub Actions

Projeto criado com intuito de utilizar GitHub Actions para Integração Contínua (Continuous Integration) para organizações Salesforce.

# Configurando Credencial no GitHub

Com o ambiente conectado no VS Code, digitar o seguinte comando no terminal: <b>sfdx force:org:display --verbose --json</b><br>
Após a execução, copiar a chave gerada na tag <b>sfdxAuthUrl</b> e ir até <b>Settings > Secrets and variables > Actions > New repository secret</b> no repositório  <b>GitHub</b> desejado.<br>
Preencher <b>Name</b> com o nome da variável a ser utilizada nos arquivos <b>.yml</b> e colar o valor copiado em <b>Secret</b>.

# Geração de Script de Deploy

Para realizar a geração rápida de Script <b>.YML</b>, é possível utilizar o seguinte link: <b>http://ci.salto.io/app</b>

