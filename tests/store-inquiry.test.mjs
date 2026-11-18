import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { runInNewContext } from 'node:vm';
import test from 'node:test';

const script = readFileSync(new URL('../store.js', import.meta.url), 'utf8');

function harness() {
  const listeners = {};
  const fields = {
    name: { value: 'Alex Example', focus() {} },
    email: { value: 'alex@example.com' },
    items: { value: 'Shure — SM7B — quantity 2\nAllen & Heath — SQ-6 — quantity 1' },
    notes: { value: 'For a studio' },
  };
  const form = {
    addEventListener: (name, fn) => { listeners[`form:${name}`] = fn; },
    querySelector: (selector) => fields[selector.match(/name="([^"]+)"/)[1]],
    reportValidity: () => true,
  };
  const result = { hidden: true, scrollIntoView() {} };
  const emailLink = { href: '', focus() {} };
  const editButton = { addEventListener: (name, fn) => { listeners[`edit:${name}`] = fn; } };
  const document = {
    querySelector: (selector) => ({
      '#equipment-inquiry-form': form,
      '#inquiry-result': result,
      '#email-draft-link': emailLink,
      '#edit-inquiry': editButton,
    })[selector] ?? null,
  };
  runInNewContext(script, { document, encodeURIComponent });
  return { listeners, fields, result, emailLink };
}

test('valid equipment request creates a reviewable email draft without sending it', () => {
  const h = harness();
  let prevented = false;
  h.listeners['form:submit']({ preventDefault: () => { prevented = true; } });
  assert.equal(prevented, true);
  assert.equal(h.result.hidden, false);
  assert.match(h.emailLink.href, /^mailto:benrz101@gmail\.com\?/);
  assert.match(decodeURIComponent(h.emailLink.href), /Shure — SM7B — quantity 2/);
  assert.match(decodeURIComponent(h.emailLink.href), /Allen & Heath — SQ-6 — quantity 1/);
  assert.match(decodeURIComponent(h.emailLink.href), /not an order or payment authorization/);
});

test('edit action hides the prepared state and returns focus to the name field', () => {
  const h = harness();
  h.result.hidden = false;
  let focused = false;
  h.fields.name.focus = () => { focused = true; };
  h.listeners['edit:click']();
  assert.equal(h.result.hidden, true);
  assert.equal(focused, true);
});
