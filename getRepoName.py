#!/usr/bin/env python3
import sys
from pathlib import Path

from urllib3.util import parse_url

if __name__ == "__main__":
	raw = sys.argv[1]
	gitPrefix = "git@"
	if raw.startswith(gitPrefix):
		raw = "/".join(raw.split(":", 1))
	res = parse_url(raw).path.strip("/").split("/")[-1]
	gitPostfix = ".git"
	if res.endswith(gitPostfix):
		res = res[: -len(gitPostfix)]
	print(res)
