# GS Skills

A collection of custom OpenClaw skills for specialized workflows.

---

## 📦 Available Skills

### 1. GitHub Daily Report

**ID:** `github-daily-report`

Automatically monitors GitHub repositories and delivers AI-powered daily activity reports.

**Features:**
- 📊 Macro trend analysis (module热度 distribution)
- 🔥 Top 5 highlights with deep-dive insights
- 📈 Day-over-day trend comparison
- 🌍 Multi-language support (auto-detect or explicit)
- 📬 Multi-channel delivery (QQ/Telegram/Discord/etc.)

**Quick Start:**
```bash
# Copy skill to your skills directory
cp -r github-daily-report ~/.openclaw/workspace/skills/

# Configure
cp github-daily-report/config.example.json \
   github-daily-report/config.json
# Edit config.json with your settings

# Set up cron (example: daily at 9 AM)
openclaw cron add \
  --cron "0 9 * * *" \
  --tz "Asia/Shanghai" \
  --name "GitHub Daily Report" \
  --message "Generate 24h GitHub activity report" \
  --channel <your-channel> \
  --timeout-seconds 300
```

**Documentation:** See [`github-daily-report/SKILL.md`](github-daily-report/SKILL.md)

---

## 🚀 Usage

1. **Browse skills** — Explore the `*/` directories for available skills
2. **Copy to your environment** — `cp -r <skill-name> ~/.openclaw/workspace/skills/`
3. **Configure** — Follow each skill's `SKILL.md` for setup instructions
4. **Customize** — Modify configs, templates, or scripts as needed

---

## 📁 Structure

```
gs_skills/
├── README.md                     # This file
└── github-daily-report/          # Skill directory
    ├── SKILL.md                  # Main documentation
    ├── config.example.json       # Configuration template
    ├── scripts/
    │   └── fetch-commits.sh      # Data fetcher
    └── templates/
        └── report-template.md    # Report format
```

---

## 🛠️ Creating New Skills

Follow the [OpenClaw Skill Creator Guide](https://docs.openclaw.ai/skills/creating-skills):

1. **Design** — Identify workflow, scripts, references, assets needed
2. **Structure** — Use standard format: `SKILL.md` + resources
3. **Test** — Verify with real usage scenarios
4. **Package** — Use `openclaw skills package` for distribution

**Template:**
```
new-skill/
├── SKILL.md              # Required: YAML frontmatter + instructions
├── config.example.json   # Optional: Configuration template
├── scripts/              # Optional: Executable code
└── templates/            # Optional: Output templates
```

---

## 📝 Version History

| Date | Skill | Version | Notes |
|------|-------|---------|-------|
| 2026-02-28 | github-daily-report | 1.0.0 | Initial release |

---

## 🤝 Contributing

1. Create skill following OpenClaw guidelines
2. Test thoroughly in your environment
3. Commit with clear message
4. Push to this repo for sharing

---

## 📄 License

MIT

---

**Maintained by:** Gallen Shao  
**Repository:** https://github.com/GallenShao/gs_skills
