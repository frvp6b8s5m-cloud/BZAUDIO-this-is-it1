'use strict';
document.documentElement.classList.add('js');

const menuButton = document.querySelector('.menu-toggle');
const navigation = document.querySelector('#primary-navigation');

if (menuButton && navigation) {
  menuButton.addEventListener('click', () => {
    const isOpen = menuButton.getAttribute('aria-expanded') === 'true';
    menuButton.setAttribute('aria-expanded', String(!isOpen));
    navigation.classList.toggle('is-open', !isOpen);
  });

  navigation.addEventListener('click', (event) => {
    if (event.target.closest('a')) {
      menuButton.setAttribute('aria-expanded', 'false');
      navigation.classList.remove('is-open');
    }
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && menuButton.getAttribute('aria-expanded') === 'true') {
      menuButton.setAttribute('aria-expanded', 'false');
      navigation.classList.remove('is-open');
      menuButton.focus();
    }
  });
}

const year = document.querySelector('#year');
if (year) year.textContent = String(new Date().getFullYear());

const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
const revealItems = document.querySelectorAll('[data-reveal]');

if (!reduceMotion && 'IntersectionObserver' in window) {
  const revealObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -36px 0px' });

  revealItems.forEach((item) => revealObserver.observe(item));
} else {
  revealItems.forEach((item) => item.classList.add('is-visible'));
}
const requestForm=document.querySelector('#equipment-request-form');
if(requestForm){
 const list=document.querySelector('#request-items'),add=document.querySelector('#add-request-item'),status=document.querySelector('#request-status'),limit=8;
 const refresh=()=>{const rows=[...list.querySelectorAll('[data-request-item]')];rows.forEach((row,i)=>{const b=row.querySelector('.request-remove');b.disabled=rows.length===1;b.setAttribute('aria-label','Remove item '+(i+1));});add.disabled=rows.length>=limit;add.textContent=add.disabled?'MAXIMUM 8 ITEMS':'+ ADD ANOTHER ITEM';};
 const addRow=()=>{if(list.querySelectorAll('[data-request-item]').length>=limit)return;const row=document.createElement('div');row.className='request-item';row.dataset.requestItem='';row.innerHTML='<label>Manufacturer<select name="manufacturer[]" required><option value="">Choose one</option><option>Allen &amp; Heath</option><option>Yamaha</option><option>Shure</option><option>Other / Not sure</option></select></label><label>Product or model<input name="product[]" required maxlength="140" placeholder="Product name or model"></label><label>Qty<input name="quantity[]" type="number" min="1" max="99" value="1" required></label><button class="request-remove" type="button">REMOVE</button>';list.append(row);refresh();row.querySelector('select').focus();};
 add.addEventListener('click',addRow);list.addEventListener('click',e=>{const b=e.target.closest('.request-remove');if(b&&!b.disabled){b.closest('[data-request-item]').remove();refresh();}});
 const categories={'mixing-consoles':'Mixing consoles','speakers-subwoofers':'Speakers and subwoofers',microphones:'Microphones','wireless-systems':'Wireless systems',headphones:'Headphones','processors-effects':'Processors and effects',amplifiers:'Amplifiers','cables-accessories':'Cables and accessories'};
 const category=categories[new URLSearchParams(window.location.search).get('category')];if(category){const first=list.querySelector('[data-request-item]');first.querySelector('select').value='Other / Not sure';first.querySelector('input[name="product[]"]').value=category+' — ';}
 requestForm.addEventListener('submit',e=>{e.preventDefault();if(!requestForm.reportValidity())return;const d=new FormData(requestForm),makers=d.getAll('manufacturer[]'),products=d.getAll('product[]'),qty=d.getAll('quantity[]');const lines=products.map((v,i)=>(i+1)+'. '+makers[i]+' — '+v+' (Qty: '+qty[i]+')');const body=['BZaudio equipment request','','Name: '+d.get('customer-name'),'Email: '+d.get('customer-email'),'','Requested equipment:',...lines,'','Additional details:',d.get('notes')||'None provided','','Please confirm current availability, pricing, and next steps.'].join('\n');status.textContent='Your email app should open with the request. Review it and press Send to contact BZaudio.';window.location.href='mailto:benrz101@gmail.com?subject='+encodeURIComponent('BZaudio equipment request')+'&body='+encodeURIComponent(body);});
 refresh();
}
