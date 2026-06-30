# Copyright (C) 2026 Red Hat, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
"""
Replaces all guide/latest content with their redirect counterpart to new docs page
available at https://docs.cockpit-project.org
"""

import os
import re

for dname, _dirs, files in os.walk("./latest"):
    for fname in files:
        fpath = os.path.join(dname, fname)
        with open(fpath, "r+", encoding="utf-8") as f:
            s = f.read()
            s = re.sub(
                r"<head>.*\n[\s\S]+(?=<\/body>)",
                '<head>\n' \
                    f'<meta http-equiv="refresh" content="0; url=https://docs.cockpit-project.org/cockpit-guide/latest/guide/{fname}">\n' \
                    f'<link rel="canonical" href="https://docs.cockpit-project.org/cockpit-guide/latest/guide/{fname}" />\n' \
                '</head>\n' \
                '<body>\n',
                s,
            )
            f.seek(0)
            f.write(s)
            f.truncate()
