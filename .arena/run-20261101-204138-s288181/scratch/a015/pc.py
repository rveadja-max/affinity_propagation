import re,zlib,sys
for f in sys.argv[1:]:
    d=open(f,'rb').read(); txt=d
    for m in re.finditer(rb'stream\r?\n(.*?)endstream',d,re.S):
        try: txt+=zlib.decompress(m.group(1))
        except Exception: pass
    c=re.findall(rb'/Count (\d+)',txt)
    print(f, 'Count', max(map(int,c)) if c else None, 'Pages', len(re.findall(rb'/Type\s*/Page[^s]',txt)))
