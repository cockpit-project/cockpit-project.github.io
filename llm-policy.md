---
title: Cockpit Project LLM (AI) Development Policy
---

This policy, based on Jellyfin's LLM Policy and licensed under CC-BY-ND-4.0, establishes guidelines for using AI tools in Cockpit Project development.
The policy applies to all repositories in Cockpit Project's GitHub Organization.

### No LLM-Generated Direct Communication

LLM output cannot be used verbatim in:
- Issues, comments, or pull request content
- Forum or chat posts
- Security reports

All communication must be in your own words and demonstrate understanding.

**Exceptions:**
- Language translation must be clearly stated
- Maintainer-configured LLM bots may suggest PR changes (suggestions only)

Violations may result in submission closure or permanent project bans.

### LLM Code Contributions

You may use LLMs to assist with code, but you're fully responsible for submissions.

**Requirements:**
- Follow CONTRIBUTING.md and HACKING.md guidelines
- Each commit assisted by an LLM needs a git-trailer `Assisted-by: LLM`
- Keep changes concise and focused
- Match existing formatting standards
- Remove unnecessary comments and LLM metadata
- Code must build, run, and pass tests
- Explicitly test modified functionality

**Understanding and Ownership:**
- Review all generated code
- Explain changes in your own words
- Be able to discuss and justify modifications

**Handling Review Feedback:**
- Don't paste feedback into LLMs and blindly resubmit
- Respond thoughtfully using your own words
- Make minimal, targeted changes
- Understand required implementations

**Final Discretion:**
Maintainers may reject oversized, overly complex, or poorly structured PRs after correction attempts, regardless of LLM use.

### Rule of Thumb

"Do not prompt an LLM vaguely. Do not commit the LLM results unchanged. And do not submit them as-is."

Using LLMs as tools is acceptable; using them as replacements for understanding and responsibility is not.
