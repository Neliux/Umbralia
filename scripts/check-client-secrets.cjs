'use strict';
const fs=require('node:fs'),path=require('node:path');
const root=path.resolve(__dirname,'..');
const files=['index.html','config.js','assets/ranked/ranked.js','assets/ranked/accounts.js','assets/ranked/menu.js','src/accounts.js'];
const patterns=[/sb_secret_[A-Za-z0-9_-]{8,}/g,/(?:postgres|postgresql):\/\/[^\s:'"<>]+:[^\s@'"<>]+@/g,/(?:ghp_|github_pat_)[A-Za-z0-9_]{15,}/g,/sbp_[A-Za-z0-9]{20,}/g,/-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/g];
let failures=0;
for(const file of files){const s=fs.readFileSync(path.join(root,file),'utf8');for(const p of patterns){p.lastIndex=0;if(p.test(s)){console.error('Potential private credential in '+file);failures++;}}
 for(const m of s.matchAll(/eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/g)){try{const claims=JSON.parse(Buffer.from(m[0].split('.')[1],'base64url').toString());if(claims.role==='service_role'){console.error('Privileged JWT in '+file);failures++;}}catch{}}
}
if(failures)process.exitCode=1;else console.log('No recognized private credentials in browser files.');
