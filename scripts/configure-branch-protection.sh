#!/usr/bin/env bash
set -euo pipefail

REPO="brianhartsock/ansible-role-zsh"
BRANCH="master"
REQUIRED_CHECKS=("Lint" "Molecule")

CHECK_ONLY=false
if [[ "${1:-}" == "--check" ]]; then
  CHECK_ONLY=true
fi

echo "Repository: $REPO"
echo "Branch: $BRANCH"
echo "Required checks: ${REQUIRED_CHECKS[*]}"
echo ""

# Fetch current branch protection
echo "==> Fetching current branch protection..."
CURRENT=$(gh api "repos/$REPO/branches/$BRANCH/protection" 2>&1) || true

if echo "$CURRENT" | jq -e '.required_status_checks' &>/dev/null; then
  echo "Branch protection exists."
  CURRENT_CHECKS=$(echo "$CURRENT" | jq -r '.required_status_checks.checks[]?.context // empty' 2>/dev/null || true)

  if [[ -n "$CURRENT_CHECKS" ]]; then
    echo "Current required checks:"
    echo "$CURRENT_CHECKS" | sed 's/^/  - /'
  else
    echo "No required status checks configured."
  fi

  # Report missing checks
  MISSING=()
  for check in "${REQUIRED_CHECKS[@]}"; do
    if ! echo "$CURRENT_CHECKS" | grep -qx "$check"; then
      MISSING+=("$check")
    fi
  done

  if [[ ${#MISSING[@]} -gt 0 ]]; then
    echo ""
    echo "Missing checks: ${MISSING[*]}"
  else
    echo ""
    echo "All required checks are configured."
  fi
else
  echo "No branch protection configured."
  MISSING=("${REQUIRED_CHECKS[@]}")
fi

if [[ "$CHECK_ONLY" == true ]]; then
  echo ""
  echo "==> Check-only mode, no changes made."
  exit 0
fi

if [[ ${#MISSING[@]} -eq 0 ]]; then
  echo ""
  echo "==> Nothing to configure."
  exit 0
fi

echo ""
echo "==> Configuring branch protection with required status checks..."

# Build the checks array for the API
CHECKS_JSON=$(printf '%s\n' "${REQUIRED_CHECKS[@]}" | jq -R '{"context": ., "app_id": -1}' | jq -s '.')

gh api "repos/$REPO/branches/$BRANCH/protection" \
  --method PUT \
  --input - <<EOF
{
  "required_status_checks": {
    "strict": false,
    "checks": $CHECKS_JSON
  },
  "enforce_admins": false,
  "required_pull_request_reviews": null,
  "restrictions": null
}
EOF

echo ""
echo "==> Verifying configuration..."
VERIFY=$(gh api "repos/$REPO/branches/$BRANCH/protection/required_status_checks")
echo "Required status checks after update:"
echo "$VERIFY" | jq -r '.checks[]?.context // .contexts[]? // empty' | sed 's/^/  - /'
echo ""
echo "Done. Branch protection configured successfully."
