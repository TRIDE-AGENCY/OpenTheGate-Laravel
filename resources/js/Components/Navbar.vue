<template>
    <div id="kt_app_header" class="app-header bg-white">
        <div class="container-fluid d-flex align-items-stretch justify-content-between">
            <div class="d-flex align-items-center d-lg-none ms-n3 me-2" title="Show sidebar menu">
                <div class="btn btn-icon btn-active-color-primary w-35px h-35px" id="kt_app_sidebar_mobile_toggle">
                    <i class="bi bi-list fs-1"></i>
                </div>
            </div>
            <div class="d-flex align-items-center flex-grow-1 flex-lg-grow-0">
                <a href="#" class="d-lg-none">
                    <img alt="Logo" src="/assets/media/logos/bss-parking.png" class="h-30px" />
                </a>
            </div>
            <div class="d-flex align-items-center justify-content-between flex-lg-grow-1" id="kt_app_header_wrapper">
                <div></div>
                <div class="app-navbar-item ms-1 ms-lg-3" id="kt_header_user_menu_toggle">
                    <div class="cursor-pointer symbol symbol-35px symbol-md-40px" data-kt-menu-trigger="click"
                        data-kt-menu-attach="parent" data-kt-menu-placement="bottom-end">
                        <div class="symbol-label fs-3 fw-semibold btn-myprimary">
                            {{ getInitials($page . props . auth . user . name) }}</div>
                    </div>
                    <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-color fw-semibold mt-3 py-4 fs-6 w-275px"
                        data-kt-menu="true">
                        <div class="menu-item px-5">
                            <div class="menu-content d-flex align-items-center px-0 pt-1">
                                <div class="symbol symbol-50px me-4">
                                    <div class="symbol-label fs-2 fw-semibold bg-myprimary text-white">
                                        {{ getInitials($page . props . auth . user . name) }}</div>
                                </div>
                                <div class="d-flex flex-column">
                                    <div class="fw-bold d-flex align-items-center fs-5">
                                        {{ $page . props . auth . user . name }}
                                        <span class="badge bg-mysecondary text-mysecondary fw-bold fs-8 px-2 py-1 ms-2">Admin</span>
                                    </div>
                                    <p class="fw-semibold text-muted fs-7 mb-0">
                                        {{ $page . props . auth . user . email }}</p>
                                </div>
                            </div>
                        </div>
                        <div class="separator my-2"></div>
                        <div class="menu-item px-5">
                            <Link href="/admin/logout" method="POST" as="button"
                                class="px-5 btn btn-mydanger w-100 text-start">Keluar</Link>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import {
        Link
    } from '@inertiajs/vue3';

    export default {
        components: {
            Link,
        },
        methods: {
            getInitials(name) {
                if (!name) return '';
                return name
                    .split(' ')
                    .map(n => n[0].toUpperCase())
                    .join('')
                    .slice(0, 2);
            }
        }
    }
</script>

<style>

</style>
