// Scoped to the game IIFE. Auth and network clients keep the real browser clock.
const clock87={active:false,replay:false,now:0,seed:1,visual:false,visualSeed:912387,acc:0,ticks:0,elapsed:0,timers:new Map(),nextTimer:1,mode:null,meta:null,events:[],ended:false,invalid:null};
const Math=Object.create(window.Math);Math.random=function(){if(!clock87.active)return window.Math.random();const k=clock87.visual?'visualSeed':'seed';let n=clock87[k]|0;n^=n<<13;n^=n>>>17;n^=n<<5;clock87[k]=n>>>0;return (n>>>0)/4294967296;};
const performance={now:()=>clock87.active?clock87.now:window.performance.now()};
const Date=class extends window.Date{constructor(...args){super(...(args.length?args:[Date.now()]));}static now(){return clock87.active?(clock87.meta.epoch+clock87.now):window.Date.now();}};
const setTimeout=(fn,ms,...args)=>{if(!clock87.active)return window.setTimeout(fn,ms,...args);const id=clock87.nextTimer++;clock87.timers.set(id,{at:clock87.now+Math.max(0,Number(ms)||0),fn,args});return id;};
const clearTimeout=id=>{if(clock87.active)clock87.timers.delete(id);else window.clearTimeout(id);};

// Normalize transcendental results across Chromium and the Node verifier.
for(const name of ["sin","cos","tan","atan2","atan","acos","asin","sqrt","hypot","pow","exp","log","log2","log10","cbrt"]){Math[name]=(...args)=>{const value=window.Math[name](...args);return clock87.active&&Number.isFinite(value)?window.Math.round(value*1e10)/1e10:value;};}
for(const kind of ['click','input','change','keydown','keyup','pointerdown','pointermove','pointerup','pointercancel','lostpointercapture'])window.addEventListener(kind,recordInput87,{capture:true});

window.addEventListener('blur',()=>{if(clock87.active&&!clock87.replay&&!clock87.ended)append87({t:'blur'});},{capture:true});
document.addEventListener('visibilitychange',()=>{if(document.hidden&&clock87.active&&!clock87.replay&&!clock87.ended)append87({t:'blur'});},{capture:true});
