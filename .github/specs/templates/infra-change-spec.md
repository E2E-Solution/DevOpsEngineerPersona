# Infrastructure Change Specification

> Copy this template and fill in each section.

## Title
<!-- One-line description of the infrastructure change -->

## Context
<!-- Why is this change needed? What problem does it solve? -->

## Change Description

### Resources Affected
| Resource | Action | Details |
|----------|--------|---------|
| | Create/Modify/Delete | |

### Environments Affected
- [ ] PR (ephemeral)
- [ ] QA
- [ ] Production

## Technical Design

### Bicep Changes
<!-- What parameters, resources, or outputs change? -->

### Pipeline Changes
<!-- Changes to GitHub Actions workflows -->

### Configuration Changes
<!-- Changes to staticwebapp.config.json, host.json, docker-compose.yml, etc. -->

## Cost Impact
<!-- Estimate monthly cost change per environment -->
| Environment | Current | After Change | Delta |
|-------------|---------|--------------|-------|
| PR | | | |
| QA | | | |
| Production | | | |

## Rollback Plan
<!-- How to undo this change if something goes wrong -->

## Acceptance Criteria
- [ ] `az deployment group validate` passes for all environments
- [ ] Infrastructure deploys successfully in PR environment
- [ ] No disruption to existing QA/Production resources
- [ ] Documentation updated if new secrets or configuration required

## Security Considerations
<!-- RBAC changes, network exposure, secret management -->
