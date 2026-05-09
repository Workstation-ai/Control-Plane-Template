# Self-Hosted: Data Privacy & Terms

This document outlines privacy standards and terms for self-hosted deployments using this template.

## 1. Data Sovereignty

When self-hosting (Docker, Kubernetes, or source):
* **No External Access:** The template does not host, store, or access your data.
* **On-Premise Storage:** All data resides on your infrastructure.
* **Air-Gap Capable:** Can operate in air-gapped environments with local providers.

## 2. Telemetry (Optional)

If you add telemetry:
* Collect only anonymous usage data
* No PII, documents, or chat logs
* Provide opt-out mechanism

## 3. Third-Party Integrations

If connecting to external services (OpenAI, Anthropic, etc.):
* Data transmitted directly to provider
* Subject to their Terms of Service

## 4. Security & Network

* You are responsible for firewall, SSL/TLS, and access control
* Use environment variables for all secrets
* Never commit sensitive data to version control

## 5. Licensing

* Base template provided under **MIT License**
* No warranty, express or implied
* Your custom code is yours

## 6. Support

Self-hosted deployments are at user's discretion. No SLAs unless negotiated separately.

---
*Last Updated: May 2026*
