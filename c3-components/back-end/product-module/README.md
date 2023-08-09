# C3 - Módulo de produto

![](./Product%20Module.svg)

## **Caso de usos**

### Listagem dos Produtos:

```mermaid
sequenceDiagram
    participant user as Usuário
    participant product_api as API de Produto
    participant product_service as Serviço de Aplicação de Produto
    participant list_products_use_case as Caso de Uso - Listagem dos Produtos
    participant product_repository as Repositório de Produto
    participant db as Banco de Dados (MongoDB)

    user->>product_api: Faz requisição
    product_api->>product_service: Usa
    product_service->>list_products_use_case: Executa
    list_products_use_case->>product_repository: Consulta produtos
    product_repository->>db: Usa
    db-->>product_repository: Resposta com dados dos produtos
    product_repository-->>list_products_use_case: Resposta com dados dos produtos
    list_products_use_case-->>product_service: Resposta com dados dos produtos
    product_service-->>product_api: Resposta com dados dos produtos
    product_api-->>user: Resposta com dados dos produtos
```

### Comprar Produto:

```mermaid
sequenceDiagram
    participant user as Usuário
    participant product_api as API de Produto
    participant product_service as Serviço de Aplicação de Produto
    participant buy_product_use_case as Caso de Uso - Comprar Produto
    participant user_repository as Repositório de Usuário

    user->>product_api: Faz requisição
    product_api->>product_service: Usa
    product_service->>buy_product_use_case: Executa
    buy_product_use_case->>user_repository: Consultado saldo
    user_repository-->>buy_product_use_case: Resposta com saldo
    buy_product_use_case->>user_repository: Atualiza saldo após compra
    buy_product_use_case-->>product_service: Resposta de sucesso
    product_service-->>product_api: Resposta de sucesso
    product_api-->>user: Resposta de sucesso
```

### Editar Produto (Apenas Administradores):

```mermaid
sequenceDiagram
    participant admin as Administrador
    participant product_api as API de Produto
    participant product_service as Serviço de Aplicação de Produto
    participant edit_product_use_case as Caso de Uso - Editar Produto
    participant product_repository as Repositório de Produto
    participant db as Banco de Dados (MongoDB)

    admin->>product_api: Faz requisição
    product_api->>product_service: Usa
    product_service->>edit_product_use_case: Executa
    edit_product_use_case->>product_repository: Salva alterações
    product_repository->>db: Usa
    db-->>product_repository: Confirmação de salvamento
    product_repository-->>edit_product_use_case: Resposta de sucesso
    edit_product_use_case-->>product_service: Resposta de sucesso
    product_service-->>product_api: Resposta de sucesso
    product_api-->>admin: Resposta de sucesso
```

Na edição de um produto, o front-end é responsável por realizar a solicitação `PUT` ou `PATCH`, dependendo das informações que foram alteradas. Em outras palavras, se o usuário tiver modificado todas as informações no formulário de edição do produto, o front-end enviará uma solicitação `PUT`. Caso contrário, especificará apenas os campos que foram alterados utilizando o método `PATCH`.

Essa abordagem foi adotada visando evitar a gravação de dados desnecessários no banco de dados e também para prevenir possíveis erros, como a atualização de informações na base de dados sem que elas tenham sido efetivamente alteradas pelo usuário.

### Adicionar Produto (Apenas Administradores):

```mermaid
sequenceDiagram
    participant admin as Administrador
    participant product_api as API de Produto
    participant product_service as Serviço de Aplicação de Produto
    participant add_product_use_case as Caso de Uso - Adicionar Produto
    participant product_repository as Repositório de Produto
    participant db as Banco de Dados (MongoDB)

    admin->>product_api: Faz requisição
    product_api->>product_service: Usa
    product_service->>add_product_use_case: Executa
    add_product_use_case->>product_repository: Salva novo produto
    product_repository->>db: Usa
    db-->>product_repository: Confirmação de salvamento
    product_repository-->>add_product_use_case: Resposta de sucesso
    add_product_use_case-->>product_service: Resposta de sucesso
    product_service-->>product_api: Resposta de sucesso
    product_api-->>admin: Resposta de sucesso
```