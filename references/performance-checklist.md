# Performance checklist

Measure first, then optimize.

## Baseline

- Capture current latency and throughput before changes.
- Identify the top bottleneck with profiling tools.
- Record the test scenario used for measurement.

## Common hotspots

- N+1 data access in loops.
- Missing pagination or unbounded list endpoints.
- Heavy work on request path without caching.
- Repeated serialization/deserialization in hot paths.
- Large frontend bundles or blocking scripts.

## Verification

- Compare before/after numbers in the same environment.
- Verify tail latency, not just averages.
- Ensure optimizations do not change behavior.

## Red flags

- Optimizing without a baseline.
- Trading correctness for micro-gains.
- Benchmarking with unrealistic data sizes.
