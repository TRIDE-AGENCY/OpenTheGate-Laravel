<template>
    <div class="app-main flex-column flex-row-fluid" id="kt_app_main">

        <Head>
            <title>Detail Parkir {{ history . plate }}</title>
        </Head>

        <div class="d-flex flex-column flex-column-fluid">
            <div id="kt_app_toolbar" class="app-toolbar py-7 py-lg-8">
                <div id="kt_app_toolbar_container" class="app-container container-xxl d-flex flex-stack">
                    <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
                        <ol class="breadcrumb text-muted fs-6 fw-semibold mb-3">
                            <li class="breadcrumb-item pe-3">
                                <Link href="/admin/dashboard" class="btn-link-myprimary pe-3">Dashboard</Link>
                            </li>
                            <li class="breadcrumb-item pe-3">
                                <Link href="/admin/histories" class="btn-link-myprimary pe-3">Riwayat Parkir</Link>
                            </li>
                            <li class="breadcrumb-item pe-3 text-muted">{{ history . plate }}</li>
                        </ol>
                        <div class="d-flex align-items-center">
                            <h1 class="mb-0 me-3">Detail Parkir {{ history . plate }}</h1>
                            <span class="badge bg-mysecondary text-mysecondary fs-6"
                                :class="{
                                    'bg-mysecondary text-mysecondary': history.status === 'Temporary',
                                    'bg-mysuccess text-mysuccess': history.status === 'Completed',
                                    'bg-mydanger text-mydanger': history.status === 'Rejected'
                                }">
                                {{ history . status }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div id="kt_app_content" class="app-content flex-column-fluid">
                <div id="kt_app_content_container" class="app-container container-xxl">
                    <div class="row g-6">
                        <div class="col-sm-12 col-md-4">
                            <div class="card border border-gray-300">
                                <div class="card-header h-auto border-bottom border-gray-300 p-6"
                                    style="min-height: unset;">
                                    <div class="card-title m-0 d-flex flex-column gap-2">
                                        <h2>Rincian Parkir</h2>
                                    </div>
                                </div>
                                <div class="card-body d-flex align-items-center flex-column gap-3 p-6">
                                    <div class="d-flex justify-content-between w-100">
                                        <div class="fs-4 text-gray-700">Plat Kendaraan</div>
                                        <div class="fs-4 fw-bold">{{ history . plate }}</div>
                                    </div>
                                    <div class="d-flex justify-content-between w-100">
                                        <div class="fs-4 text-gray-700">Jenis Kendaraan</div>
                                        <div class="fs-4 fw-bold">{{ history . rate . vehicle . type }}</div>
                                    </div>
                                    <div class="d-flex justify-content-between w-100">
                                        <div class="fs-4 text-gray-700">Jenis Plat</div>
                                        <div class="fs-4 fw-bold">{{ history . rate . plate . type }}</div>
                                    </div>
                                    <div class="d-flex justify-content-between w-100">
                                        <div class="fs-4 text-gray-700">Waktu Masuk</div>
                                        <div class="fs-4 fw-bold">{{ formatDate(history . gate_in) }}</div>
                                    </div>
                                    <div class="d-flex justify-content-between w-100">
                                        <div class="fs-4 text-gray-700">Waktu Keluar</div>
                                        <div class="fs-4 fw-bold">{{ formatDate(history . gate_out) ?? '-' }}</div>
                                    </div>
                                    <div class="d-flex justify-content-between w-100">
                                        <div class="fs-4 text-gray-700">Durasi Parkir</div>
                                        <div class="fs-4 fw-bold">{{ calculateDuration(history.gate_in, history.gate_out) ?? '-' }}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="card border border-gray-300 mt-6">
                                <div class="card-body d-flex align-items-center gap-5 p-6 border-top border-gray-300">
                                    <div class="d-flex flex-column flex-grow-1">
                                        <p class="fs-4 text-gray-700 mb-2">Total Tarif Parkir</p>
                                        <h1 class="fs-2hx mb-0">
                                            {{ history . total_rate ? `Rp${formatNumber(history . total_rate)}` : '-' }}
                                        </h1>
                                    </div>
                                    <div
                                        class="p-6 bg-mysecondary rounded-circle d-flex align-items-center justify-content-center">
                                        <i class="ri-coupon-2-line text-mysecondary fs-2hx"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-8">
                            <div class="card border border-gray-300">
                                <div class="card-header h-auto border-bottom border-gray-300 px-6 pt-6 pb-5"
                                    style="min-height: unset;">
                                    <div class="card-title m-0 d-flex flex-column gap-3">
                                        <h2>Pintu Masuk</h2>
                                        <div class="d-flex flex-wrap gap-1">
                                            <div class="d-flex align-items-center me-3">
                                                <i class="ri-time-line fs-4 me-2 text-mysecondary"></i>
                                                <span class="fw-semibold fs-4 text-mysecondary">Waktu Inferensi:
                                                    {{ Number(history . processing_time_in) . toFixed(2) }}
                                                    Detik</span>
                                            </div>
                                            <div class="d-flex align-items-center">
                                                <i class="ri-crosshair-2-line fs-4 me-2 text-mysecondary"></i>
                                                <span class="fw-semibold fs-4 text-mysecondary">Akurasi:
                                                    {{ Number(history . confidence_in) * 100 . toFixed(2) }}%</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="image-container"
                                    style="position: relative; display: inline-block; max-width: 100%;">
                                    <img ref="imgRef" class="img-fluid rounded-3 rounded-top-0"
                                        :src="`/storage/${history.image_in}`" alt="Gambar Pintu Masuk"
                                        @load="onImageInLoad" style="max-width: 100%; height: auto;" />
                                    <div v-if="boxStyle" :style="boxStyle" class="bounding-box">
                                        <div class="box-label">{{ history . plate }}</div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="history.image_out" class="card border border-gray-300 mt-6">
                                <div class="card-header h-auto border-bottom border-gray-300 px-6 pt-6 pb-5"
                                    style="min-height: unset;">
                                    <div class="card-title m-0 d-flex flex-column gap-3">
                                        <h2>Pintu Keluar</h2>
                                        <div class="d-flex flex-wrap gap-1">
                                            <div class="d-flex align-items-center me-3">
                                                <i class="ri-time-line fs-4 me-2 text-mysecondary"></i>
                                                <span class="fw-semibold fs-4 text-mysecondary">Waktu Inferensi:
                                                    {{ Number(history . processing_time_out) . toFixed(2) }}
                                                    Detik</span>
                                            </div>
                                            <div class="d-flex align-items-center">
                                                <i class="ri-crosshair-2-line fs-4 me-2 text-mysecondary"></i>
                                                <span class="fw-semibold fs-4 text-mysecondary">Akurasi:
                                                    {{ Number(history . confidence_out) * 100 . toFixed(2) }}%</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="image-container"
                                    style="position: relative; display: inline-block; max-width: 100%;">
                                    <img ref="imgRefOut" class="img-fluid rounded-3 rounded-top-0"
                                        :src="`/storage/${history.image_out}`" alt="Gambar Pintu Keluar"
                                        @load="onImageOutLoad" style="max-width: 100%; height: auto;" />
                                    <div v-if="boxStyleOut" :style="boxStyleOut" class="bounding-box">
                                        <div class="box-label">{{ history . plate }}</div>
                                    </div>
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
        ref
    } from 'vue';
    import {
        Head,
        Link,
    } from '@inertiajs/vue3';

    export default {
        layout: LayoutAdmin,

        props: {
            history: Object,
        },
        components: {
            Head,
            Link,
        },
        setup(props) {
            const imgRef = ref(null);
            const boxStyle = ref(null);
            const imgRefOut = ref(null);
            const boxStyleOut = ref(null);

            const onImageInLoad = () => {
                const img = imgRef.value;
                if (!img) return;

                const origWidth = props.history.image_width || img.naturalWidth;
                const origHeight = props.history.image_height || img.naturalHeight;

                const displayWidth = img.clientWidth;
                const displayHeight = img.clientHeight;

                const scaleX = displayWidth / origWidth;
                const scaleY = displayHeight / origHeight;

                const {
                    x1_in,
                    y1_in,
                    x2_in,
                    y2_in
                } = props.history;

                const left = x1_in * scaleX;
                const top = y1_in * scaleY;
                const width = (x2_in - x1_in) * scaleX;
                const height = (y2_in - y1_in) * scaleY;

                boxStyle.value = {
                    left: `${left}px`,
                    top: `${top}px`,
                    width: `${width}px`,
                    height: `${height}px`,
                };
            };

            const onImageOutLoad = () => {
                const img = imgRefOut.value;
                if (!img) return;

                const origWidth = props.history.image_width || img.naturalWidth;
                const origHeight = props.history.image_height || img.naturalHeight;

                const displayWidth = img.clientWidth;
                const displayHeight = img.clientHeight;

                const scaleX = displayWidth / origWidth;
                const scaleY = displayHeight / origHeight;

                const {
                    x1_out,
                    y1_out,
                    x2_out,
                    y2_out
                } = props.history;

                const left = x1_out * scaleX;
                const top = y1_out * scaleY;
                const width = (x2_out - x1_out) * scaleX;
                const height = (y2_out - y1_out) * scaleY;

                boxStyleOut.value = {
                    left: `${left}px`,
                    top: `${top}px`,
                    width: `${width}px`,
                    height: `${height}px`,
                };
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

            const formatNumber = (value) => {
                return new Intl.NumberFormat('id-ID').format(value);
            };

            const calculateDuration = (start, end) => {
                if (!start || !end) return '-';

                const startDate = new Date(start);
                const endDate = new Date(end);

                let diff = Math.floor((endDate - startDate) / 1000); // selisih detik

                if (diff < 0) return '-'; // waktu keluar sebelum masuk, invalid

                const hours = Math.floor(diff / 3600);
                diff %= 3600;
                const minutes = Math.floor(diff / 60);
                const seconds = diff % 60;

                // format HH:mm:ss dengan leading zero
                const pad = (n) => (n < 10 ? '0' + n : n);

                return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;
            };

            return {
                imgRef,
                boxStyle,
                onImageInLoad,
                imgRefOut,
                boxStyleOut,
                onImageOutLoad,
                formatDate,
                formatNumber,
                calculateDuration
            };
        },
    };
</script>


<style scoped>
    .bounding-box {
        position: absolute;
        border: 2px solid red;
        pointer-events: none;
        box-sizing: border-box;
        background-color: rgba(255, 0, 0, 0.2);
    }

    .box-label {
        position: absolute;
        top: -22px;
        /* posisi di atas bounding box */
        left: -1px;
        background-color: rgba(255, 0, 0, 1);
        color: white;
        padding: 2px 6px;
        font-size: 1rem;
        font-weight: 600;
        white-space: nowrap;
        pointer-events: none;
    }
</style>
