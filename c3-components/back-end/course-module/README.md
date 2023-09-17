# C3 - Módulo de curso

![](./Course%20Module.svg)

## Entidades

### Course

```mermaid
classDiagram
    Module --> Identifier
    Module --> Chapter

    class Identifier {
        - String value
        + create() Identifier
    }

    class Module {
        - Identifier id
        - String title
        - String description
        - LinkedList~Chapter~ chapters

        + Module(Identifier id, String title, String description, LinkedList<Chapter> chapters) Module
        + exists(String chapterTitle) boolean
        + getPosition(String chapterTitle) int
        + add(int position, Chapter newChapter) void
        + edit(String title, Chapter updatedChapter) void
        + remove(String title) void
        + getNumberOfChapters() int
    }

    class Chapter {
        - Identifier id
        - String title
        - String description
        - File contentInPDF

        + Chapter(Identifier id, String title, String description, File contentInPDF) Chapter
    }
```

A entidade `Module` é responsável por gerenciar o conteúdo e cronologia dos capítulos, por isso foi adotado a estrutura `LinkedList` do Java para garantir a ordem dos capítulos de cada módulo.

### User

```mermaid
classDiagram
    CourseUser --> Identifier
    CourseUser --> Progress
    ChapterStatus --> Status

    class Identifier {
        - String value
        + create() Identifier
    }

    class Progress {
        - int completedChapters
        - int totalChapters
    }

    class CourseUser {
        - Identifier id
        - List~ChapterStatus~ completedChapters
        - ChapterStatus chapterInProgress

        + CourseUser(Identifier id, List<ChapterStatus> completedChapters, ChapterStatus chapterInProgress) CourseUser
        + finishReading(Identifier nextChapter) void
        + getUserProgress() Progress
    }

    class Status {
        <<Enumerante>>
        BLOCKED
        TO_CONTINUE
        COMPLETED
    }

    class ChapterStatus {
        - Identifier chapterReference
        - Status status

        + ChapterStatus(Identifier chapterReference, Status status) ChapterStatus
        + isToContinue() boolean
        + isCompleted() boolean
        + markAsToContinue() void
        + markAsCompleted() void
    }
```

A entidade `CourseUser` tem a função de apenas armazenar as informações do usuários relacionadas os curso, por exemplo, o capítulo em andamento, status de leitura de cada capítulo e progresso. Os capítulos concluídos são armazenados em uma lista denotado de `completedChapters` e nesse caso a ordem dos capítulos e os módulos são irrelevantes uma vez que são responsabilidade da entidade `Module`, pois isso foi adotado a estrutura `List` e não `LinkedList` no atributo `completedChapters`. Já o capítulo em andamento é armazenado em um atributo a parte já que é necessários aplicar regras específicas nele, como por exemplo ao concluir a leitura, com isso caso fosse inserido juntamente com os capítulos concluídos seria necessários utilizar uma estrutura de dados mais complexa como um `Map` ou fazer um `for` em tais situações. Por fim, os capítulos com status `BLOCKED` não são relevantes para serem armazenados, pois por ser o status padrão não teria sentido em armazená-los no banco de dados uma vez que podem ser subtendidos nos casos de uso.

O racional por trás dessa divisão entre `Course` e `User` foi necessário uma vez que não seria performático replicar todo o conteúdo do curso para armazenar as informações individuais dos usuários, como status de leitura.

## Caso de usos

### Obter progresso do usuário

```mermaid
sequenceDiagram
    participant mobile as Front-end mobile
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant get_user_progress_use_case as Caso de Uso - Obter Progresso de Usuário
    participant user_repository as Repositório de Usuário

    mobile->>course_api: Faz requisição GET
    course_api->>course_service: Usa
    course_service->>get_user_progress_use_case: Executa caso de uso
    alt usuário existe
      get_user_progress_use_case->>user_repository: Consulta o progresso do usuário
      user_repository->>get_user_progress_use_case: Mapeia o resultado para <br/> a entidade Progresso
      get_user_progress_use_case->>course_service: Resposta com progresso
      course_service->>course_api: Resposta com progresso
      course_api->>mobile: Resposta com progresso em JSON
    else usuário não existe:
      get_user_progress_use_case->>course_service: Resposta: "usuário não existe"
      course_service->>course_api: Resposta: "usuário não existe"
      course_api->>mobile: Resposta 400
    end
```

### Obter conteúdo do curso:

```mermaid
sequenceDiagram
    participant user as Usuário
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant get_course_content_use_case as Caso de Uso - Obter Conteúdo do Curso
    participant course_repository as Repositório de Curso

    user->>course_api: Faz requisição GET
    course_api->>course_service: Usa
    course_service->>get_course_content_use_case: Executa caso de uso
    get_course_content_use_case->>course_repository: Consulta dados dos módulos e capítulos
    course_repository->>get_course_content_use_case: Resposta com dados do curso
    get_course_content_use_case->>course_service: Resposta com dados do curso
    course_service->>course_api: Resposta com dados do curso
    course_api->>user: Resposta com dados do curso em JSON
```

### Obter capítulo em andamento:

