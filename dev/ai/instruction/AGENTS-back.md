# Maro Working Principles and Code Conventions

## Working Principles

Do not require a separate plan or new tests for trivial changes such as typo fixes. Apply these principles according to task complexity and change risk.

### Think Before Implementing

- State assumptions that affect the outcome. Do not guess uncertain business rules or contracts.
- When different interpretations lead to different outcomes, present the interpretations and tradeoffs and seek clarification.
- Suggest simpler solutions when available, and explain problems with the requested approach when necessary.
- Ask specific questions about ambiguity that blocks progress. Defer implementation that depends on the answer while continuing independent work.

### Keep Implementations Simple

- Write the minimum code needed to meet the requirements. Do not add unrequested features.
- Do not create general-purpose abstractions for code with a single use. Extract shared code when it represents the same business concept and is expected to change for the same reasons; similar syntax alone is not sufficient. Reconsider an abstraction if unrelated callers require growing numbers of flags or special cases.
- Do not implement unrequested extensibility or configurability in advance.
- Do not add exception handling for situations that cannot occur under the contract. Catch exceptions where recovery or translation to the caller's contract is possible, and preserve the original cause. Do not hide failures with empty catch blocks or return null, empty collections, or default values as if an operation succeeded unless the contract explicitly defines that behavior.
- Simplify code when the same behavior can be expressed more clearly. Review for unnecessary complexity before finishing.

### Change Only What Is Needed

- Every change must serve the request. Do not include unrelated refactoring, comment edits, or formatting cleanup.
- Follow the surrounding code's style where this document does not specify a convention.
- Remove imports, variables, and methods made unused by the current change.
- Report unrelated existing unused code or problems; do not remove them without a request.
- Unless explicitly requested otherwise, refactoring must preserve inputs, outputs, exceptions, processing order, and side effects.

### Define Goals and Verify

- Define observable completion criteria first. For multi-step work, briefly describe each step and its verification method.
- For input validation, verify rejection of invalid inputs; for bug fixes, verify the reproduction case; for refactoring, verify behavior before and after the change.
- Follow the testing guidelines below when deciding whether to add tests and how much to cover.
- Continue editing and verifying until the completion criteria are met. After checks pass, do not repeat verification without new evidence that warrants it.
- Confirm that the final changes remain within scope and avoid unnecessary complexity. Report verification results and checks that could not be run.

## Module Responsibilities

| Module | Code Location and Responsibility |
| --- | --- |
| `maro-domain` | `io.vizend.maro.domain`: persisted domain Entities and their Cdo/VO types, standard CRUD Logic, Events, and Store/OptionStore interfaces |
| `maro-feature` | `io.vizend.maro.feature`: application Flow/Seek classes, business Actions, feature-specific SDO/RDO/VO types, and persistence extension contracts |
| `extern` in `maro-feature` | `io.vizend.maro.extern`: shared external integration contracts, clients, and configuration. Feature-specific integrations also exist under the feature's `action/client`. |
| `maro-store-jpa` | `io.vizend.maro.storejpa`: JPOs, JPA Repositories, Store/OptionStore implementations, and CustomStore adapters |
| `maro-facade` | `io.vizend.maro.facade`: HTTP Resources/Facades, Command/Fetch/Query requests, tool invocation adapters, and event entry points |
| `maro-boot` | `io.vizend.maro.MaroBootApplication`, `config`: application entry point and Spring, data source, and serialization configuration |
| `maro-code-gen` | `io.vizend.maro.codegen`: code generation models, transformation, and rendering |
| `maro-source-analysis` | `io.vizend.maro.sourceanalysis`: source parsing and analysis |

## Dependencies and Layer Boundaries

- Domain code must not reference Feature, Facade, or JPO/Repository implementations.
- Feature combines Domain Logic/Store contracts with feature-specific Actions. It must not reference JPA Repositories or JPOs directly.
- Facade delegates application HTTP processing to Flow/Seek. JPA implementations handle Domain-to-JPO conversion and persistence access.
- `maro-store-jpa` currently also depends on `maro-feature` because it implements Feature CustomStore interfaces. Limit that dependency to implementing these extension contracts; do not call business Flows from persistence implementations. Do not introduce a dependency from Feature to JPA implementations.

## Retrieval and the cm/qm Distinction

- `cm` means **Command Model** and `qm` means **Query Model**. Classify by the model being retrieved; a read operation alone does not belong in `qm`.
- Keep retrieval methods free of business state changes and external writes. Make commands and other side effects explicit in method names and call sites.
- By default, use Domain `*Logic` methods named `find*` that accept `QueryParams` for retrieval.
- JPA Repository derived query methods (`findBy...`, `existsBy...`, etc.) may be used when needed. Call them through persistence contracts, without referencing Repositories directly from Feature.
- Avoid other approaches for new feature queries, including QueryDSL, handwritten JPQL/native SQL, `@Query`, and handwritten Criteria API/EntityManager queries. Preserve the existing internals of generated JpaStores that implement `QueryParams`.
- Place cm retrieval requests in `cm/fetch/*FetchRequest` and qm retrieval requests in `qm/query/*QueryRequest`.

