# C3 - Módulo de relatórios

![](./Report%20Module.svg)

## Casos de uso

### Solicitar a Criação de Relatório:

```mermaid
sequenceDiagram
    participant user as Usuário
    participant report_api as API de Relatório
    participant report_service as Serviço de Aplicação de Relatório
    participant request_report_creation_use_case as Caso de Uso - Solicitar a Criação de Relatório
    participant report_gateway as AI Gateway
    participant ai as Inteligência Artificial

    user->>report_api: Faz requisição (apenas Investidor)
    report_api->>report_service: Usa
    report_service->>request_report_creation_use_case: Executa
    request_report_creation_use_case->>report_gateway: Usa
    report_gateway->>ai: Faz solicitação (JSON/HTTPS)
    ai-->>report_gateway: Resposta com o relatório (Plain Text - Markdown)
    report_gateway-->>request_report_creation_use_case: Resposta com o relatório
    request_report_creation_use_case-->>report_service: Resposta com o relatório
    report_service-->>report_api: Resposta com o relatório
    report_api-->>user: Resposta com o relatório
```

### Notificar sobre o Relatório Diário:

```mermaid
sequenceDiagram
    participant report_api as API de Relatório
    participant report_service as Serviço de Aplicação de Relatório
    participant notify_daily_report as Caso de Uso - Notificar sobre o Relatório Diário
    participant mail as Sistema de E-mail

    report_api->>report_service: Usa
    report_service->>notify_daily_report: Executa
    notify_daily_report->>mail: Envia e-mail de notificação
    mail-->>notify_daily_report: Confirmação de envio
    notify_daily_report-->>report_service: Resposta de sucesso
    report_service-->>report_api: Resposta de sucesso
```

### Listagem dos Relatórios:

```mermaid
sequenceDiagram
    participant user as Usuário
    participant report_api as API de Relatório
    participant report_service as Serviço de Aplicação de Relatório
    participant list_reports_use_case as Caso de Uso - Listagem dos Relatórios
    participant report_repository as Repositório de Relatório
    participant db as Banco de Dados

    user->>report_api: Faz requisição (apenas Investidor)
    report_api->>report_service: Usa
    report_service->>list_reports_use_case: Executa
    list_reports_use_case->>report_repository: Consulta relatórios
    report_repository->>db: Usa
    db-->>report_repository: Resposta com dados dos relatórios
    report_repository-->>list_reports_use_case: Resposta com dados dos relatórios
    list_reports_use_case-->>report_service: Resposta com dados dos relatórios
    report_service-->>report_api: Resposta com dados dos relatórios
    report_api-->>user: Resposta com dados dos relatórios
```

### Obtém Funcionalidades Desbloqueadas:

```mermaid
sequenceDiagram
    participant user as Usuário
    participant report_api as API de Relatório
    participant report_service as Serviço de Aplicação de Relatório
    participant get_unlocked_features_use_case as Caso de Uso - Obtém Funcionalidades Desbloqueadas
    participant user_repository as Repositório de Usuário
    participant db as Banco de Dados 

    user->>report_api: Faz requisição (apenas Investidor)
    report_api->>report_service: Usa
    report_service->>get_unlocked_features_use_case: Executa
    get_unlocked_features_use_case->>user_repository: Consulta dados do usuário
    user_repository->>db: Usa
    db-->>user_repository: Resposta com as funcionalidades desbloqueadas
    user_repository-->>get_unlocked_features_use_case: Resposta com funcionalidades desbloqueadas
    get_unlocked_features_use_case-->>report_service: Resposta com funcionalidades desbloqueadas
    report_service-->>report_api: Resposta com funcionalidades desbloqueadas
    report_api-->>user: Resposta com funcionalidades desbloqueadas
```
