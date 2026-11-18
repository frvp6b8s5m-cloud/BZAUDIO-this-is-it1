'use strict';

(() => {
  const form = document.querySelector('#equipment-inquiry-form');
  const result = document.querySelector('#inquiry-result');
  const emailLink = document.querySelector('#email-draft-link');
  const editButton = document.querySelector('#edit-inquiry');

  if (!form || !result || !emailLink || !editButton) return;

  const field = (name) => form.querySelector(`[name="${name}"]`);

  form.addEventListener('submit', (event) => {
    event.preventDefault();
    if (!form.reportValidity()) return;

    const values = {
      name: field('name').value.trim(),
      email: field('email').value.trim(),
      manufacturer: field('manufacturer').value,
      model: field('model').value.trim(),
      quantity: field('quantity').value,
      notes: field('notes').value.trim() || 'Not provided',
    };

    const subject = 'BZaudio equipment inquiry';
    const body = [
      'BZaudio equipment inquiry',
      '',
      `Name: ${values.name}`,
      `Email: ${values.email}`,
      `Manufacturer: ${values.manufacturer}`,
      `Product / model: ${values.model}`,
      `Quantity requested: ${values.quantity}`,
      '',
      'Additional details:',
      values.notes,
      '',
      'This is an inquiry only, not an order or payment authorization.',
    ].join('\\n');

    emailLink.href = `mailto:benrz101@gmail.com?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
    result.hidden = false;
    result.scrollIntoView?.({ behavior: 'smooth', block: 'nearest' });
    emailLink.focus();
  });

  editButton.addEventListener('click', () => {
    result.hidden = true;
    field('name').focus();
  });
})();