## Domain Packages and Generated Code

```text
domain/<domain>/cm/
  entity/          Entities and domain enums
    sdo/           <Entity>Cdo
    vo/            Domain value objects
  logic/           <Entity>Logic
  event/           <Entity>Event
  store/           <Entity>Store
  optionstore/     <Entity>OptionStore
```

- Every persisted domain Entity must have standard CRUD Logic and the required generated artifacts. A Feature Action does not justify omitting Entity Logic.
- Entities follow the existing `StageEntity`/`DomainEntity` hierarchy, and creation inputs follow the `*Cdo` convention based on `CreationDataObject`.
- Follow the contracts of comparable models and their generators for `genId`, JSON conversion helpers, and `sample`.
- Preserve the attribute modification pattern using `NameValueList` and `FieldChangeSet` recording in `modifyAttributes`. Keep mutable fields and type conversions consistent between model declarations and generated output.
- `logic`, `event`, `store`, and `optionstore` are generated-code areas. Do not add custom services, validators, hashing, comparison, locking, or multi-Entity orchestration there.
- Preserve standard Logic contracts for `register*`, `find*`, `modify*`, `remove*`, and Event publication. Do not replace them with CRUD paths that call stores directly.

## Feature Packages and Class Roles

The default location is `feature/<domain>/<feature>/`. Domain-wide `action`, `sdo`, and `shared` packages are also used.

| Package/Name | Responsibility |
| --- | --- |
| `flow/*AppFlow` | Application operation entry points, validation ordering, transaction coordination, and composition of Actions/Logic |
| `seek/*AppSeek` | Retrieval entry points and construction of query results |
| `action/*Action` | Individual business operations and reusable validation, conversion, and related operations |
| `sdo/*Cdo`, `*Sdo`, `*Rdo` | Feature input and result contracts, distinct from Domain creation inputs |
| `vo/*` | Value objects and semantic types used in the Feature layer |
| `store/*CustomStore` | Persistence extension interfaces for operations not readily expressed by standard Domain Stores |
| `shared/*` | Guards, utilities, and contracts actually shared by multiple features |

- Use `private final` dependencies and constructor injection by default. Reuse the existing Lombok `@RequiredArgsConstructor` pattern.
- Apply `@Transactional` to the required transaction scope for writes. Consider `readOnly = true` for retrieval only after confirming that the operation performs no writes.
- Delegate standard CRUD to Domain Logic. Keep business orchestration, such as multi-Entity relationship checks, related deletions, and state transitions, in Feature.
- Reuse existing DTO converters such as `from(Entity)`.
- Place shared external integrations in `extern` and feature-specific integrations in the feature's `action/client`.

## Facade Requests and Responses

Separate request packages by model as follows.

```text
facade/api/role/app/<domain>/<feature>/
  cm/command/      Command requests
  cm/fetch/        *FetchRequest
  cm/rest/         Resource/Facade
  qm/query/        *QueryRequest
  qm/rest/         Resource/Facade
```

- cm includes both writes and retrieval of that model. qm handles retrieval of a separate Query Model.
- For cm retrieval, use requests based on `FetchRequest<T>` and, where needed, `OffsetFetchRequest<List<T>>`. Name qm retrieval request classes `*QueryRequest`.
- Existing cm URLs use `/feature/app/<domain>/<feature>/cm/<operation>/command` or `/fetch`, with contracts that also use POST for retrieval.
- Resources call `validate()`, delegate to Flow/Seek, and return responses through `setResponse` and `getResponse`. Preserve existing authorization contracts such as `@AuthorizedRole`.
- `facade/api/domain/<domain>/cm` also contains existing generated CRUD APIs that call Domain Logic directly. Distinguish them from application APIs and preserve their generated delegation contracts.

## JPA and Persistence Extensions

```text
storejpa/<domain>/cm/
  store/<Entity>JpaStore
    jpo/<Entity>Jpo
    repository/<Entity>JpaRepository
  optionstore/<Entity>JpaOptionStore
storejpa/<domain>/customstore/<Feature>JpaCustomStore
```

