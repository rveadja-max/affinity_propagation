import re,zlib,sys
d=open(sys.argv[1],'rb').read()
m=re.search(rb'/Title\s*\((.*?)\)',d); print('META',m.group(1)[:200] if m else None)
out=[]
for s in re.finditer(rb'stream\r?\n(.*?)\r?\nendstream',d,re.S):
    try: t=zlib.decompress(s.group(1))
    except Exception: continue
    tj=re.findall(rb'\((.*?)(?<!\\)\)',t)
    txt=b''.join(tj)
    if len(txt)>50: out.append(txt)
    if len(out)>=3: break
for o in out: print(o[:700]); print('---')
