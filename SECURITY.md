# 🔒 Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a vulnerability in this workspace or its components, please follow responsible disclosure:

1. **DO NOT** create a public GitHub issue
2. Send details to **dev@deepsec-labs.com**
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### Response Timeline

- **24h:** Acknowledgment of receipt
- **72h:** Initial assessment and severity classification
- **7 days:** Fix or mitigation plan
- **30 days:** Public disclosure (if applicable)

## Scope

This policy covers:
- Smart contracts in `depin/contracts/`
- Scripts in `scripts/`
- Connectors in `depin/connectors/`
- CI/CD pipelines in `.github/workflows/`

## Out of Scope

- Findings already documented in `audits/` (awaiting bounty processing)
- Third-party dependencies (report to respective maintainers)
- Theoretical vulnerabilities without practical exploit

## Recognition

We credit researchers who report valid vulnerabilities in our `CREDITS.md` file (upon request).

---

*Last updated: 2026-06-03*
