import {createClient} from 'npm:@supabase/supabase-js@2.118.0';
import {createRemoteJWKSet,jwtVerify} from 'npm:jose@6.1.0';
function canonical(v:any):string{if(Array.isArray(v))return '['+v.map(canonical).join(',')+']';if(v&&typeof v==='object')return '{'+Object.keys(v).sort().map(k=>JSON.stringify(k)+':'+canonical(v[k])).join(',')+'}';return JSON.stringify(v);}
const jwks=createRemoteJWKSet(new URL('https://token.actions.githubusercontent.com/.well-known/jwks'));
const origins=new Set(['https://neliux.github.io']);
const headers=(origin:string)=>({'Content-Type':'application/json','Cache-Control':'no-store','Access-Control-Allow-Origin':origins.has(origin)?origin:'https://neliux.github.io','Access-Control-Allow-Headers':'authorization,apikey,content-type','Access-Control-Allow-Methods':'POST,OPTIONS','Vary':'Origin'});
Deno.serve(async req=>{
 const origin=req.headers.get('origin')||'',h=headers(origin);
 if(req.method==='OPTIONS')return new Response(null,{status:204,headers:h});
 if(req.method!=='POST'||(origin&&!origins.has(origin)))return new Response('{}',{status:403,headers:h});
 try{
  const text=await req.text();if(text.length>64000)throw Error('size');const body=JSON.parse(text);
  const auth=req.headers.get('authorization')||'';if(!auth.startsWith('Bearer ')||auth.length>16000)throw Error('auth');
  const token=auth.slice(7),action=body.action;
  const db=createClient(Deno.env.get('SUPABASE_URL')!,Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,{auth:{persistSession:false,autoRefreshToken:false}});
  let user:string|null=null;
  if(action==='claim'||action==='verdict'){
   const {payload:p}=await jwtVerify(token,jwks,{issuer:'https://token.actions.githubusercontent.com',audience:'umbralia-ranked-verifier',algorithms:['RS256'],maxTokenAge:'10m'});
   if(p.repository_id!=='1427136886'||p.repository!=='Neliux/Umbralia'||p.ref!=='refs/heads/main'||p.workflow_ref!=='Neliux/Umbralia/.github/workflows/ranked-verify.yml@refs/heads/main'||!['push','schedule','workflow_dispatch'].includes(String(p.event_name)))throw Error('worker');
   body.worker=String(p.run_id);
  }else{
   if(!['begin','append','finish','status','abandon'].includes(action))throw Error('action');
   const {data,error}=await db.auth.getUser(token);if(error||!data.user||!data.user.email_confirmed_at)throw Error('auth');user=data.user.id;
   if(action==='begin'){
    const m=body.meta;if(!m||!Number.isInteger(m.width)||!Number.isInteger(m.height)||m.width<240||m.height<240||m.width>4096||m.height>4096||typeof m.weapon!=='string'||m.weapon.length>40)throw Error('configuration');
    const settings:Record<string,boolean>={};for(const k of ['simpleGraphics57','autoCollect42','autoaim','touch','reducedMotion46'])if(typeof m.settings?.[k]==='boolean')settings[k]=m.settings[k];
    body.meta={width:m.width,height:m.height,weapon:m.weapon,settings,...(m.rules88===true?{rules88:true}:{}),...(m.rules89===true?{rules89:true}:{})};
   }
   if(action==='append'){
    if(!Array.isArray(body.events)||body.events.length>512)throw Error('events');
    body.digest=Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',new TextEncoder().encode(canonical(body.events))))).map(x=>x.toString(16).padStart(2,'0')).join('');
   }
  }
  const {data,error}=await db.rpc('ranked_backend87',{p_action:action,p_user:user,p_body:body});if(error)throw Error('request');
  return new Response(JSON.stringify(data),{headers:h});
 }catch{return new Response(JSON.stringify({error:'Solicitud no válida o sesión caducada. Vuelve a iniciar sesión o inténtalo más tarde.'}),{status:400,headers:h});}
});
