---
applyTo: ".github/specs/**"
---

# Specification Kit

This directory contains **structured specifications** for guiding both human developers and AI agents. Instead of writing ad-hoc prompts, use these templates to create versioned, reviewable specs that produce consistent, high-quality implementations.

## Why Specifications?

Prompts are ephemeral — they live in chat windows and disappear when the session ends. Specifications are **durable, structured, and designed to be consumed by both humans and agents** across the entire lifecycle of a feature.

A well-written specification gives an agent the same information a product manager would give an experienced engineer: the business context, the technical constraints, the user expectations, and the definition of done.

## Templates

| Template | When to Use |
|----------|-------------|
| [feature-spec.md](templates/feature-spec.md) | New features, enhancements, UI changes |
| [bug-fix-spec.md](templates/bug-fix-spec.md) | Bug reports with reproduction steps |
| [infra-change-spec.md](templates/infra-change-spec.md) | Infrastructure, CI/CD, or deployment changes |

## How to Use

1. Copy the appropriate template to `specs/` with a descriptive name
2. Fill in all sections (leave "N/A" for truly inapplicable sections)
3. Submit the spec as a PR for team review, or reference it in a Copilot chat
4. After implementation, the spec serves as documentation of _why_ the change was made

## Examples

See the `examples/` directory for completed specs that demonstrate the expected level of detail.
