---
name: github-daily-report
description: Automate GitHub repository activity monitoring and AI-powered daily reports. Use when setting up scheduled code change summaries with trend analysis and multi-channel delivery (Telegram/Discord/etc.).
---

# GitHub Daily Report Skill

Automatically monitors specified GitHub repositories, analyzes commit patterns, and delivers AI-curated daily reports to your preferred channels.

## Quick Start

This skill requires **interactive setup**. When triggered, guide the user through these configuration steps:

### Step 1: Gather Required Information

Ask the user for:

1. **Repository to monitor**
   - GitHub URL (e.g., `https://github.com/owner/repo.git`)
   - Or local path if already cloned

2. **Report schedule**
   - What time? (e.g., "9 AM", "17:00")
   - Timezone? (default: `Asia/Shanghai`)

3. **Delivery destination**
   - First, check available channels: run `openclaw message --help` or inspect OpenClaw config
   - Ask user: "Which channel should I send reports to? Available: [list channels]"
   - Specific recipient? (optional, for targeted delivery)

4. **Report language**
   - Detect user's preferred language from conversation
   - Ask if unclear: "Should reports be in Chinese, English, or another language?"
   - Default to user's conversation language

5. **Report preferences** (optional)
   - How many highlights? (default: 5)
   - Lookback period? (default: 24 hours)
   - Report storage location? (default: `reports/github-daily/`)

### Step 2: Clone Repository (if needed)

```bash
# If user hasn't cloned yet
git clone <repo-url> <local-path>
```

**Tip:** Suggest cloning to `workspace/repos/<repo-name>/` for organization.

### Step 3: Create Configuration

Create a config file at `skills/github-daily-report/config.json`:

```json
{
  "repoPath": "/root/.openclaw/workspace/repos/openclaw-official",
  "repoUrl": "https://github.com/openclaw/openclaw.git",
  "reportTime": "09:00",
  "timezone": "Asia/Shanghai",
  "channel": "<channel-id>",
  "to": "",
  "reportDir": "reports/github-daily",
  "topHighlights": 5,
  "lookbackHours": 24
}
```

**Explain each field:**

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `repoPath` | ✅ | Local path to cloned repo | `/workspace/repos/my-repo` |
| `repoUrl` | ✅ | GitHub repository URL | `https://github.com/owner/repo` |
| `reportTime` | ✅ | Delivery time (HH:MM or cron) | `09:00` or `0 9 * * *` |
| `timezone` | ❌ | IANA timezone | `Asia/Shanghai` |
| `channel` | ✅ | Target channel ID (check available: `openclaw message --help`) | `qqbot`, `telegram`, `discord` |
| `to` | ❌ | Specific recipient (leave empty for broadcast) | Channel-specific ID |
| `language` | ❌ | Report language (`auto` or explicit code) | `auto`, `zh-CN`, `en-US` |
| `reportDir` | ❌ | Report storage (workspace-relative) | `reports/github-daily` |
| `topHighlights` | ❌ | Number of highlights to feature | `5` |
| `lookbackHours` | ❌ | Hours of commits to analyze | `24` |

### Step 4: Set Up Cron Job

```bash
openclaw cron add \
  --cron "0 9 * * *" \
  --tz "Asia/Shanghai" \
  --name "GitHub Daily Report" \
  --message "Generate 24h GitHub activity report.

Workflow:
1. Read config from skills/github-daily-report/config.json
2. Run fetch-commits.sh to get commit titles
3. Analyze macro trends (module热度 distribution)
4. Select top 5 highlights, deep-dive with git show
5. Write report to configured reportDir/YYYY-MM-DD.md
6. Read previous 2 days reports for trend comparison
7. Send to configured channel" \
  --channel <channel-from-config> \
  --timeout-seconds 300
```

**Adjust based on user preferences:**
- Change `--cron` for different schedules
- Change `--channel` based on config (use value from config.json)
- Add `--to` if targeting specific recipient (optional)

### Step 5: Test Immediately

Create a test job running in 2 minutes:

```bash
openclaw cron add \
  --at "+2m" \
  --name "GitHub Report Test" \
  --message "Generate test report and send to configured channel" \
  --channel <channel-from-config> \
  --timeout-seconds 300
```

Verify the user receives the report correctly.

---

## Report Format

Reports follow this structure (see `templates/report-template.md`):

