#!/usr/bin/env python3
"""Re-apply the Universal Reader rebrand after each upstream sync (idempotent)."""
from pathlib import Path
import os
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent

def main():
    PROTECT = [
        'koreader.rocks',
        'github.com/koreader/koreader-base',
        'github.com/koreader/test-data',
        'github.com/koreader/koreader-fonts',
        'github.com/koreader/koreader-translations',
        'github.com/koreader/android-luajit-launcher',
        'org.koreader.launcher',
    ]
    REPL = [
        ('github.com/koreader/koreader','github.com/yashhasan570/UniversalReader'),
        ('libkoreader-','libuniversalreader-'),
        ('KOREADER_','UNIVERSALREADER_'),
        ('koreader-base','universalreader-base'),
        ('koreader-dicts','universalreader-dicts'),
        ('KOReader','Universal Reader'),
        ('koreader','universalreader'),
        ('app.universalreader.reader','app.universalreader.reader'),
    ]
    SKIP = {'.github', '.git','node_modules','scripts'}
    changed = 0
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP]
        for fn in filenames:
            p = Path(dirpath)/fn
            if p.name in ('migrate.py',): continue
            try: s = p.read_text(encoding='utf-8')
            except Exception: continue
            o = s
            for a in PROTECT: s = s.replace(a, chr(1)+'PT'+chr(1))
            for a,b in REPL: s = s.replace(a,b)
            s = s.replace(chr(1)+'PT'+chr(1),'')
            if s != o:
                p.write_text(s, encoding='utf-8'); changed += 1
    badge = ROOT/'scripts/icons/badge.png'
    n = 0
    if badge.exists():
        img = Image.open(badge).convert('RGBA')
        for t in ROOT.glob('platform/*/universalreader.png') + ROOT.glob('platform/*/universalreader-mx.png'):
            p = t
            try:
                ref = Image.open(p); w,h = ref.size
                canvas = Image.new('RGBA',(w,h),(0,0,0,0))
                inner = img.resize((w,h), Image.LANCZOS)
                canvas.paste(inner,(0,0),inner)
                canvas.save(p)
                n += 1
            except Exception:
                pass
    print(f'migrate: {changed} files swept, {n} icon files updated')

if __name__ == '__main__':
    main()
