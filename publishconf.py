REPO = "\\\\koro\\pub"
PROJECT = "ForestSplit"
SOFT = "Max"
DEFAULT_PROJECTS = "acdc1,poat,lb"
DEPLOY_RULES = [
    {
        "title": "Maxscripts",
        "target_folder": "/",
        "ignore_patterns": ["Config"],
        "elements": ["*.ms"]
    },
    {
        "title": "Config",
        "target_folder": "/",
        "elements": ["Config"],
    },
    {
        "title": "misc files",
        "target_folder": "/",
        "elements": ["*.md"]
    }
]

IGNORE_PATTERNS = ["*.swp", "Local.ms"]  # Vim swap files -_-
