'use strict';
const fs=require('fs'),crypto=require('crypto');const {createReplay}=require('./replay-host.cjs');
const endpoint='https://lskzilcqswzxpeyyfutn.supabase.co/functions/v1/ranked-api';
const manifest=JSON.parse(fs.readFileSync(__dirname+'/engines/manifest.json','utf8'));
const hash=s=>crypto.createHash('sha256').update(s).digest('hex');
function canonical(v){if(Array.isArray(v))return '['+v.map(canonical).join(',')+']';if(v&&typeof v==='object')return '{'+Object.keys(v).sort().map(k=>JSON.stringify(k)+':'+canonical(v[k])).join(',')+'}';return JSON.stringify(v);}
async function run(){
 const oidcUrl=new URL(process.env.ACTIONS_ID_TOKEN_REQUEST_URL);oidcUrl.searchParams.set('audience','umbralia-ranked-verifier');
 async function identity(){const resp=await fetch(oidcUrl,{headers:{Authorization:'Bearer '+process.env.ACTIONS_ID_TOKEN_REQUEST_TOKEN}});if(!resp.ok)throw Error('OIDC unavailable');const token=(await resp.json()).value;if(typeof token!=='string')throw Error('OIDC missing');console.log('::add-mask::'+token);return token;}
 async function api(body){const token=await identity();const r=await fetch(endpoint,{method:'POST',headers:{Authorization:'Bearer '+token,'Content-Type':'application/json'},body:JSON.stringify(body)});if(!r.ok)throw Error('Verifier service rejected request');return r.json();}
 for(let jobs=0;jobs<4;jobs++){
  const job=await api({action:'claim'});if(!job){console.log('Queue empty.');return;}let ok=false,result={},digest='';let host;
  try{
   if(job.build!==manifest.build)throw Error('Unsupported engine');const html=fs.readFileSync(__dirname+'/engines/v87.html','utf8');if(hash(html)!==manifest.sha256)throw Error('Engine hash mismatch');
   host=createReplay(html,job.meta);let frames=0,inputs=0;const evidence=crypto.createHash('sha256');
   for(let i=0;i<job.batches.length;i++){
    const b=job.batches[i],raw=canonical(b.events);if(b.sequence!==i+1||hash(raw)!==b.digest)throw Error('Input digest mismatch');evidence.update(b.digest);
    for(const e of b.events){if(++inputs>500000)throw Error('Input limit');if(e.t==='f'){frames+=e.n;if(frames>1000000||frames/30*1000>job.wall_ms+15000)throw Error('Replay duration limit');}host.apply(e);}
   }
   result=host.engine.result();ok=result.valid&&result.finished&&result.elapsed_ms>0&&result.difficulty===job.meta.difficulty&&result.mode===job.meta.mode;
   digest=evidence.digest('hex');
  }catch{console.log('Replay rejected.');}finally{host?.close();}
  await api({action:'verdict',id:job.id,lease:job.lease,ok,elapsed_ms:ok?result.elapsed_ms:null,cleared_battalions:ok?result.cleared_battalions:null,digest});console.log(ok?'Replay verified.':'Invalid replay discarded.');
 }
}
if(require.main===module)run().catch(()=>{console.error('Verifier failed; queue remains retryable.');process.exitCode=1;});
module.exports={hash};
