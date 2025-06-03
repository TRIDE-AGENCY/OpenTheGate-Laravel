<template>

    <Head>
        <title>Dashboard - BSS Parking</title>
    </Head>

    <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
        <div class="d-flex flex-column flex-column-fluid">
            <div id="kt_app_toolbar" class="app-toolbar py-7 py-lg-8">
                <div id="kt_app_toolbar_container" class="app-container container-xxl d-flex flex-stack">
                    <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
                        <h1 class="page-heading d-flex text-dark fw-bold flex-column justify-content-center my-0 mb-2">
                            Dashboard Admin
                        </h1>
                        <p class="fs-4 text-gray-600 m-0">Selamat Datang {{ $page . props . auth . user . name }}</p>
                    </div>
                </div>
            </div>

            <div id="kt_app_content" class="app-content flex-column-fluid">
                <div id="kt_app_content_container" class="app-container container-xxl px-0 d-flex flex-column gap-6">
                    <div class="row g-6">
                        <div class="col-12 col-sm-4">
                            <div class="card border border-gray-300 h-100">
                                <div class="card-body d-flex align-items-center gap-5 p-6">
                                    <div
                                        class="p-6 bg-mysecondary rounded-circle d-flex align-items-center justify-content-center">
                                        <i class="ri-login-circle-line text-mysecondary fs-2hx"></i>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <p class="fs-4 fw-semibold text-gray-800 mb-1">Kendaraan Masuk</p>
                                        <h1 class="fs-2hx mb-0">{{ formatNumber(kendaraanMasuk) }}</h1>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-sm-4">
                            <div class="card border border-gray-300 h-100">
                                <div class="card-body d-flex align-items-center gap-5 p-6">
                                    <div
                                        class="p-6 bg-mysecondary rounded-circle d-flex align-items-center justify-content-center">
                                        <i class="ri-logout-circle-line text-mysecondary fs-2hx"></i>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <p class="fs-4 fw-semibold text-gray-800 mb-1">Kendaraan Keluar</p>
                                        <h1 class="fs-2hx mb-0">{{ formatNumber(kendaraanKeluar) }}</h1>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-sm-4">
                            <div class="card border border-gray-300 h-100">
                                <div class="card-body d-flex align-items-center gap-5 p-6">
                                    <div
                                        class="p-6 bg-mysecondary rounded-circle d-flex align-items-center justify-content-center">
                                        <i class="ri-wallet-3-fill text-mysecondary fs-2hx"></i>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <p class="fs-4 fw-semibold text-gray-800 mb-1">Total Pendapatan</p>
                                        <h1 class="fs-2hx mb-0">Rp{{ formatNumber(totalPendapatan) }}</h1>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row g-6">
                        <div class="col-12 col-sm-8">
                            <div class="card border border-gray-300">
                                <div class="card-header h-auto border-bottom border-gray-300 p-6"
                                    style="min-height: unset;">
                                    <div class="card-title m-0 d-flex flex-column gap-2">
                                        <h2>Waktu Kendaraan Masuk & Keluar</h2>
                                    </div>
                                </div>
                                <div class="card-body p-6" style="height: 400px;">
                                    <canvas ref="gateCanvas"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-sm-4">
                            <div class="card border border-gray-300">
                                <div class="card-header h-auto border-bottom border-gray-300 p-6"
                                    style="min-height: unset;">
                                    <div class="card-title m-0 d-flex flex-column gap-2">
                                        <h2>Status Parkir</h2>
                                    </div>
                                </div>
                                <div class="card-body p-6" style="height: 400px;">
                                    <canvas ref="statusCanvas"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row g-6">
                        <div class="col-12 col-sm-4">
                            <div class="card border border-gray-300">
                                <div class="card-header h-auto border-bottom border-gray-300 p-6"
                                    style="min-height: unset;">
                                    <div class="card-title m-0 d-flex flex-column gap-2">
                                        <h2>Aktifitas Terbaru</h2>
                                    </div>
                                </div>
                                <div class="card-body p-6" style="height: 300px; overflow-y: auto;">
                                    <div class="list-group list-group-flush">
                                        <template v-if="latestHistories.length > 0">
                                            <div class="d-flex flex-column gap-6">
                                                <div v-for="history in latestHistories" :key="history.id">
                                                    <Link :href="`/admin/histories/${history.id}`"
                                                        class="d-flex flex-stack" type="button">
                                                    <div class="symbol symbol-50px me-4">
                                                        <img :src="`/storage/${history.image_in}`" />
                                                    </div>
                                                    <div
                                                        class="d-flex align-items-center flex-row-fluid flex-wrap gap-1">
                                                        <div class="d-flex flex-row align-items-center">
                                                            <p
                                                                class="text-gray-800 fs-3 fw-bold d-flex align-items-center m-0">
                                                                Plat {{ history . plate }}
                                                            </p>
                                                            <span class="badge badge-lg ms-3"
                                                                :class="{
                                                                    'bg-mysecondary text-mysecondary': history
                                                                        .status === 'Temporary',
                                                                    'bg-mysuccess text-mysuccess': history
                                                                        .status === 'Completed',
                                                                    'bg-mydanger text-mydanger': history
                                                                        .status === 'Rejected'
                                                                }">
                                                                {{ history . status }}
                                                            </span>
                                                        </div>
                                                        <p class="text-muted d-block fs-5 m-0">
                                                            {{ history . gate_out ? formatDate(history . gate_out) : formatDate(history . gate_in) }}
                                                        </p>
                                                    </div>
                                                    </Link>
                                                </div>
                                            </div>
                                        </template>
                                        <template v-else>
                                            <div class="text-center text-muted py-5">Belum ada aktivitas terbaru.</div>
                                        </template>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-sm-8">
                            <div class="card border border-gray-300">
                                <div class="card-header h-auto border-bottom border-gray-300 p-6"
                                    style="min-height: unset;">
                                    <div class="card-title m-0 d-flex flex-column gap-2">
                                        <h2>Jumlah per Jenis Kendaraan</h2>
                                    </div>
                                </div>
                                <div class="card-body p-6" style="height: 300px;">
                                    <canvas ref="vehicleCanvas"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import LayoutAdmin from '../../../Layouts/Admin.vue';
    import {
        Head,
        Link,
        router
    } from '@inertiajs/vue3';
    import {
        ref,
        onMounted,
        watch
    } from "vue";
    import {
        Chart,
        registerables
    } from 'chart.js';

    export default {
        layout: LayoutAdmin,

        components: {
            Head,
            Link,
        },

        props: {
            totalPendapatan: Number,
            kendaraanMasuk: Number,
            kendaraanKeluar: Number,
            statusData: Object,
            vehicleTypeCounts: Object,
            hourLabels: Array,
            gateInData: Array,
            gateOutData: Array,
            latestHistories: Object,
        },

        setup(props) {
            const statusCanvas = ref(null);
            const vehicleCanvas = ref(null);
            const gateCanvas = ref(null);
            let statusChart = null;
            let vehicleChart = null;
            let gateChart = null;

            Chart.register(...registerables);

            const renderStatusChart = () => {
                if (!statusCanvas.value) return;

                if (statusChart) {
                    statusChart.destroy();
                }

                statusChart = new Chart(statusCanvas.value, {
                    type: 'doughnut',
                    data: {
                        labels: ['Temporary', 'Completed', 'Rejected'],
                        datasets: [{
                            label: 'Jumlah',
                            data: [
                                props.statusData?.Temporary ?? 0,
                                props.statusData?.Completed ?? 0,
                                props.statusData?.Rejected ?? 0,
                            ],
                            backgroundColor: ['#4171b6', '#22C55E', '#EF4444'],
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 20,
                                }
                            },
                            tooltip: {
                                enabled: true
                            }
                        }
                    }
                });
            };

            const renderVehicleChart = () => {
                if (!vehicleCanvas.value) return;

                if (vehicleChart) {
                    vehicleChart.destroy();
                }

                vehicleChart = new Chart(vehicleCanvas.value, {
                    type: 'bar',
                    data: {
                        labels: Object.keys(props.vehicleTypeCounts || {}),
                        datasets: [{
                            label: 'Jumlah Kendaraan',
                            data: Object.values(props.vehicleTypeCounts || {}),
                            backgroundColor: '#4171b6',
                        }]
                    },
                    options: {
                        indexAxis: 'y', // horizontal bar
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1,
                                    precision: 0,
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false,
                            },
                            tooltip: {
                                enabled: true
                            }
                        }
                    }
                });
            };

            const renderGateChart = () => {
                if (gateChart) {
                    gateChart.destroy();
                }
                gateChart = new Chart(gateCanvas.value, {
                    type: 'line',
                    data: {
                        labels: props.hourLabels,
                        datasets: [{
                                label: 'Kendaraan Masuk',
                                data: props.gateInData,
                                borderColor: '#4171b6', // biru
                                backgroundColor: 'rgba(65, 113, 182, 0.2)',
                                fill: true,
                                tension: 0.3,
                            },
                            {
                                label: 'Kendaraan Keluar',
                                data: props.gateOutData,
                                borderColor: '#EF4444', // merah
                                backgroundColor: 'rgba(239, 68, 68, 0.2)',
                                fill: true,
                                tension: 0.3,
                            },
                        ],
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                stepSize: 1,
                                ticks: {
                                    precision: 0,
                                },
                            },
                        },
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 20,
                                }
                            },
                        },
                    },
                });
            };

            onMounted(() => {
                renderStatusChart();
                renderVehicleChart();
                renderGateChart();
            });

            watch(() => props.statusData, () => {
                renderStatusChart();
            });

            watch(() => props.vehicleTypeCounts, () => {
                renderVehicleChart();
            });

            watch(
                () => [props.hourLabels, props.gateInData, props.gateOutData],
                () => {
                    renderGateChart();
                }
            );

            const formatNumber = (value) => {
                return new Intl.NumberFormat('id-ID').format(value);
            };

            const formatDate = (dateString) => {
                if (!dateString) return null; // return null supaya bisa dipakai ?? '-'

                const date = new Date(dateString);
                let time = date.toLocaleTimeString('id-ID', {
                    hour12: false,
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                });
                time = time.replace(/\./g, ':');

                const options = {
                    day: 'numeric',
                    month: 'short',
                    year: 'numeric'
                };
                const formattedDate = date.toLocaleDateString('id-ID', options);

                return `${time}, ${formattedDate}`;
            };

            return {
                statusCanvas,
                vehicleCanvas,
                gateCanvas,
                formatNumber,
                formatDate,
                latestHistories: props.latestHistories || [],
            };
        },
    };
</script>
