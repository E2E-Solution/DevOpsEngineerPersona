#!/usr/bin/env bash
# ============================================================================
# E2E Test Summary Generator
# ============================================================================
# Generates a GitHub Actions step summary from Playwright JSON results.
#
# Usage:
#   scripts/e2e-summary.sh [TITLE] [TESTED_URL] [ARTIFACT_NAME]
#
# Arguments:
#   TITLE         - Summary heading (default: "E2E Test Results")
#   TESTED_URL    - URL that was tested (optional, shown in summary)
#   ARTIFACT_NAME - Name of the artifact containing the full report
#
# Expects playwright-report/results.json to exist in the working directory.
# ============================================================================

set -euo pipefail

TITLE="${1:-E2E Test Results}"
TESTED_URL="${2:-}"
ARTIFACT_NAME="${3:-playwright-report}"

echo "## 🎭 ${TITLE}" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

if [ -n "$TESTED_URL" ]; then
  echo "**Tested URL:** ${TESTED_URL}" >> "$GITHUB_STEP_SUMMARY"
  echo "" >> "$GITHUB_STEP_SUMMARY"
fi

if [ ! -f playwright-report/results.json ]; then
  echo "❌ E2E tests may have failed. Check the logs above." >> "$GITHUB_STEP_SUMMARY"
  echo "" >> "$GITHUB_STEP_SUMMARY"
  echo "📊 **Full Report:** Download the \`${ARTIFACT_NAME}\` artifact for detailed HTML report." >> "$GITHUB_STEP_SUMMARY"
  exit 0
fi

# Parse results from JSON
TOTAL=$(jq '.stats.expected + .stats.unexpected + .stats.flaky + .stats.skipped' playwright-report/results.json)
PASSED=$(jq '.stats.expected' playwright-report/results.json)
FAILED=$(jq '.stats.unexpected' playwright-report/results.json)
FLAKY=$(jq '.stats.flaky' playwright-report/results.json)
SKIPPED=$(jq '.stats.skipped' playwright-report/results.json)
DURATION=$(jq '.stats.duration' playwright-report/results.json)
DURATION_SEC=$(echo "scale=2; $DURATION / 1000" | bc)

if [ "$FAILED" -eq 0 ]; then
  echo "### ✅ All Tests Passed" >> "$GITHUB_STEP_SUMMARY"
else
  echo "### ❌ Some Tests Failed" >> "$GITHUB_STEP_SUMMARY"
fi
echo "" >> "$GITHUB_STEP_SUMMARY"
echo "| Metric | Count |" >> "$GITHUB_STEP_SUMMARY"
echo "|--------|-------|" >> "$GITHUB_STEP_SUMMARY"
echo "| ✅ Passed | $PASSED |" >> "$GITHUB_STEP_SUMMARY"
echo "| ❌ Failed | $FAILED |" >> "$GITHUB_STEP_SUMMARY"
echo "| ⚠️ Flaky | $FLAKY |" >> "$GITHUB_STEP_SUMMARY"
echo "| ⏭️ Skipped | $SKIPPED |" >> "$GITHUB_STEP_SUMMARY"
echo "| **Total** | **$TOTAL** |" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"
echo "⏱️ **Duration:** ${DURATION_SEC}s" >> "$GITHUB_STEP_SUMMARY"

# List failed tests if any
if [ "$FAILED" -gt 0 ]; then
  echo "" >> "$GITHUB_STEP_SUMMARY"
  echo "### Failed Tests" >> "$GITHUB_STEP_SUMMARY"
  echo "" >> "$GITHUB_STEP_SUMMARY"
  jq -r '.suites[].suites[]?.specs[]? | select(.ok == false) | "- ❌ \(.title)"' playwright-report/results.json >> "$GITHUB_STEP_SUMMARY" 2>/dev/null || true
  jq -r '.suites[].specs[]? | select(.ok == false) | "- ❌ \(.title)"' playwright-report/results.json >> "$GITHUB_STEP_SUMMARY" 2>/dev/null || true
fi

echo "" >> "$GITHUB_STEP_SUMMARY"
echo "📊 **Full Report:** Download the \`${ARTIFACT_NAME}\` artifact for detailed HTML report." >> "$GITHUB_STEP_SUMMARY"