- Preserve existing JPO mapping conventions such as `@Entity`, `@Table`, and `StageEntityJpo`, along with Domain-to-JPO conversion methods.
- Distinguish structured Domain values from JSON string columns in JPOs. Keep VO/list serialization and deserialization consistent with the same contract.
- Do not add custom locking, coordination, or business logic to generated Repositories, JpaStores, or JpaOptionStores.
- When persistence extensions are needed, use Feature `*CustomStore` interfaces and implementations in `storejpa/<domain>/customstore`. Do not change generated Store signatures to accommodate extensions.
- CustomStores define the required persistence access contracts. Feature Actions/Flows coordinate business validation and the order of operations.
- Prefer `QueryParams` or necessary derived query methods for retrieval extensions. Do not add a general-purpose persistence layer for other query technologies.

## Java Code and Models

- In handwritten code in `maro-feature`, methods and constructors must be at most 30 lines from the start of the declaration through the closing brace, excluding comment-only and blank lines. A line containing both code and a comment counts as one code line.
- In handwritten code in `maro-feature`, class files must be at most 400 lines, including package declarations, imports, comments, and blank lines. Nested types count toward the same file limit.
- Each class should have one cohesive responsibility. When groups of methods change for different reasons, consider separating them by responsibility. Do not split or merge classes or methods solely because of the number of methods.
- Keep each method focused on one purpose at a consistent level of abstraction. Orchestration methods should express the business sequence and delegate details such as JSON parsing or request construction to meaningfully named operations.
- The method-length and class-file-length limits above do not apply to other modules or generated code. When a limit is exceeded, split meaningful processing units or responsibilities; do not move code to arbitrary utility or nested classes merely to satisfy a size limit.
- Do not use `var` for local variables. Specify explicit types in loops and try-with-resources as well.
- Import referenced types and use their simple names in handwritten Java code. Do not write fully qualified type names inline in declarations, signatures, generic arguments, casts, annotations, or expressions. If simple names collide and imports cannot disambiguate them, qualify only the conflicting references.
- Separate logical phases inside a method with one blank line, such as input validation, data retrieval, business decisions, state changes, and result construction. Keep closely related statements together; do not add blank lines mechanically around every statement or control-flow keyword.
- Do not combine multiple statements on one line or remove formatting needed for readability to meet size limits. Split methods into meaningful processing units and classes by responsibility.
- Always enclose control-flow bodies (`if`, `else`, `for`, enhanced `for`, `while`, and `do-while`) in braces (`{}`), even when the body contains only one statement. This includes guard clauses and early returns.
- Choose names that express business intent and observable behavior. Avoid vague names such as process or handleData when a specific operation can be named. Name complex business conditions and prefer positive boolean predicates to double negatives.
- Prefer guard clauses and early returns for invalid inputs and exceptional conditions to keep the normal path clear. Reduce unnecessary nesting; do not introduce guards for states excluded by the contract.
- Avoid boolean mode flags and lists of unrelated method parameters. Use separately named operations or an explicit option type when the distinction has business meaning. Group parameters only when they form a cohesive concept.
- Minimize reassignment and shared mutable state. Prefer immutable local values where practical, and keep calculations and transformations separate from persistence and network side effects.
- Apply these rules to newly written or modified handwritten code. For generated code, preserve the generated structure.
- Entities, JPOs, and generator-targeted models follow existing inheritance, constructor, mutation, and serialization contracts.
- Immutable DTOs and internal result types may use `record` after compatibility is checked.
- Put public/shared models in separate files. Helper types whose use is limited to one class may be nested.
- Write code comments in Korean. Keep identifiers and established technical terms where needed.
- Add a brief explanation of each domain field using a `//` comment to the right of its declaration. Do not use Javadoc above the field.
- In `maro-feature`, add a `//` comment above each method and constructor briefly explaining its role or processing flow.
- Inside methods in `maro-feature`, add short `//` comments where branches, processing order, or design choices need explanation. Do not restate the code.
- Use existing typed VOs for structures with fixed meaning. For dynamic contracts such as JSON transport/schema, follow the feature's existing types.
- Reuse existing `JsonUtil`, injected `ObjectMapper`, and Feature `JsonUtils` according to their purpose. If a standalone mapper is needed, check the existing construction path in that layer.
- Current Jackson types are primarily `tools.jackson.*`, used alongside the existing platform `JsonUtil`.

## Testing Guidelines

- Do not add tests with little defect-detection value, such as getter/setter tests, trivial constructor tests, assertions that only check value presence, or tests that merely assert a mock's return value.
- Do not write tests that mirror the implementation or only match mock invocation counts. When ordering or counts are themselves part of a deduplication or performance contract, verify that meaning.
- Prioritize behavior that can break: reproduction of actual bugs, boundary values and input combinations, authorization/ownership scope, state transitions, partial failures, and rollback.
- Test JSON/JPO conversions and generated output with values and paths where data loss, type mismatches, or compatibility problems can actually occur. Exhaustive coverage of generated boilerplate is not a goal in itself.
- Do not add similar tests when existing tests sufficiently cover the change risk. Use JUnit Jupiter, Mockito, and existing fixtures according to the risk being verified.
