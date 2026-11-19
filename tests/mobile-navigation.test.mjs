import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { runInNewContext } from 'node:vm';
import test from 'node:test';

const script = readFileSync(new URL('../script.js', import.meta.url), 'utf8');

function createHarness() {
  const documentEvents = new Map();
  const navigationEvents = new Map();
  const buttonEvents = new Map();
  const classes = new Set();
  const attributes = new Map([['aria-expanded', 'false']]);
  let focusCount = 0;

  const menuButton = {
    addEventListener: (name, callback) => buttonEvents.set(name, callback),
    getAttribute: (name) => attributes.get(name),
    setAttribute: (name, value) => attributes.set(name, value),
    focus: () => { focusCount += 1; },
  };
  const navigation = {
    addEventListener: (name, callback) => navigationEvents.set(name, callback),
    classList: {
      toggle: (name, force) => force ? classes.add(name) : classes.delete(name),
      remove: (name) => classes.delete(name),
    },
  };
  const year = { textContent: '' };
  const document = {
    documentElement: { classList: { add: () => {} } },
    querySelector: (selector) => ({
      '.menu-toggle': menuButton,
      '#primary-navigation': navigation,
      '#year': year,
    })[selector] ?? null,
    querySelectorAll: () => [],
    addEventListener: (name, callback) => documentEvents.set(name, callback),
  };
  const window = { matchMedia: () => ({ matches: true }) };

  runInNewContext(script, { document, window });
  return { attributes, buttonEvents, classes, documentEvents, focusCount: () => focusCount, navigationEvents };
}

test('mobile menu opens and closes when a navigation link is selected', () => {
  const harness = createHarness();
  harness.buttonEvents.get('click')();
  assert.equal(harness.attributes.get('aria-expanded'), 'true');
  assert.equal(harness.classes.has('is-open'), true);

  harness.navigationEvents.get('click')({ target: { closest: () => ({}) } });
  assert.equal(harness.attributes.get('aria-expanded'), 'false');
  assert.equal(harness.classes.has('is-open'), false);
});

test('Escape closes the mobile menu and returns focus to the menu button', () => {
  const harness = createHarness();
  harness.buttonEvents.get('click')();
  harness.documentEvents.get('keydown')({ key: 'Escape' });

  assert.equal(harness.attributes.get('aria-expanded'), 'false');
  assert.equal(harness.classes.has('is-open'), false);
  assert.equal(harness.focusCount(), 1);
});
