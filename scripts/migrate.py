#!/usr/bin/env python3
"""Re-apply the Universal Reader rebrand after each upstream sync (idempotent)."""
from pathlib import Path
import os
ROOT = Path(__file__).resolve().parent.parent

def main():
    TEXT_EXTS = {'.lua','.json','.md','.txt','.html','.sh','.service','.desktop','.xml','.spec','.yml','.yaml','.conf'}
    SKIP = {'.git','node_modules','base','scripts'}
    changed = 0
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP]
        for fn in filenames:
            p = Path(dirpath)/fn
            if p.suffix.lower() not in TEXT_EXTS: continue
            try: s = p.read_text(encoding='utf-8')
            except Exception: continue
            o = s
            s = s.replace('KOReader','Universal Reader')
            if s != o:
                p.write_text(s, encoding='utf-8'); changed += 1
    print(f'migrate: {changed} files updated')

if __name__ == '__main__':
    main()
