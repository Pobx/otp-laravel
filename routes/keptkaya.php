<?php

use App\Http\Controllers\EmissionFactorController;
use App\Http\Controllers\KeptKaya\AnnualBatchController;
use App\Http\Controllers\KeptKaya\AnnualReportController;
use App\Http\Controllers\KeptKaya\AnnualTrashController;
use App\Http\Controllers\KeptKaya\AnnualTrashPayratePerMonthController;
use App\Http\Controllers\KeptKaya\AnnualTrashSubscriptionController;
use App\Http\Controllers\KeptKaya\BarcodeController;
use App\Http\Controllers\KeptKaya\BinsController;
use App\Http\Controllers\KeptKaya\CartController;
use App\Http\Controllers\KeptKaya\DashboardController;
use App\Http\Controllers\KeptKaya\HistoryController;
use App\Http\Controllers\KeptKaya\ImpactController;
use App\Http\Controllers\KeptKaya\KorKor3ReportController;
use App\Http\Controllers\KeptKaya\KpPurchaseShopController;
use App\Http\Controllers\KeptKaya\KpRecycleClassifyController;
use App\Http\Controllers\KeptKaya\KpSettingController;
use App\Http\Controllers\KeptKaya\KpUserGroupController;
use App\Http\Controllers\KeptKaya\MemberShopController;
use App\Http\Controllers\KeptKaya\PointController;
use App\Http\Controllers\KeptKaya\RecycleBankController;
use App\Http\Controllers\KeptKaya\RecycleItemController;
use App\Http\Controllers\KeptKaya\RecycleItemGroupController;
use App\Http\Controllers\KeptKaya\RecyclePriceController;
use App\Http\Controllers\KeptKaya\RecyclePurchaseController;
use App\Http\Controllers\KeptKaya\RecycleSaleController;
use App\Http\Controllers\KeptKaya\RecycleUnitController;
use App\Http\Controllers\KeptKaya\RecycleWasteStaffController;
use App\Http\Controllers\KeptKaya\ShopProductController;
use App\Http\Controllers\KeptKaya\UserWasteController;
use App\Http\Controllers\KeptKaya\WithdrawBatchController;
use App\Http\Controllers\KeptKaya\WithdrawController;
use App\Http\Controllers\Kiosk\KioskController;
use App\Http\Controllers\Kiosk\KioskSensorController;
use Illuminate\Support\Facades\Route;

Route::prefix('keptkayas')->name('keptkayas.')->group(function () {
    Route::get('/unknown-review', function () {
        return view('keptkayas.unknown_review');
    })->name('kiosk.unknown.review');

    // System Settings
    Route::get('/settings', [KpSettingController::class, 'index'])->name('settings.index');
    Route::post('/settings', [KpSettingController::class, 'update'])->name('settings.update');

    Route::get('/history/{pref_id}', [HistoryController::class, 'index'])->name('history');
    Route::get('/impact/{pref_id}', [ImpactController::class, 'index'])->name('impact');
    Route::get('/withdraw/create/{user_id?}', [WithdrawController::class, 'create'])->name('withdraw.create');
    Route::post('/withdraw/store', [WithdrawController::class, 'storeRequest'])->name('withdraw.store');
    Route::get('/withdraw/success/{id}', [WithdrawController::class, 'showSuccess'])->name('withdraw.success');
    Route::get('/withdraw/{id}/print-slip', [WithdrawController::class, 'printSlip'])->name('withdraw.print_slip');

    Route::get('/batches/{show_div?}', [WithdrawBatchController::class, 'index'])->name('batches.index');
    Route::post('/batches/create', [WithdrawBatchController::class, 'createBatch'])->name('batches.create');
    Route::get('/batches/{id}', [WithdrawBatchController::class, 'show'])->name('batches.show');
    Route::get('/batches/{id}/print', [WithdrawBatchController::class, 'printReport'])->name('batches.print');
    Route::post('/batches/{id}/status', [WithdrawBatchController::class, 'updateStatus'])->name('batches.update_status');
    Route::get('/batches/{id}/print-view', [WithdrawBatchController::class, 'printReport'])->name('batches.print_view');
    Route::post('/batches/{id}/approve-step', [WithdrawBatchController::class, 'approveStep'])->name('batches.approve_step');

    Route::get('/transfer-points/{pref_id}', [PointController::class, 'create'])->name('transfer_points');
    Route::post('/transfer-points', [PointController::class, 'transfer'])->name('transfer_points.store');
});

