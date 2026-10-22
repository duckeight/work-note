# Maro Frontend Working Principles and Code Conventions

## Working Principles

Do not require a separate plan or new tests for trivial changes such as typo fixes. Apply these principles according to task complexity and change risk.

### Think Before Implementing

- State assumptions that affect the outcome. Do not guess uncertain business rules or contracts.
- When different interpretations lead to different outcomes, present the interpretations and tradeoffs and seek clarification.
- Suggest simpler solutions when available, and explain problems with the requested approach when necessary.
- Ask specific questions about ambiguity that blocks progress. Defer implementation that depends on the answer while continuing independent work.

### Keep Implementations Simple

- Write the minimum code needed to meet the requirements. Do not add unrequested features.
- Do not create general-purpose abstractions for code with a single use.
- Do not implement unrequested extensibility or configurability in advance.
- Do not add exception handling for situations that cannot occur under the contract.
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

## Workspace and Package Responsibilities

Use the workspace declared in `pnpm-workspace.yaml` and package scripts in `package.json`. Workspace package dependencies use `workspace:*`.

| Location                                  | Responsibility                                                                                   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `episodes/episode-maro/src`               | Application entry point, providers, Episode/Act/Scene route composition, and application styling |
| `dramas/maro-view/src/components`         | Domain UI, feature orchestration, presentation hooks, and local UI state                         |
| `dramas/maro-state/src/app`               | Generated query/mutation options, query keys, and API hooks                                      |
| `dramas/maro-stub/src/apis`, `src/models` | Generated API clients, request/response contracts, and domain model types                        |
| `libraries/keas-model`                    | Shared KEAS model contracts without UI or application dependencies                               |
| `libraries/keas-scene-weaving`            | Reusable scene composition and routing runtime built on KEAS models                              |
| `shared-public/assets`                    | Shared public assets served by the episode application                                           |

- Keep dependencies directed from episode to view, from view to state/stub, and from state to stub. The episode may also consume state/stub when composing application concerns.
- Do not import episode code into dramas or libraries, or view code into state/stub. Shared libraries must not depend on a specific episode or business feature.
- Import another package through its package name and declared exports, such as `@vizendjs/maro-state`. Do not import another package's `src` or `dist` files directly.
- Expose reusable package APIs through `src/index.ts` and the relevant barrel exports. Add subpath exports only when they are intentional public APIs.
- Use `~/*` for paths within the current package and relative imports for nearby feature files. The alias is package-local, not a shortcut into another package.
- Keep runtime entry points and type declarations consistent with `package.json` exports and the existing Vite build configuration.

## Generated Stub and State Boundaries

- `dramas/maro-stub` and `dramas/maro-state` are generated-code areas. Existing handwritten-looking code there does not authorize adding custom code or changing their responsibilities.
- Preserve generated API names, request/response shapes, model types, query keys, option factories, hook signatures, and export structure. Keep contract changes aligned with the backend and generation source.
- Do not add presentation logic, custom workflow hooks, UI validation, feature-specific response transformations, or local selection/draft state to these packages.
- Put custom composition around generated hooks in the owning feature under `maro-view`. Reuse generated hooks and options before considering a separate query or mutation.
- Do not work around a missing generated API or type by inventing endpoint strings, copying server model types into view code, or patching generated clients for a screen. Identify and resolve the backend/generation contract gap.
- Do not edit `dist`, generated declarations, `node_modules`, `.turbo`, or `storybook-static` as source code.

## View Structure and Component Roles

Group new feature code under `dramas/maro-view/src/components/<domain>/<feature>/`. Existing domain-level components also exist; do not relocate unrelated files just to normalize the tree.

| File or Group                                     | Responsibility                                                                           |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `<Feature>List.tsx`, `<Feature>Detail.tsx`        | Feature UI entry points and composition of data hooks and child views                    |
| `hooks/use*.ts`                                   | Feature-specific state, query composition, draft handling, and interaction orchestration |
| `grid/*Grid.tsx`, `*ColDefs.tsx`                  | Typed row presentation, column definitions, pagination, and selection callbacks          |
| `dialog/*Dialog.tsx`, form components             | Dialog/form inputs, validation, and submit/cancel behavior                               |
| `types.ts`, `constants.ts`, focused utility files | Feature-local types, constants, and pure transformations                                 |
| `components/shared`                               | UI, hooks, data helpers, and state actually shared across features                       |

- Keep the target feature's established `grid`, `dialog`, `view`, or `views` grouping when extending it. Do not introduce a second parallel layout for the same feature.
- Use PascalCase component names and `.tsx` files, `use`-prefixed hooks in `.ts`, and named exports for reusable view APIs.
- Declare typed props. Name callback props `on...` and local event handlers `handle...`; pass domain values or identifiers rather than exposing app navigation details.
- Components may invoke generated data hooks. Extract substantial workflow, selection, and draft coordination into feature hooks; keep grids and presentational children focused on typed data and callbacks.
- Split large components by UI responsibility and hooks by state ownership. Do not create a generic component, context, or shared hook solely to shorten one file.
- Keep feature-specific helpers beside their consumers. Move them to shared code only when multiple consumers actually need the same contract.

## Routing and Application Composition

