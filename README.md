# Projeto para GitHub Actions

Projeto criado com intuito de utilizar GitHub Actions para Integração Contínua (Continuous Integration) para organizações Salesforce.

# Configurando Credencial no GitHub

Com o ambiente conectado no VS Code, digitar o seguinte comando no terminal: ```sfdx force:org:display --verbose --json```<br>
Após a execução, copiar a chave gerada na tag ```sfdxAuthUrl``` e ir até ```Settings > Secrets and variables > Actions > New repository secret``` no repositório  <b>GitHub</b> desejado.<br>
Preencher <b>Name</b> com o nome da variável a ser utilizada nos arquivos <b>.yml</b> e colar o valor copiado em <b>Secret</b>.

# Geração de Script de Deploy

Para realizar a geração rápida de script <b>.YML</b>, é possível utilizar o seguinte link: <b>http://ci.salto.io/app</b>

