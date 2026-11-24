# dotenv

`.env` configuration loader for [Zap](https://github.com/zaplang-io/zap) — an official **non-core** package.

- Tracking issue: [zaplang-io/zap#320](https://github.com/zaplang-io/zap/issues/320)
- Contributor & agent conventions: [AGENTS.md](AGENTS.md)
- Design decisions: [DECISIONS.md](DECISIONS.md)

The public surface is pinned but not yet implemented. The [kickoff epic](https://github.com/zaplang-io/dotenv/issues/1) tracks the first slice (parser, loaders, interpolation, discovery).

## Goals

A typed Zap `.env` loader whose public API mirrors Python's [**python-dotenv**](https://github.com/theskumar/python-dotenv) as closely as Zap's static typing allows. API parity with the popular Python library is a project rule — see [AGENTS.md](AGENTS.md).

First-slice scope (the kickoff epic):

- **`.env` parsing** — `KEY=value`, single/double quoting, escapes, comments, blank lines, `export KEY=val`, multiline values.
- **`load_dotenv`** — populate the process environment, with existing-env-vs-file precedence (`override`).
- **`dotenv_values`** — return an ordered map without mutating the environment.
- **Variable interpolation** — `${VAR}` / `${VAR:-default}` referencing earlier keys and existing env, toggleable with `interpolate`.
- **`find_dotenv`** — discover the nearest `.env` by walking up parent directories.

Deferred breadth (named in the epic, not yet scheduled): mutation helpers (`get_key`/`set_key`/`unset_key`), a CLI tool, stream/IO sources, and typed coercion helpers.

## Public surface (first slice)

These signatures are pinned in [Epic #1](https://github.com/zaplang-io/dotenv/issues/1) / the surface-spec issue [#2](https://github.com/zaplang-io/dotenv/issues/2); the README and the issues are kept in agreement.

```zap
import dotenv
import collections

# Populate the process environment from a .env file. Returns true if the file
# was found and applied. By default a variable already set in the environment
# wins over the file (override=false); ${VAR} interpolation is on.
dotenv.load_dotenv(str path = ".env", bool override = false, bool interpolate = true) -> bool

# Parse a .env file into an ordered map WITHOUT mutating os.environ.
# A bare key (no '=') maps to None; `KEY=` maps to "".
dotenv.dotenv_values(str path = ".env", bool interpolate = true)
    -> collections.OrderedDict[str, Optional[str]]

# Walk up from the current directory to the nearest `filename`; "" if none.
dotenv.find_dotenv(str filename = ".env") -> str
```

Illustrative usage:

```zap
import dotenv
import collections

def main():
    # Discover + load .env from the CWD (or an ancestor) into the process env.
    dotenv.load_dotenv()

    # Explicit path; let file values win over the inherited environment.
    dotenv.load_dotenv(".env.local", override=true)

    # Read values without touching os.environ (ordered, python-dotenv parity).
    collections.OrderedDict[str, Optional[str]] cfg = dotenv.dotenv_values(".env")
    str url = cfg["DATABASE_URL"] ?? "sqlite://:memory:"
```

The exact signatures (keyword vs positional, defaults, return shapes) follow python-dotenv; any forced divergence is escalated to the maintainer with a Python example and recorded in [DECISIONS.md](DECISIONS.md) rather than decided unilaterally.

## Threat model

The `.env` file is **author-controlled / trusted** — this is local application config, not attacker-supplied input. Parsing is nonetheless defensive: total file size, line count, and interpolation expansion are bounded so a pathological file cannot hang the loader. Interpolation performs **variable substitution only** — command substitution (`$(...)`) and arbitrary shell evaluation are an explicit non-goal and are never executed. (Concrete resource caps are fixed in the surface-spec issue.)

## Build and test

```
sh tools/test.sh
```

GitHub Actions runs the suite on pull requests and pushes inside the `ghcr.io/zaplang-io/zap:latest` container. CI stays pinned to `zap:latest` until this module reaches a 1.0 release. The test suite is a scaffold placeholder until the first-slice implementation lands via the epic's sub-issues.

## Development

Read **[AGENTS.md](AGENTS.md)** before contributing — it covers the python-dotenv-parity rule, the one-issue-one-PR flow, how design decisions are recorded in **[DECISIONS.md](DECISIONS.md)**, and the rule for reporting core Zap language/stdlib defects upstream in `zaplang-io/zap` (rather than working around them here).
