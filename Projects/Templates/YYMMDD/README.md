# 🛡️TARGET_NAME

This repository contains all assets related to a specific penetration testing engagement. The structure is designed to ensure consistency, traceability, and quick onboarding for new team members or future retests.

## Folder Overview

### 📁 Artifacts

Stores any downloaded files from the app (logs, configs, exports), for offline review.

### 📁 Burp

Stores all **Burp Suite** project files:

- `.burp` files for each engagement day/session;
- exported issues, session states, or site maps (e.g., `.xml`, `.json`);
- naming convention: `YYMMDD-<[TARGET_NAME]>.burp`.

📌 *Tip*: avoid mixing multiple targets per project file. Use one `.burp` per subdomain or scope boundary for clarity.

### 📁 Demos

Client-provided or self-recorded demos explaining app functionality:

- video recordings;
- screenshots or walk-throughs;
- transcripts or keynotes (if applicable).

📌 *Tip*: store a short file with notes in this folder summarizing what each video/demo explains.

### 📁 Notes

For personal or team notes:

- environment details (IP ranges, domains, URLs);
- test accounts and credentials;
- notes on scope, timelines, and client communication.

### 📁 Resources

Reference material and documents related to the engagement:

- previous pentest reports (`.pdf`, `.docx`);
- architecture diagrams;
- access control documentation;
- API specs or Postman collections;
- security policies (if shared by client).

📌 *Tip*: consider renaming or tagging internal documents clearly, e.g., `confidential-client-architecture.pdf`.

### 📁 Tools

Auxiliary tools/scripts used or developed during the engagement:

- one-off Python/Bash scripts;
- tool output files (e.g., `nmap.xml`, `nikto.log`, `ffuf.txt`);
- tool configurations and wordlists (if specific to this target).

📌 *Tip*: include comments explaining how each tool/script was used and with what parameters.