- Organize routing as Episode → Act → Scene. The Episode assembles Act routes, each Act assembles Scene routes, and each Scene owns its page/child routes.
- Keep this routing hierarchy separate from the domain/feature grouping of view components. Do not derive route boundaries from domain folder names.
- The current Episode router entry is `episodes/episode-maro/src/pages/router.tsx`. Structure route definitions according to their Episode, Act, and Scene responsibilities.
- Scene route pages read route parameters, compose exported view components, and translate callbacks into navigation. Keep feature behavior in `maro-view`.
- Preserve `RouteObject` structure, nested `Outlet` composition, route parameters, and route metadata such as `handle.title`, `handle.roles`, and `SceneType` values.
- Use the actual `SceneType` value where required, not a string that spells its TypeScript expression.
- Keep application providers and bootstrap configuration in the episode. Reuse the existing QueryClient, theme, snackbar, and dialog infrastructure rather than creating private copies per feature.
- Keep reusable view callbacks independent of concrete episode URL paths. Preserve the configured application base path when changing routing or asset resolution.

## Data Access and UI State

- Use generated APIs/types from `@vizendjs/maro-stub` and query/mutation hooks or options from `@vizendjs/maro-state`.
- Follow each hook's actual contract: some hooks retain their initial parameters and expose `fetchList` or `fetchItem` to update them. Passing new initial props is not necessarily a refetch.
- Reuse generated query key factories for cache access and invalidation. Include the relevant scope and parameters when composing queries; do not create competing cache identities for the same resource.
- Check the generated mutation's existing invalidation behavior before adding a manual refetch. Refresh affected data rather than invalidating the entire QueryClient without a reason.
- Respect response envelopes and failures. An HTTP success or empty list is not proof of application success; preserve `requestFailed`, failure details, `fetchResult`, and pagination semantics where the contract uses them.
- Keep server data in React Query, transient component state in React state, and cross-component UI selection in the existing Jotai atoms where sharing is needed. Do not create a second authoritative copy of server data in atoms.
- Editable drafts may be local copies. Define when they initialize, reset, and submit; a background refetch must not silently discard unsaved input.
- Keep query scope, search, pagination, selection, and detail state consistent when the owning context changes. Use actual identifiers as values and names as labels.
- Use effects for synchronization and external effects. Compute derived display values directly or with justified memoization; do not use effects to maintain redundant derived state.

## Forms, UI, and Styling

- Reuse `@vizendjs/vizend-ui`, MUI, and the shared wrappers already used by the target feature. Preserve established `@vui/*` usage where it is part of that feature; do not replace the UI system during unrelated work.
- Use React Hook Form with the existing `Form` and `Field` components for comparable forms. Keep typed form values distinct from generated request types when editing requires a different shape.
- Reuse existing confirmation, dialog, loading-button, pagination, and grid components instead of rebuilding them for one screen.
- Handle submit success and failure through the existing mutation and notification contracts. Do not close a form or discard its draft before an awaited save succeeds.
- Use `l()` and the existing localization conventions for translatable labels. Reuse `getErrorMessage` and existing error presentation rather than duplicating response-error parsing in each component.
- Reuse theme values, design tokens, and existing shared classes. Use `sx` for local MUI adjustments and the episode's established SCSS structure for application styling; do not add broad global overrides to fix a single component.
- Keep grid rows and column callbacks typed with the actual model/RDO. Preserve pagination metadata and stable row identity when filtering, refreshing, or changing selection.

## TypeScript and Comments

- Follow the root Prettier configuration: single quotes, trailing commas, and a 120-character print width. Keep the existing TypeScript strict configuration.
- Use type inference for clear local values and explicit types at component props, public contracts, forms, and external data boundaries.
- Reuse generated model and request/response types. Keep UI-only props, drafts, and display types in the owning feature.
- Do not copy existing `any`, unchecked casts, non-null assertions, or suppressed checks as a convention. Narrow unknown values and represent optional data explicitly where the contract requires it.
- Write code comments in Korean. Keep identifiers and established technical terms where needed.
- Add concise comments for nontrivial component/hook responsibilities and branches, synchronization order, or design choices that need explanation. Do not restate JSX or add comments to every trivial callback.

## Testing and Verification

- Preserve the common rule against low-value tests: do not add tests that merely assert literal text, trivial renders, implementation details, or a mocked return value.
- Prioritize behavior that can break: request construction, response transformations, scoped query behavior, selection changes, form drafts, mutation failures, duplicate submissions, routing, and meaningful visual regressions.
- Reuse existing `tests/*.mjs`, colocated `.test.cjs`, focused TypeScript configurations, and Vite preview fixtures as appropriate. A source-string assertion or isolated mock alone does not prove that a UI interaction works.
- Use existing coverage when sufficient. For visible behavior changes, verify the relevant interaction in the browser or an existing preview fixture; avoid starting a new test framework for one change.
- Check actual package scripts before choosing commands. There are no root `test`, `lint`, or `typecheck` scripts to assume.
- Build producers before consumers when generated contracts or exports change: stub, then state, then view, then the episode. Limit verification to the affected packages and paths.

| Purpose                                    | Existing Command or Entry Point              |
| ------------------------------------------ | -------------------------------------------- |
| Start the application                      | `pnpm start:maro-app`                        |
| Build view and its stub/state dependencies | `pnpm build:maro-view`                       |
| Build the application                      | `pnpm build:maro-app`                        |
| Build one package                          | `pnpm --filter @vizendjs/<package> build`    |
| Check changed-file formatting              | `pnpm exec prettier --check <changed-files>` |
| Run an existing contract script            | `node tests/<existing-script>.mjs`           |
| Run a colocated Node test                  | `node --test <existing-file>.test.cjs`       |

- Use the pnpm version declared by `packageManager` and preserve the lockfile and current build configuration. Do not upgrade tooling or reformat the repository to make a scoped change pass.
