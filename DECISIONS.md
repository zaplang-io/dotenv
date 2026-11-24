# dotenv package decisions

Design decisions for the Zap `dotenv` library, keyed to issues. Each records a
choice that could not be read straight off Python's
[python-dotenv](https://github.com/theskumar/python-dotenv), with the reference
it follows or departs from. Signature ambiguities are resolved with the
maintainer (with a Python example) before being recorded here.

## Parity target: python-dotenv

The package tracks [**python-dotenv**](https://github.com/theskumar/python-dotenv)
as its primary API reference. Where Zap's static typing, numeric model, or string
semantics force a divergence, it is recorded below, keyed to the issue that
introduces it.

## Kickoff decisions (pinned at scaffold; see [Epic #1](https://github.com/zaplang-io/dotenv/issues/1))

These are provisional pins made when the public surface was specified; each is
confirmed (or amended) in the surface-spec issue
[#2](https://github.com/zaplang-io/dotenv/issues/2) before implementation.

- **Ordered return type.** `dotenv_values` returns
  `collections.OrderedDict[str, Optional[str]]`. The built-in `dict` iteration
  order is unspecified/seeded (core D-0235), so insertion order — which
  python-dotenv guarantees via `OrderedDict` — comes from `collections.OrderedDict`.
- **Value type `Optional[str]`.** A key present with no `=` (bare `FOO`) maps to
  `None`, matching python-dotenv's `Dict[str, Optional[str]]`; `FOO=` maps to `""`.
- **`find_dotenv` not-found sentinel — OPEN.** python-dotenv returns `""`.
  Proposed for parity: return `str` and `""` when nothing is found. The
  Zap-idiomatic alternative is `Optional[str]` returning `None`. Recommendation:
  `""` for parity; **to be confirmed by the maintainer in #2.**
- **Keyword arguments.** python-dotenv relies on `override=` / `interpolate=` as
  keywords; Zap supports keyword args, so the signatures keep the same keyword
  names and defaults.
- **Errors (return vs. raise).** A missing file is a no-op (`load_dotenv` returns
  `false`, `dotenv_values` returns an empty map), matching python-dotenv's
  default. Malformed-syntax errors raise `"dotenv: <reason>"` per the Zap
  convention.
- **Encoding.** Zap strings are UTF-8; the first slice assumes utf-8 input. A
  non-utf-8 `encoding` option is deferred to a later phase.
