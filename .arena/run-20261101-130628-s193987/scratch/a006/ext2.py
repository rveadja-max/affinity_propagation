import re,zlib,sys
d=open(sys.argv[1],'rb').read()
n=0
for s in re.finditer(rb'stream\r?\n(.*?)\r?\nendstream',d,re.S):
    try: t=zlib.decompress(s.group(1))
    except Exception: continue
    for k in [rb'/Title',rb'dc:title',rb'Comment',rb'mproved',rb'Brusco']:
        i=t.find(k)
        if i>=0: print(k, t[max(0,i-100):i+400]); n+=1
    if n>8: break
