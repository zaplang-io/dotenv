# dotenv — .env configuration loader (python-dotenv parity).
#
# This is a scaffold placeholder. No library code is implemented yet; the
# first-slice public surface is pinned in the README and tracked by the kickoff
# epic (zaplang-io/dotenv#1) and its sub-issues:
#
#   * #2  public surface spec + README / threat model (docs-first)
#   * #3  .env parser: KEY=value, quoting, escapes, comments, export, multiline
#   * #4  load_dotenv / dotenv_values / find_dotenv + precedence semantics
#   * #5  variable interpolation: ${VAR}, defaults, \$ escaping, interpolate toggle
#
# Pinned public surface (see README.md and DECISIONS.md):
#
#   dotenv.load_dotenv(str path = ".env", bool override = false,
#                      bool interpolate = true) -> bool
#   dotenv.dotenv_values(str path = ".env", bool interpolate = true)
#       -> collections.OrderedDict[str, Optional[str]]
#   dotenv.find_dotenv(str filename = ".env") -> str
