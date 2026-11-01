/**
 * OTP 2025 - Enterprise UI Standards Core Library
 * 
 * Implements:
 * 1. Thai Buddhist Era Datepicker (พ.ศ. display, ค.ศ. ISO storage)
 * 2. Unified Notification Engine (SweetAlert2 Modals & Toasts)
 * 3. Server-Side Ajax DataTable Initializer with Thai Pagination
 * 4. Client-side Form Validation with Single-Error Filter & Auto-scroll
 * 
 * Standards Reference: docs/UI_FORM_TABLE_STANDARDS.md
 * ADR Reference: docs/adr/ADR-005-ui-form-table-validation-error-standards.md
 * Error Mapping: docs/ERROR_CODE_MAPPING.md
 */

(function (window, $) {
    'use strict';

    // =========================================================================
    // 1. Thai Datepicker & Calendar Transformer (พ.ศ. <-> ค.ศ.)
    // =========================================================================
    const ThaiDateHelper = {
        toBuddhistDisplay: function (gregorianDateStr) {
            if (!gregorianDateStr) return '';
            const parts = gregorianDateStr.split('-');
            if (parts.length !== 3) return gregorianDateStr;
            const year = parseInt(parts[0], 10) + 543;
            const month = parts[1];
            const day = parts[2];
            return `${day}/${month}/${year}`;
        },

        toGregorianDb: function (buddhistDateStr) {
            if (!buddhistDateStr) return '';
            const parts = buddhistDateStr.split('/');
            if (parts.length !== 3) return buddhistDateStr;
            const day = parts[0];
            const month = parts[1];
            const year = parseInt(parts[2], 10) - 543;
            return `${year}-${month}-${day}`;
        },

        init: function () {
            if (!$.fn.datepicker) return;

            $('.datepicker-thai').each(function () {
                const $displayInput = $(this);
                const $hiddenInput = $displayInput.siblings('input[type="hidden"]');

                if ($hiddenInput.length && $hiddenInput.val()) {
                    $displayInput.val(ThaiDateHelper.toBuddhistDisplay($hiddenInput.val()));
                }

                $displayInput.datepicker({
                    language: 'th-th',
                    format: 'dd/mm/yyyy',
                    autoclose: true,
                    todayHighlight: true,
                    clearBtn: true
                }).on('changeDate', function (e) {
                    if (e.date) {
                        const d = ('0' + e.date.getDate()).slice(-2);
                        const m = ('0' + (e.date.getMonth() + 1)).slice(-2);
                        const y = e.date.getFullYear();
                        if ($hiddenInput.length) {
                            $hiddenInput.val(`${y}-${m}-${d}`);
                        }
                    } else if ($hiddenInput.length) {
                        $hiddenInput.val('');
                    }
                }).on('clearDate', function () {
                    if ($hiddenInput.length) {
                        $hiddenInput.val('');
                    }
                });
            });
        }
    };

    // =========================================================================
    // 2. Unified Notification Engine (SweetAlert2 Modals & Toasts)
    // =========================================================================
    const AppNotification = {
        confirm: function (title, text, confirmButtonText, callback) {
            if (typeof confirmButtonText === 'function') {
                callback = confirmButtonText;
                confirmButtonText = 'ยืนยันดำเนินการ';
            }
            if (typeof Swal === 'undefined') {
                if (window.confirm(title + '\n' + text)) {
                    if (callback) callback();
                }
                return;
            }

            Swal.fire({
                title: title,
                text: text,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#16a34a',
                cancelButtonColor: '#64748b',
                confirmButtonText: `<i class="fas fa-check me-1"></i> ${confirmButtonText || 'ยืนยันดำเนินการ'}`,
                cancelButtonText: '<i class="fas fa-times me-1"></i> ยกเลิก',
                reverseButtons: true,
                focusCancel: true
            }).then(function (result) {
                if (result.isConfirmed && typeof callback === 'function') {
                    callback();
                }
            });
        },

        success: function (title, text, callback) {
            if (typeof Swal === 'undefined') {
                alert(title);
                if (callback) callback();
                return;
            }

            Swal.fire({
                title: `<span class="text-success fw-bold">${title}</span>`,
                text: text || '',
                icon: 'success',
                confirmButtonColor: '#16a34a',
                confirmButtonText: 'ตกลง'
            }).then(function () {
                if (typeof callback === 'function') callback();
            });
        },

        error: function (errorCode, friendlyMessage) {
            if (typeof Swal === 'undefined') {
                alert(`[${errorCode}] ${friendlyMessage}`);
                return;
            }

            Swal.fire({
                title: '<span class="text-danger fw-bold">เกิดข้อผิดพลาดในการทำรายการ</span>',
                html: `
                    <div class="p-2 text-start">
                        <p class="fs-5 text-dark mb-2">${friendlyMessage}</p>
                        <div class="alert alert-light border text-muted small p-2 mb-0">
                            <i class="fas fa-info-circle me-1"></i> รหัสอ้างอิง: <strong>[${errorCode}]</strong>
                        </div>
                    </div>
                `,
                icon: 'error',
                confirmButtonColor: '#dc2626',
                confirmButtonText: 'ปิดหน้าต่าง'
            });
        },

        toast: function (type, message) {
            if (typeof Swal === 'undefined') return;

            const Toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3500,
                timerProgressBar: true
            });
            Toast.fire({
                icon: type || 'info',
                title: `<span class="fw-bold fs-6">${message}</span>`
            });
        },

        handleAjaxError: function (xhr) {
            let errorCode = 'ERR-SYS-001';
            let friendlyMsg = 'ระบบไม่สามารถเชื่อมต่อได้ในขณะนี้ กรุณาลองใหม่อีกครั้ง';

            if (xhr.status === 422) {
                errorCode = 'ERR-VAL-001';
                const errors = xhr.responseJSON?.errors;
                if (errors && Object.keys(errors).length > 0) {
                    // Single-Error Filter: ดึงเฉพาะ Error แรกสุดเสมอ
                    const firstKey = Object.keys(errors)[0];
                    friendlyMsg = errors[firstKey][0];
                } else {
                    friendlyMsg = xhr.responseJSON?.message || 'ข้อมูลที่กรอกไม่ถูกต้องครบถ้วน';
                }
            } else if (xhr.status === 403) {
                errorCode = 'ERR-AUTH-003';
                friendlyMsg = 'ท่านไม่มีสิทธิ์ในการดำเนินการหรือเข้าถึงข้อมูลนี้';
            } else if (xhr.status === 404) {
                errorCode = 'ERR-DATA-002';
                friendlyMsg = 'ไม่พบข้อมูลที่ท่านต้องการในระบบ';
            } else if (xhr.status === 500) {
                errorCode = 'ERR-SYS-002';
                friendlyMsg = 'ระบบเกิดข้อผิดพลาดในการประมวลผล ข้อมูลเหตุการณ์ถูกบันทึกเรียบร้อยแล้ว';
            }

            AppNotification.error(errorCode, friendlyMsg);
        }
    };

    // =========================================================================
    // 3. Server-Side Ajax DataTable Initializer
    // =========================================================================
    function initServerSideDataTable(tableSelector, ajaxUrl, columnsConfig, extraFilterParams) {
        if (!$.fn.DataTable) {
            console.error('DataTables plugin is not loaded');
            return null;
        }

        return $(tableSelector).DataTable({
            serverSide: true,
            processing: true,
            responsive: true,
            ajax: {
                url: ajaxUrl,
                type: 'GET',
                data: function (d) {
                    if (typeof extraFilterParams === 'function') {
                        Object.assign(d, extraFilterParams());
                    } else if (extraFilterParams) {
                        Object.assign(d, extraFilterParams);
                    }
                },
                error: function (xhr) {
                    AppNotification.handleAjaxError(xhr);
                }
            },
            columns: columnsConfig,
            order: [[0, 'desc']],
            pageLength: 10,
            lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            language: {
                processing: '<div class="d-flex align-items-center justify-content-center p-3"><div class="spinner-border text-primary me-2" role="status"></div><span class="fs-5 fw-bold text-dark">กำลังโหลดข้อมูล...</span></div>',
                lengthMenu: 'แสดง _MENU_ รายการต่อหน้า',
                zeroRecords: '<div class="text-center py-5"><i class="fas fa-search fa-3x text-muted mb-3"></i><p class="fs-5 text-secondary">ไม่พบข้อมูลที่ตรงกับเงื่อนไขการค้นหา</p></div>',
                info: 'แสดงรายการที่ <strong>_START_</strong> ถึง <strong>_END_</strong> จากทั้งหมด <strong>_TOTAL_</strong> รายการ',
                infoEmpty: 'ไม่มีรายการข้อมูลสำหรับแสดงผล',
                infoFiltered: '(กรองจากข้อมูลทั้งหมด _MAX_ รายการ)',
                paginate: {
                    first: '<i class="fas fa-angle-double-left"></i> หน้าแรก',
                    last: 'หน้าสุดท้าย <i class="fas fa-angle-double-right"></i>',
                    next: 'ถัดไป <i class="fas fa-angle-right"></i>',
                    previous: '<i class="fas fa-angle-left"></i> ก่อนหน้า'
                }
            },
            drawCallback: function () {
                $('.paginate_button').addClass('btn btn-sm btn-outline-secondary mx-1');
                $('.paginate_button.current').addClass('btn-primary text-white border-primary').removeClass('btn-outline-secondary');
            }
        });
    }

    // =========================================================================
    // 4. Form Validation with Single-Error Filter
    // =========================================================================
    function initFormValidation(formSelector, rulesConfig, messagesConfig, submitHandlerFn) {
        const $form = $(formSelector);
        $form.attr('novalidate', 'novalidate');

        if (!$.fn.validate) {
            console.error('jQuery Validation plugin is not loaded');
            $form.on('submit', function (e) {
                if (submitHandlerFn) {
                    e.preventDefault();
                    submitHandlerFn(this);
                }
            });
            return null;
        }

        return $form.validate({
            rules: rulesConfig,
            messages: messagesConfig,
            errorElement: 'div',
            errorClass: 'invalid-feedback fs-6',
            showErrors: function (errorMap, errorList) {
                $form.find('.is-invalid').removeClass('is-invalid');
                $form.find('.invalid-feedback').text('').hide();

                if (errorList.length > 0) {
                    // Single-Error Filter: แสดงเฉพาะ Error แรกสุด
                    const firstError = errorList[0];
                    const $element = $(firstError.element);

                    $element.addClass('is-invalid');
                    let $feedback = $element.siblings('.invalid-feedback');
                    if (!$feedback.length) {
                        $feedback = $element.parent().find('.invalid-feedback');
                    }
                    $feedback.text(firstError.message).show();

                    $('html, body').animate({
                        scrollTop: $element.offset().top - 120
                    }, 300);
                    $element.focus();

                    AppNotification.toast('warning', firstError.message);
                }
            },
            highlight: function (element) {
                $(element).addClass('is-invalid');
            },
            unhighlight: function (element) {
                $(element).removeClass('is-invalid');
                $(element).siblings('.invalid-feedback').text('').hide();
            },
            submitHandler: function (form) {
                if (submitHandlerFn) {
                    submitHandlerFn(form);
                } else {
                    form.submit();
                }
            }
        });
    }

    // Expose globals
    window.ThaiDateHelper = ThaiDateHelper;
    window.AppNotification = AppNotification;
    window.initServerSideDataTable = initServerSideDataTable;
    window.initFormValidation = initFormValidation;

    $(document).ready(function () {
        ThaiDateHelper.init();
    });

})(window, jQuery);