```mermaid
sequenceDiagram
    participant frontend as Front-end
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant get_chapter_to_continue_use_case as Caso de Uso - Obter Capítulo em Andamento
    participant user_repository as Repositório de Usuário

    frontend->>course_api: Faz requisição GET
    course_api->>course_service: Usa
    course_service->>get_chapter_to_continue_use_case: Executa caso de uso
    get_chapter_to_continue_use_case->>user_repository: Obtém as informações do <br/> capítulo em andamento
    user_repository->>get_chapter_to_continue_use_case: Resposta com capítulo em andamento
    get_chapter_to_continue_use_case->>course_service: Resposta com capítulo em andamento
    course_service->>course_api: Resposta com capítulo em andamento
    course_api->>frontend: Resposta com capítulo em andamento em JSON
```

### Concluir leitura:

```mermaid
sequenceDiagram
    participant user as Usuário
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant finish_reading_use_case as Caso de Uso - Concluir Leitura
    participant user_repository as Repositório de Usuário

    user->>course_api: Faz requisição PATCH
    course_api->>course_service: Usa
    course_service->>finish_reading_use_case: Executa
    finish_reading_use_case->>user_repository: Atualiza informações
    user_repository->>finish_reading_use_case: Resposta com sucesso
    finish_reading_use_case->>course_service: Resposta com sucesso
    course_service->>course_api: Resposta com sucesso
    course_api->>user: Resposta com sucesso
```

### Adicionar módulo (Apenas Administradores):

```mermaid
sequenceDiagram
    participant admin as Administrador
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant add_course_module_use_case as Caso de Uso - Adicionar Módulo
    participant course_repository as Repositório de Curso

    admin->>course_api: Faz requisição POST
    course_api->>course_service: Usa
    course_service->>add_course_module_use_case: Executa caso de uso
    add_course_module_use_case->>course_repository: Salva novo módulo
    course_repository->>add_course_module_use_case: Resposta de sucesso
    add_course_module_use_case->>course_service: Resposta de sucesso
    course_service->>course_api: Resposta de sucesso
    course_api->>admin: Resposta de sucesso
```

### Adicionar Capítulo (Apenas Administradores):

```mermaid
sequenceDiagram
    participant admin as Administrador
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant add_chapter_use_case as Caso de Uso - Adicionar Capítulo
    participant course_repository as Repositório de Curso

    admin->>course_api: Faz requisição PATCH
    course_api->>course_service: Usa
    course_service->>add_chapter_use_case: Executa caso de uso
    add_chapter_use_case->>course_repository: Adiciona capítulo no <br/> respectivo módulo
    course_repository->>add_chapter_use_case: Resposta de sucesso
    add_chapter_use_case->>course_service: Resposta de sucesso
    course_service->>course_api: Resposta de sucesso
    course_api->>admin: Resposta de sucesso
```

### Editar Módulo (Apenas Administradores):

```mermaid
sequenceDiagram
    participant admin as Administrador
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant edit_module_use_case as Caso de Uso - Editar Módulo
    participant course_repository as Repositório de Curso

    admin->>course_api: Faz requisição PATCH OU PUT
    course_api->>course_service: Usa
    course_service->>edit_module_use_case: Executa caso de uso
    edit_module_use_case->>course_repository: Salva alterações
    course_repository->>edit_module_use_case: Resposta de sucesso
    edit_module_use_case->>course_service: Resposta de sucesso
    course_service->>course_api: Resposta de sucesso
    course_api->>admin: Resposta de sucesso
```

Na edição de um módulo, o front-end é responsável por realizar a solicitação `PUT` ou `PATCH`, dependendo das informações que foram alteradas. Em outras palavras, se o usuário tiver modificado todas as informações no formulário de edição do módulo, o front-end enviará uma solicitação `PUT`. Caso contrário, especificará apenas os campos que foram alterados utilizando o método `PATCH`.

Essa abordagem foi adotada visando evitar a gravação de dados desnecessários no banco de dados e também para prevenir possíveis erros, como a atualização de informações na base de dados sem que elas tenham sido efetivamente alteradas pelo usuário.

### Editar Capítulo (Apenas Administradores):

```mermaid
sequenceDiagram
    participant admin as Administrador
    participant course_api as API de Curso
    participant course_service as Serviço de Aplicação de Curso
    participant edit_chapter_use_case as Caso de Uso - Editar Capítulo
    participant course_repository as Repositório de Curso

    admin->>course_api: Faz requisição PUT ou PATCH
    course_api->>course_service: Usa
    course_service->>edit_chapter_use_case: Executa caso de uso
    edit_chapter_use_case->>course_repository: Salva alterações
    course_repository->>edit_chapter_use_case: Resposta de sucesso
    edit_chapter_use_case->>course_service: Resposta de sucesso
    course_service->>course_api: Resposta de sucesso
    course_api->>admin: Resposta de sucesso
```

Na edição de um capítulo, o front-end é responsável por realizar a solicitação `PUT` ou `PATCH`, dependendo das informações que foram alteradas. Em outras palavras, se o usuário tiver modificado todas as informações no formulário de edição do capítulo, o front-end enviará uma solicitação `PUT`. Caso contrário, especificará apenas os campos que foram alterados utilizando o método `PATCH`.

Essa abordagem foi adotada visando evitar a gravação de dados desnecessários no banco de dados e também para prevenir possíveis erros, como a atualização de informações na base de dados sem que elas tenham sido efetivamente alteradas pelo usuário.
