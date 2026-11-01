/**
 * OTP 2025 - Senior-Friendly Form Validator & Thai Buddhist Era Date Sync
 * Adheres to ADR 0003 and ADR 0005 standards.
 */

(function (window, document) {
    'use strict';

    const SeniorFormValidator = {
        /**
         * Initialize validation and Thai datepicker bindings across the document.
         */
        init() {
            this.bindThaiDatepickers();
            this.bindForms();
        },

        /**
         * Bind automatic sync between Thai Buddhist Era date input (พ.ศ.) and ISO hidden input (ค.ศ.)
         */
        bindThaiDatepickers() {
            const thaiInputs = document.querySelectorAll('input[data-thai-datepicker]');
            thaiInputs.forEach(input => {
                input.addEventListener('input', () => this.syncThaiToIso(input));
                input.addEventListener('change', () => this.syncThaiToIso(input));
                input.addEventListener('blur', () => this.formatAndValidateThaiDate(input));
                
                // Initial sync if value exists
                if (input.value) {
                    this.syncThaiToIso(input);
                }
            });
        },

        /**
         * Converts DD/MM/YYYY (พ.ศ.) to YYYY-MM-DD (ค.ศ. ISO-8601) and saves into the target hidden input.
         * @param {HTMLInputElement} input 
         */
        syncThaiToIso(input) {
            const targetSelector = input.getAttribute('data-target-hidden');
            if (!targetSelector) return;

            const hiddenInput = document.querySelector(targetSelector);
            if (!hiddenInput) return;

            const val = input.value.trim();
            // Match DD/MM/YYYY or D/M/YYYY
            const match = val.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
            if (match) {
                const day = match[1].padStart(2, '0');
                const month = match[2].padStart(2, '0');
                const thaiYear = parseInt(match[3], 10);
                
                // Thai Buddhist Era offset: 543
                const ceYear = thaiYear > 2400 ? thaiYear - 543 : thaiYear;
                hiddenInput.value = `${ceYear}-${month}-${day}`;
            } else if (!val) {
                hiddenInput.value = '';
            }
        },

        /**
         * Formats and validates Thai date string on blur.
         * @param {HTMLInputElement} input 
         */
        formatAndValidateThaiDate(input) {
            const val = input.value.trim();
            if (!val) return;

            const match = val.match(/^(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{4})$/);
            if (match) {
                const day = match[1].padStart(2, '0');
                const month = match[2].padStart(2, '0');
                let year = parseInt(match[3], 10);
                
                // Auto-correct 2-digit or western year if entered by mistake
                if (year < 2400 && year > 1900) {
                    year += 543;
                }
                
                input.value = `${day}/${month}/${year}`;
                this.syncThaiToIso(input);
            }
        },

        /**
         * Attach submission handlers to forms with novalidate attribute.
         */
        bindForms() {
            const forms = document.querySelectorAll('form[novalidate]');
            forms.forEach(form => {
                form.addEventListener('submit', (e) => this.handleFormSubmit(e, form));
            });
        },

        /**
         * Handles form validation with Single-Error Focus Banner (ADR 0005).
         * @param {Event} event 
         * @param {HTMLFormElement} form 
         */
        handleFormSubmit(event, form) {
            // Find all form controls that are invalid
            const invalidElements = form.querySelectorAll(':invalid');

            // Reset previous invalid states
            form.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

            if (invalidElements.length > 0) {
                event.preventDefault();
                event.stopPropagation();

                // ADR 0005: Focus on FIRST error only
                const firstInvalid = invalidElements[0];
                firstInvalid.classList.add('is-invalid');

                // Generate polite Thai error message
                const fieldLabel = this.getFieldLabel(firstInvalid);
                let message = `กรุณากรอกข้อมูล "${fieldLabel}" ให้ถูกต้อง`;

                if (firstInvalid.validity.valueMissing) {
                    message = `กรุณากรอกข้อมูลในช่อง "${fieldLabel}" (จำเป็นต้องระบุ)`;
                } else if (firstInvalid.validity.typeMismatch) {
                    message = `รูปแบบข้อมูลในช่อง "${fieldLabel}" ไม่ถูกต้อง`;
                } else if (firstInvalid.validity.tooShort) {
                    message = `ข้อมูลในช่อง "${fieldLabel}" สั้นเกินไป (ต้องการอย่างน้อย ${firstInvalid.minLength} ตัวอักษร)`;
                }

                // Show in error banner if present, otherwise alert
                const banner = form.querySelector('.senior-error-banner') || document.querySelector('.senior-error-banner');
                if (banner) {
                    const msgEl = banner.querySelector('.banner-message');
                    if (msgEl) msgEl.innerText = message;
                    banner.style.display = 'flex';
                    banner.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }

                // Smooth scroll & focus to the first invalid field
                firstInvalid.focus({ preventScroll: false });
                firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        },

        /**
         * Resolves the human-readable label for a form input element.
         * @param {HTMLElement} element 
         * @returns {string}
         */
        getFieldLabel(element) {
            const id = element.id;
            if (id) {
                // Check direct label for attribute
                const label = document.querySelector(`label[for="${id}"]`) || document.querySelector(`label[for="${id.replace('_thai', '')}"]`);
                if (label) {
                    return label.innerText.replace('*', '').trim();
                }
            }

            const parentGroup = element.closest('.senior-form-group, .mb-3, .form-group');
            if (parentGroup) {
                const label = parentGroup.querySelector('label');
                if (label) {
                    return label.innerText.replace('*', '').trim();
                }
            }

            return element.getAttribute('placeholder') || element.getAttribute('name') || 'ข้อมูล';
        }
    };

    // Auto-init on DOMContentLoaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => SeniorFormValidator.init());
    } else {
        SeniorFormValidator.init();
    }

    window.SeniorFormValidator = SeniorFormValidator;

})(window, document);
