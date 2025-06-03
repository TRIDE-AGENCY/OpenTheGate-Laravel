<template>
    <div id="kt_app_sidebar" class="app-sidebar flex-column" data-kt-drawer="true" data-kt-drawer-name="app-sidebar"
        data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="225px"
        data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_sidebar_mobile_toggle">
        <div class="app-sidebar-logo px-6 border-end border-gray-300" id="kt_app_sidebar_logo">
            <Link href="/admin/dashboard">
            <img alt="Logo" src="/assets/media/logos/bss-parking.png"
                class="h-40px app-sidebar-logo-default theme-light-show" />
            <img alt="Logo" src="/assets/media/logos/tojuara-default-small.svg"
                class="h-25px app-sidebar-logo-minimize" />
            </Link>
        </div>
        <div class="app-sidebar-menu overflow-hidden flex-column-fluid border-end border-gray-300">
            <div id="kt_app_sidebar_menu_wrapper"
                class="app-sidebar-wrapper d-flex flex-column justify-content-between gap-8 hover-scroll-overlay-y mt-5 mb-2"
                data-kt-scroll="true" data-kt-scroll-activate="true" data-kt-scroll-height="auto"
                data-kt-scroll-dependencies="#kt_app_sidebar_logo, #kt_app_sidebar_footer"
                data-kt-scroll-wrappers="#kt_app_sidebar_menu" data-kt-scroll-offset="5px"
                data-kt-scroll-save-state="true">
                <div class="menu menu-column menu-rounded menu-sub-indention px-4" id="#kt_app_sidebar_menu"
                    data-kt-menu="true" data-kt-menu-expand="false">
                    <div class="menu-item">
                        <Link class="menu-link menu-link-mysecondary"
                            :class="{ 'active': $page.url.startsWith('/admin/dashboard') }" href="/admin/dashboard">
                        <span class="menu-icon">
                            <i
                                :class="[$page.url.startsWith('/admin/dashboard') ? 'ri-dashboard-fill' : 'ri-dashboard-line',
                                    'fs-2'
                                ]"></i>
                        </span>
                        <span
                            :class="[$page.url.startsWith('/admin/dashboard') ? 'fw-bold' : 'fw-semibold', 'menu-title fs-5']">Dashboard</span>
                        </Link>
                    </div>
                    <div class="menu-item pt-4">
                        <div class="menu-content py-1">
                            <span class="text-gray-500 fw-bold text-uppercase fs-7">Menu Parkir</span>
                        </div>
                    </div>
                    <div class="menu-item">
                        <Link class="menu-link menu-link-mysecondary"
                            :class="{ 'active': $page.url.startsWith('/admin/histories') }" href="/admin/histories">
                        <span class="menu-icon">
                            <i
                                :class="[$page.url.startsWith('/admin/histories') ? 'ri-history-fill' :
                                    'ri-history-line', 'fs-2'
                                ]"></i>
                        </span>
                        <span
                            :class="[$page.url.startsWith('/admin/histories') ? 'fw-bold' : 'fw-semibold', 'menu-title fs-5']">Riwayat
                            Parkir</span>
                        </Link>
                    </div>
                    <div class="menu-item">
                        <Link class="menu-link menu-link-mysecondary"
                            :class="{ 'active': $page.url.startsWith('/admin/carlists') }" href="/admin/carlists">
                        <span class="menu-icon">
                            <i
                                :class="[$page.url.startsWith('/admin/carlists') ? 'ri-parking-box-fill' :
                                    'ri-parking-box-line', 'fs-2'
                                ]"></i>
                        </span>
                        <span
                            :class="[$page.url.startsWith('/admin/carlists') ? 'fw-bold' : 'fw-semibold', 'menu-title fs-5']">Kendaraan
                            Terdaftar</span>
                        </Link>
                    </div>
                    <div class="menu-item">
                        <Link class="menu-link menu-link-mysecondary"
                            :class="{ 'active': $page.url.startsWith('/admin/rates') }" href="/admin/rates">
                        <span class="menu-icon">
                            <i
                                :class="[$page.url.startsWith('/admin/rates') ? 'ri-coupon-fill' : 'ri-coupon-line', 'fs-2']"></i>
                        </span>
                        <span
                            :class="[$page.url.startsWith('/admin/rates') ? 'fw-bold' : 'fw-semibold', 'menu-title fs-5']">Tarif
                            Parkir</span>
                        </Link>
                    </div>
                    <div class="menu-item pt-4">
                        <div class="menu-content py-1">
                            <span class="text-gray-500 fw-bold text-uppercase fs-7">Master Data</span>
                        </div>
                    </div>
                    <div class="menu-item">
                        <Link class="menu-link menu-link-mysecondary"
                            :class="{ 'active': $page.url.startsWith('/admin/vehicles') }" href="/admin/vehicles">
                        <span class="menu-icon">
                            <i
                                :class="[$page.url.startsWith('/admin/vehicles') ? 'ri-roadster-fill' : 'ri-roadster-line',
                                    'fs-2'
                                ]"></i>
                        </span>
                        <span
                            :class="[$page.url.startsWith('/admin/vehicles') ? 'fw-bold' : 'fw-semibold', 'menu-title fs-5']">Jenis
                            Kendaraan</span>
                        </Link>
                    </div>
                    <div class="menu-item">
                        <Link class="menu-link menu-link-mysecondary"
                            :class="{ 'active': $page.url.startsWith('/admin/plates') }" href="/admin/plates">
                        <span class="menu-icon">
                            <i
                                :class="[$page.url.startsWith('/admin/plates') ? 'ri-info-card-fill' : 'ri-info-card-line',
                                    'fs-2'
                                ]"></i>
                        </span>
                        <span
                            :class="[$page.url.startsWith('/admin/plates') ? 'fw-bold' : 'fw-semibold', 'menu-title fs-5']">Jenis
                            Plat</span>
                        </Link>
                    </div>
                    <div class="menu-item pt-4">
                        <div class="menu-content py-1">
                            <span class="text-gray-500 fw-bold text-uppercase fs-7">Lainnya</span>
                        </div>
                    </div>
                    <div class="menu-item">
                        <Link class="menu-link menu-link-mysecondary"
                            :class="{ 'active': $page.url.startsWith('/admin/user') }" href="/admin/user">
                        <span class="menu-icon">
                            <i
                                :class="[$page.url.startsWith('/admin/user') ? 'ri-account-circle-fill' : 'ri-account-circle-line',
                                    'fs-2'
                                ]"></i>
                        </span>
                        <span
                            :class="[$page.url.startsWith('/admin/user') ? 'fw-bold' : 'fw-semibold', 'menu-title fs-5']">Akun</span>
                        </Link>
                    </div>
                </div>
                <Link href="#"
                    class="btn-bss-parking mx-4 px-7 pt-7 pb-5 bg-myprimary bg-hover-myprimary rounded-3 d-flex flex-column align-items-center">
                <i class="ri-live-line text-myprimary fs-2hx p-4 bg-white rounded-pill mb-4 pulse-icon"></i>
                <h1 class="m-0 fs-2 text-white fw-semibold">BSS Parking</h1>
                <span class="fs-6 fw-normal text-white opacity-75">2 Gate</span>
                </Link>
            </div>
        </div>
    </div>
</template>

<script>
    import {
        Link
    } from '@inertiajs/vue3';

    import {
        RiRoadsterLine
    } from "@remixicon/vue";

    export default {
        components: {
            Link,
            RiRoadsterLine
        },

    }
</script>

<style>
    .btn-bss-parking:hover i {
        scale: 1.05;
    }

    @keyframes pulseWhite {
        0% {
            box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.7);
        }

        70% {
            box-shadow: 0 0 0 30px rgba(255, 255, 255, 0);
        }

        100% {
            box-shadow: 0 0 0 0 rgba(255, 255, 255, 0);
        }
    }

    .pulse-icon {
        animation: pulseWhite 2s infinite;
    }
</style>