Route::middleware(['auth'])->prefix('keptkayas')->name('keptkayas.')->group(function () {
    Route::get('/recycle-bank/members', [RecycleBankController::class, 'index'])->name('recycle-bank.members');
    Route::get('/recycle-bank/members/{id}/history', [RecycleBankController::class, 'history'])->name('recycle-bank.history');

    Route::resource('kiosks', KioskController::class)->except(['show']);
    Route::get('/kiosks/dashboard', [KioskController::class, 'mapDashboard'])->name('kiosks.dashboard');
    Route::get('/kiosks/noscreen/login', [KioskController::class, 'login'])->name('kiosks.noscreen.login');
    Route::post('/kiosks/noscreen/userMatchKiosk', [KioskController::class, 'userMatchKiosk']);
    // หน้า Monitor ควบคุมตู้
    Route::get('/kiosks/noscreen/monitor', [KioskController::class, 'monitor'])->name('kiosk.monitor');

    Route::get('/kiosks/sensors/alerts', [KioskSensorController::class, 'sensorAlerts'])->name('kiosks.sensors.alerts');
    Route::prefix('/kiosks/{kiosk_id}/sensors')->name('kiosks.sensors.')->group(function () {
        Route::get('/', [KioskSensorController::class, 'index'])->name('index');
        Route::post('/', [KioskSensorController::class, 'store'])->name('store');
        Route::put('/{id}', [KioskSensorController::class, 'update'])->name('update');
        Route::delete('/{id}', [KioskSensorController::class, 'destroy'])->name('destroy');
    });

    // Route สำหรับกด Disconnect
    Route::post('/kiosks/noscreen/disconnect', [KioskController::class, 'disconnect'])->name('kiosk.disconnect');
    Route::post('/kiosks/noscreen/save-transaction', [KioskController::class, 'storeTransaction']);

    Route::get('/korkor3', [KorKor3ReportController::class, 'index'])->name('korkor3.index');
    Route::get('/korkor3/export', [KorKor3ReportController::class, 'exportKorKor3'])->name('korkor3.export');
    Route::prefix('/reports')->name('reports.')->group(function () {
        Route::get('/', [AnnualReportController::class, 'index'])->name('index');
        Route::get('/generate', [AnnualReportController::class, 'generate'])->name('generate');
    });

    // 1. Dashboard (ย้ายเข้ามาใน Group ตัดคำว่า keptkayas/ ออก เพราะมี prefix แล้ว)
    // URL: /keptkayas/dashboard/{type} -> Name: keptkayas.dashboard
    Route::get('dashboard/{keptkayatype?}', [DashboardController::class, 'index'])->name('dashboard');

    // 2. Main Module Routes
    Route::get('recycle_classify/index', [KpRecycleClassifyController::class, 'index'])->name('recycle_classify');

    Route::get('scanner', function () {
        return view('keptkayas.barcode.scanner');
    });

    Route::resource('/purchase-shops', KpPurchaseShopController::class)->except(['show'])->parameters(['purchase-shops' => 'shop']); // middleware auth ซ้ำซ้อน ลบออกได้เพราะ Group มีแล้ว

    Route::post('barcode/search', [BarcodeController::class, 'search'])->name('barcode.search');
    Route::resource('shop-products', ShopProductController::class);

    // 3. Shop Routes
    Route::prefix('shop')->name('shop.')->group(function () {
        Route::get('/', [MemberShopController::class, 'index'])->name('index');
        Route::get('cart', [MemberShopController::class, 'showCart'])->name('cart');
        Route::get('order-history', [MemberShopController::class, 'orderHistory'])->name('order_history');
        // Actions
        Route::post('add-to-cart', [MemberShopController::class, 'addToCart'])->name('add_to_cart');
        Route::post('place-order', [MemberShopController::class, 'placeOrder'])->name('place_order');
        Route::delete('remove-from-cart/{productId}', [MemberShopController::class, 'removeFromCart'])->name('remove_from_cart');
    });

    // 4. Staff Routes
    Route::prefix('/staffs')->name('staffs.')->group(function () {
        Route::prefix('/mobile')->name('mobile.')->group(function () {
            Route::resource('/recycle', RecycleWasteStaffController::class)->except(['create', 'store', 'show', 'edit', 'update', 'destroy']);
        });
    });

    Route::prefix('/emission-factors')->name('emission.')->group(function () {
        Route::get('/', [EmissionFactorController::class, 'index'])->name('index');
        Route::get('/create', [EmissionFactorController::class, 'create'])->name('create');
        Route::post('/', [EmissionFactorController::class, 'store'])->name('store');
        Route::get('/{id}/edit', [EmissionFactorController::class, 'edit'])->name('edit');
        Route::put('/{id}', [EmissionFactorController::class, 'update'])->name('update');
        Route::delete('/{id}', [EmissionFactorController::class, 'destroy'])->name('destroy');
        Route::get('/export', [EmissionFactorController::class, 'export'])->name('export');
        Route::post('/import', [EmissionFactorController::class, 'import'])->name('import');
    });

    Route::resource('annual_batch', AnnualBatchController::class)->except(['create', 'show', 'edit', 'update']);

    // 5. User & Waste Bin Management
    Route::resource('users', UserWasteController::class)->except(['show']);
    Route::get('/waste_bin_users', [UserWasteController::class, 'waste_bin_users'])->name('waste_bin_users');
    Route::get('/users/search/{query}', [UserWasteController::class, 'search'])->name('users.search');
    Route::post('/waste-service-preferences', [UserWasteController::class, 'updateWasteServicePreferences'])->name('updateWasteServicePreferences');

    // 6. Purchase System
    Route::prefix('purchase/')->name('purchase.')->group(function () {

        // ระบบเลือกและจัดการเขตรับซื้อ
        Route::match(['get', 'post'], 'select-route', [RecyclePurchaseController::class, 'selectRoute'])->name('select_route');
        Route::get('routes-manage', [RecyclePurchaseController::class, 'routeIndex'])->name('routes.index');
        Route::post('routes-save', [RecyclePurchaseController::class, 'routeSave'])->name('routes.save');
        Route::delete('routes-delete/{id}', [RecyclePurchaseController::class, 'routeDelete'])->name('routes.delete');

        // ระบบรับซื้อขยะหน้างาน
        Route::get('select_user', [RecyclePurchaseController::class, 'select_user'])->name('select_user');
        Route::get('start_purchase/{user_id}', [RecyclePurchaseController::class, 'startPurchase'])->name('start_purchase');
        Route::get('form/{user_id}', [RecyclePurchaseController::class, 'showPurchaseForm'])->name('form');

        // ตะกร้าและคิดเงิน
        Route::post('add_to_cart', [RecyclePurchaseController::class, 'addToCart'])->name('add_to_cart');
        Route::delete('remove-from-cart/{index}', [RecyclePurchaseController::class, 'removeFromCart'])->name('remove_from_cart');
        Route::get('cart', [RecyclePurchaseController::class, 'showCart'])->name('cart');
        Route::post('save-transaction', [RecyclePurchaseController::class, 'saveTransaction'])->name('save_transaction');

        // ใบเสร็จและประวัติ
        Route::get('receipt/{transaction_id}', [RecyclePurchaseController::class, 'showReceipt'])->name('receipt');
        Route::get('history/{user_id}', [RecyclePurchaseController::class, 'showPurchaseHistory'])->name('history');
        Route::get('connect_bluethooth', [RecyclePurchaseController::class, 'connect_bluethooth'])->name('connect_bluethooth');

        // AJAX & API
        Route::get('get-units/{itemId}', [RecyclePurchaseController::class, 'getUnitsForItem'])->name('get_units');
        Route::post('save_transaction_machine', [RecyclePurchaseController::class, 'saveTransactionForMachine'])->name('save_transaction_machine');
    });

    // 7. Sell System
    Route::prefix('sell/')->name('sell.')->group(function () {
        Route::get('form', [RecycleSaleController::class, 'showSellForm'])->name('form');
        Route::post('store', [RecycleSaleController::class, 'storeSellTransaction'])->name('store');
        Route::get('history', [RecycleSaleController::class, 'showSellHistory'])->name('history');
        Route::get('receipt/{transaction}', [RecycleSaleController::class, 'showReceipt'])->name('receipt');
        Route::delete('/users/{transaction}', [RecycleSaleController::class, 'destroy'])->name('destroy');
    });

    Route::resource('bins', BinsController::class);

    // 8. Waste Bins Specifics
    Route::prefix('/{w_user}/waste-bins')->name('waste_bins.')->group(function () {
        Route::get('/', [AnnualTrashController::class, 'index'])->name('index');
        Route::get('/create', [AnnualTrashController::class, 'create'])->name('create');
        Route::post('/', [AnnualTrashController::class, 'store'])->name('store');
        Route::get('/edit', [AnnualTrashController::class, 'edit'])->name('edit');
    });
    // หมายเหตุ: Routes ข้างล่างนี้อยู่นอก prefix /{w_user}/waste-bins แต่อยู่ใน keptkayas group
    Route::put('waste-bins/{waste_bin}', [AnnualTrashController::class, 'update'])->name('waste_bins.update');
    Route::get('waste-bins/map', [AnnualTrashController::class, 'map'])->name('waste_bins.map');
    Route::get('waste-bins/viewmap', [AnnualTrashController::class, 'viewmap'])->name('waste_bins.viewmap');

    // 9. Annual Payments
    Route::prefix('annual-payments')->name('annual_payments.')->group(function () {
        Route::get('/', [AnnualTrashSubscriptionController::class, 'index'])->name('index');
        Route::get('/invoice', [AnnualTrashSubscriptionController::class, 'invoice'])->name('invoice');
        Route::get('/{wasteBinSubscription}', [AnnualTrashSubscriptionController::class, 'show'])->name('show');
        Route::get('print/{wasteBinSubscription}', [AnnualTrashSubscriptionController::class, 'printReceipt'])->name('print');
        Route::get('printReceipt/{wasteBinSubscription}', [AnnualTrashSubscriptionController::class, 'printReceipt'])->name('printReceipt');
        Route::post('/{wasteBinSubscription}/payments', [AnnualTrashSubscriptionController::class, 'storePayment'])->name('store_payment');
        Route::post('print-selected-invoices', [AnnualTrashSubscriptionController::class, 'printSelectedInvoices'])->name('print_selected_invoices');
        Route::post('/create-subscription', [AnnualTrashSubscriptionController::class, 'createSubscription'])->name('create_subscription');
        Route::post('/history', [AnnualTrashSubscriptionController::class, 'history'])->name('history');
    });

    Route::resource('wbin_payrate_per_months', AnnualTrashPayratePerMonthController::class)->except(['show']);

    // 10. Tbank System
    Route::prefix('/tbank/')->name('tbank.')->group(function () {

        Route::resource('items_group', RecycleItemGroupController::class)->except(['show', 'edit', 'update', 'destroy']);
        Route::resource('units', RecycleUnitController::class);

        Route::get('cart/cartLists/{user_id}', [CartController::class, 'cartLists'])->name('cart.cart_lists');
        Route::get('cart/add_to_cart/{id}/{amount}', [CartController::class, 'addToCart'])->name('cart.add_to_cart');
        Route::resource('cart', CartController::class)->except(['store', 'show', 'edit', 'update', 'destroy']);

        Route::get('prices/export', [RecyclePriceController::class, 'export'])->name('prices.export');
        Route::post('prices/import', [RecyclePriceController::class, 'import'])->name('prices.import');
        Route::get('/prices/bulk-edit', [RecyclePriceController::class, 'bulkEdit'])->name('prices.bulk_edit');
        Route::post('/prices/bulk-update', [RecyclePriceController::class, 'bulkUpdate'])->name('prices.bulk_update');
        Route::resource('prices', RecyclePriceController::class)->except(['show']);

        Route::prefix('items/')->name('items.')->group(function () {

            Route::get('export', [RecycleItemController::class, 'exportTemplate'])->name('export');
            Route::post('import', [RecycleItemController::class, 'import'])->name('import');

            Route::get('buyItems/{user_id?}', [RecycleItemController::class, 'buyItems'])->name('buy_items');
            Route::get('search_items/{itemscode}', [RecycleItemController::class, 'search_items'])->name('search_items');
            Route::get('generate-code/{group_id}', [RecycleItemController::class, 'generateCode'])->name('generate_code');

            Route::get('trash', [RecycleItemController::class, 'trash'])->name('trash');
            Route::get('{id}/restore', [RecycleItemController::class, 'restore'])->name('restore');
            Route::delete('{id}/force-delete', [RecycleItemController::class, 'forceDelete'])->name('forceDelete');

            Route::controller(RecycleItemController::class)->group(function () {
                Route::get('/', 'index')->name('index');
                Route::get('/create', 'create')->name('create');
                Route::post('/', 'store')->name('store');
                Route::get('/{id}', 'show')->name('show');
                Route::get('/{id}/edit', 'edit')->name('edit');
                Route::put('/{id}', 'update')->name('update');
                Route::delete('/{id}', 'destroy')->name('destroy');
                // restore is already defined above as a GET route (items.restore); removed duplicate name.
            });

            Route::get('pending-ef', [RecycleItemController::class, 'pendingEf'])->name('pendingEf');
            Route::post('update-ef-bulk', [RecycleItemController::class, 'updateEfBulk'])->name('updateEfBulk');
        });
    });

    // 11. User Groups
    Route::prefix('kp_usergroup')->name('kp_usergroup.')->group(function () {
        Route::get('/{usergroup_id}/infos', [KpUserGroupController::class, 'infos'])->name('usergroup.infos');
        Route::resource('/', KpUserGroupController::class)->except(['show']);
    });
}); // End Main Group
