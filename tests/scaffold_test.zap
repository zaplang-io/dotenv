# Scaffold placeholder test. The real positive AND negative suites — parser,
# loaders, interpolation, and discovery — arrive with the first-slice
# implementation tracked by the epic's sub-issues (zaplang-io/dotenv#2-#5).
# This asserts only that the test harness runs, so CI is meaningful before any
# library code exists.
@test
def _scaffold_harness_runs():
    assert 1 + 1 == 2
