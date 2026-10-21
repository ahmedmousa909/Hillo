import { cp, mkdir, readdir, rm, stat } from 'node:fs/promises';
import { join } from 'node:path';
const root=process.cwd(); const out=join(root,'www');
await rm(out,{recursive:true,force:true}); await mkdir(out,{recursive:true});
const excluded=new Set(['www','android','ios','node_modules','.git','.github','scripts','supabase']);
for (const name of await readdir(root)) {
  if (excluded.has(name) || name.startsWith('.') || ['package.json','package-lock.json','capacitor.config.json','README.md'].includes(name)) continue;
  const path=join(root,name); const info=await stat(path);
  if(info.isDirectory() || /\.(html|css|js|json|png|jpg|jpeg|svg|webp|ico|webmanifest|woff2?|ttf)$/i.test(name)) await cp(path,join(out,name),{recursive:true});
}
console.log('HILLO web assets copied into www/');
