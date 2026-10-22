'use strict';
const fs=require('fs'),crypto=require('crypto');const {createReplay}=require('./replay-host.cjs');
const endpoint='https://lskzilcqswzxpeyyfutn.supabase.co/functions/v1/ranked-api';
const manifest=JSON.parse(fs.readFileSync(__dirname+'/engines/manifest.json','utf8'));
const hash=s=>crypto.createHash('sha256').update(s).digest('hex');
function canonical(v){if(Array.isArray(v))return '['+v.map(canonical).join(',')+']';if(v&&typeof v==='object')return '{'+Object.keys(v).sort().map(k=>JSON.stringify(k)+':'+canonical(v[k])).join(',')+'}';return JSON.stringify(v);}
function replayError(code){const e=Error(code);e.replayCode=code;throw e;}
function verifyReplay(job,html){let host;try{
 if(job.build!==manifest.build||hash(html)!==manifest.sha256)throw Error('engine_unavailable');
 host=createReplay(html,job.meta);let frames=0,inputs=0;const evidence=crypto.createHash('sha256');
 for(let i=0;i<job.batches.length;i++){
  const b=job.batches[i];if(b.sequence!==i+1||hash(canonical(b.events))!==b.digest)replayError('input_integrity');evidence.update(b.digest);
  for(const e of b.events){if(++inputs>500000)replayError('input_limit');if(e.t==='f'){frames+=e.n;if(frames>1000000||frames/30*1000>job.wall_ms+15000)replayError('input_limit');}
   try{host.apply(e);}catch(error){if(/control|Control|Entrada|Evento|Tecla|Puntero|Pantalla|Geometr|Joystick|Pasos/.test(error.message))replayError('replay_control');if(/posteriores al final/.test(error.message))replayError('replay_end');throw error;}
  }
 }
 const result=host.engine.result();if(!result.valid)replayError('rules_changed');if(!result.finished||result.elapsed_ms<=0||result.difficulty!==job.meta.difficulty||result.mode!==job.meta.mode)replayError('replay_end');
 return {ok:true,elapsed_ms:result.elapsed_ms,cleared_battalions:result.cleared_battalions,digest:evidence.digest('hex')};
 }catch(e){return{ok:false,code:e.replayCode||(/Configuración/.test(e.message)?'rules_changed':'service_retry')};}finally{host?.close();}}
async function run(){
 const oidcUrl=new URL(process.env.ACTIONS_ID_TOKEN_REQUEST_URL);oidcUrl.searchParams.set('audience','umbralia-ranked-verifier');
 async function identity(){const resp=await fetch(oidcUrl,{headers:{Authorization:'Bearer '+process.env.ACTIONS_ID_TOKEN_REQUEST_TOKEN}});if(!resp.ok)throw Error('OIDC unavailable');const token=(await resp.json()).value;if(typeof token!=='string')throw Error('OIDC missing');console.log('::add-mask::'+token);return token;}
 async function api(body){const token=await identity();const r=await fetch(endpoint,{method:'POST',headers:{Authorization:'Bearer '+token,'Content-Type':'application/json'},body:JSON.stringify(body)});if(!r.ok)throw Error('Verifier service rejected request');return r.json();}
 for(let jobs=0;jobs<4;jobs++){
  const job=await api({action:'claim'});if(!job){console.log('Queue empty.');return;}
  let result;try{result=verifyReplay(job,fs.readFileSync(__dirname+'/engines/v87.html','utf8'));}catch{result={ok:false,code:'service_retry'};}
  await api({action:'verdict',id:job.id,lease:job.lease,...result});console.log(result.ok?'Replay verified.':'Replay result: '+result.code);
 }
}
if(require.main===module)run().catch(()=>{console.error('Verifier unavailable; queue remains retryable.');process.exitCode=1;});
module.exports={hash,canonical,verifyReplay};