```markdown
# [Repo Name] 24h Activity

**Date:** YYYY-MM-DD  
**Total Commits:** [count]

## 📊 Macro Trends
- [Module A] — ~[count] commits ([note])
- [Module B] — ~[count] commits

## 🔥 Top 5 Highlights
1. 【[Category]】[Title]
   - **Issue:** [background]
   - **Change:** [what changed]
   - **Impact:** [user impact]

## 📈 Trend Comparison
- vs [date]: [trend analysis]

## 📝 Observations
1. [insight]
```

### Language Adaptation

**The AI should generate reports in the user's preferred language:**

1. **Detect language** from `config.json`:
   - `"language": "auto"` → Use conversation language
   - `"language": "zh-CN"` → Chinese (Simplified)
   - `"language": "en-US"` → English
   - Other codes → Adapt accordingly

2. **Adapt all elements**:
   - Section headers (e.g., `## 📊 宏观动向` vs `## 📊 Macro Trends`)
   - Field labels (e.g., `**日期：**` vs `**Date**:`)
   - Analysis text (e.g., `绝对热点` vs `absolute hotspot`)
   - Emoji usage (keep universal emojis, adapt text)

3. **Template is a guide** — `templates/report-template.md` shows structure, but AI should translate content dynamically based on `language` config.

**Example configurations:**

```json
// Chinese report
{ "language": "zh-CN" }

// English report
{ "language": "en-US" }

// Auto-detect (default)
{ "language": "auto" }
```

---

## Customization Guide

### Change Monitoring Frequency

Edit the cron expression in the cron job:

```bash
openclaw cron edit <job-id> --cron "0 */6 * * *"  # Every 6 hours
openclaw cron edit <job-id> --cron "0 9 * * 1"    # Weekly (Mondays)
```

### Change Delivery Channel

```bash
openclaw cron edit <job-id> --channel telegram --to "123456789"
```

### Adjust Analysis Depth

Edit `config.json`:
- Increase `topHighlights` for more detailed reports
- Decrease `lookbackHours` for shorter windows (e.g., `12` for half-day)

### Add Multiple Repositories

Create separate skill instances:

```
skills/
  ├── github-daily-openclaw/
  ├── github-daily-myproject/
  └── github-daily-deps/
```

Each with its own `config.json` and cron job.

### Customize Report Template

Edit `templates/report-template.md` to:
- Add/remove sections
- Change formatting
- Add custom analysis angles (e.g., author contributions, file type distribution)

---

## Scripts

### fetch-commits.sh

**Location:** `scripts/fetch-commits.sh`

**Usage:**
```bash
./scripts/fetch-commits.sh <repo-path> [hours]
```

**Output:** Commit list (hash + subject) to stdout, stats to stderr.

**To modify:**
- Change git log format for different output
- Add filtering logic (e.g., exclude merge commits)
- Add author/email extraction for contributor analysis

---

## Troubleshooting

**Q: No report generated?**
- Check if `repoPath` exists and is a valid git repo
- Run `openclaw cron list` to verify job is enabled
- Check cron run history: `openclaw cron runs`

**Q: Delivery failed?**
- Verify channel is configured in OpenClaw (check: `openclaw message --help` or config files)
- Test manual message: `openclaw message send --channel <channel> "test"`
- Check channel permissions and recipient ID (if using `to` field)

**Q: No trend comparison?**
- First report has no history (normal)
- Ensure `reportDir` contains previous reports
- Check report file naming matches `YYYY-MM-DD.md`

**Q: Wrong commits analyzed?**
- Verify `lookbackHours` in config
- Check timezone matches user's expectation
- Ensure `git pull` is working (script auto-pulls)

---

## Files

- `SKILL.md` — This file (setup guide and customization)
- `scripts/fetch-commits.sh` — Commit data fetcher
- `templates/report-template.md` — Report format template
- `config.json` — User configuration (created during setup)

---

## Best Practices

1. **Start with a test run** — Always verify with a 2-minute cron before scheduling
2. **Keep reports concise** — 5 highlights is usually enough; adjust if user wants more/less
3. **Trend comparison matters** — Encourage user to keep at least 2-3 days of reports
4. **Channel selection** — Check available channels first (`openclaw message --help` or inspect config), let user choose
5. **Language adaptation** — Detect user's language from conversation, translate all report elements accordingly
6. **Graceful degradation** — If git pull fails, continue with local data (don't abort)

---

## Security Notes

- **repoUrl** is only used for initial clone reference; actual operations use local `repoPath`
- **No API keys required** — Uses public git protocol or existing SSH keys
- **Channel delivery** respects OpenClaw's channel security model
- **Config file** should not be committed to version control (add to .gitignore)
