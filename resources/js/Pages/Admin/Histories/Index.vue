<template>

    <Head>
        <title>Riwayat Parkir - BSS Parking</title>
    </Head>

    <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
        <div class="d-flex flex-column flex-column-fluid">
            <div id="kt_app_toolbar" class="app-toolbar py-7 py-lg-8">
                <div id="kt_app_toolbar_container" class="app-container container-xxl d-flex flex-stack">
                    <div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
                        <ol class="breadcrumb text-muted fs-6 fw-semibold mb-3">
                            <li class="breadcrumb-item pe-3">
                                <Link href="/admin/dashboard" class="btn-link-myprimary pe-3">Dashboard</Link>
                            </li>
                            <li class="breadcrumb-item pe-3 text-muted">Riwayat Parkir</li>
                        </ol>
                        <h1 class="page-heading d-flex text-dark fw-bold flex-column justify-content-center my-0">
                            Riwayat Parkir</h1>
                    </div>
                </div>
            </div>
            <div id="kt_app_content" class="app-content flex-column-fluid">
                <div id="kt_app_content_container" class="app-container container-xxl px-0">
                    <div class="card border border-gray-300">
                        <div class="card-header border-0 px-8 py-5 d-flex flex-wrap gap-3">
                            <form @submit.prevent="handleSearch"
                                class="d-flex align-items-center position-relative my-1 flex-grow-1"
                                style="max-width: 300px;">
                                <i class="bi bi-search position-absolute ms-5 fs-4"></i>
                                <input type="text" class="form-control form-control-solid ps-13 fs-5"
                                    placeholder="Cari plat kendaraan disini..." v-model="search" />
                            </form>
                            <div class="card-toolbar m-0">
                                <button data-bs-toggle="modal" data-bs-target="#kt_modal_add_image"
                                    class="d-flex align-items-center btn btn-sm fw-bold btn-myprimary fs-5">
                                    Tambah Data
                                </button>
                            </div>
                        </div>
                        <div class="card-body px-0 pt-0 pb-5">
                            <div class="table-responsive">
                                <table id="kt_datatable_horizontal_scroll"
                                    class="table align-middle table-row-bordered fs-5 gy-5 border-bottom border-gray-300 mb-5">
                                    <thead>
                                        <tr class="text-start text-gray-600 fw-bold fs-7 text-uppercase gs-0">
                                            <th class="w-20px ps-8 pe-5 bg-secondary">No</th>
                                            <th class="bg-secondary min-w-150px">Plat</th>
                                            <th class="bg-secondary min-w-200px">Waktu Masuk</th>
                                            <th class="bg-secondary min-w-200px">Waktu Keluar</th>
                                            <th class="bg-secondary min-w-150px">Durasi Parkir</th>
                                            <th class="bg-secondary min-w-150px">Total Tarif</th>
                                            <th class="bg-secondary min-w-100px">Status</th>
                                            <th class="bg-secondary pe-8 min-w-125px"></th>
                                        </tr>
                                    </thead>
                                    <tbody class="fw-semibold text-gray-600">
                                        <tr v-if="histories.data.length === 0">
                                            <td colspan="7" class="text-center py-10">
                                                <img src="/assets/media/illustrations/empty.png" alt="Tidak ada data"
                                                    style="max-height: 260px;">
                                                <h2 class="text-gray-800">Riwayat Parkir Tidak Ditemukan</h2>
                                                <p class="text-gray-600 fs-4">Belum ada riwayat parkir atau pencarian
                                                    tidak sesuai.</p>
                                            </td>
                                        </tr>
                                        <tr v-else v-for="(history, index) in histories.data" :key="index">
                                            <td class="ps-8">
                                                {{ ++index + (histories . current_page - 1) * histories . per_page }}
                                            </td>
                                            <td class="text-gray-800">{{ history . plate }}</td>
                                            <td>{{ formatDate(history . gate_in) ?? '-' }}</td>
                                            <td>{{ formatDate(history . gate_out) ?? '-' }}</td>
                                            <td>{{ calculateDuration(history.gate_in, history.gate_out) }}</td>
                                            <td>
                                                <template v-if="history.total_rate !== null">
                                                    Rp{{ formatNumber(history . total_rate) }}
                                                </template>
                                                <template v-else>
                                                    -
                                                </template>
                                            </td>
                                            <td>
                                                <span class="badge badge-lg"
                                                    :class="{
                                                        'bg-mysecondary text-mysecondary': history
                                                            .status === 'Temporary',
                                                        'bg-mysuccess text-mysuccess': history.status === 'Completed',
                                                        'bg-mydanger text-mydanger': history.status === 'Rejected'
                                                    }">
                                                    {{ history . status }}
                                                </span>
                                            </td>
                                            <td class="text-end pe-8">
                                                <Link :href="`/admin/histories/${history.id}`"
                                                    class="btn btn-sm btn-icon btn-mysecondary me-2" type="button">
                                                <i class="ri-coupon-fill fs-3"></i></Link>
                                                <button @click.prevent="destroy(history.id)"
                                                    class="btn btn-sm btn-icon btn-mydanger">
                                                    <i class="ri-delete-bin-fill fs-3"></i></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <Pagination :links="histories.links" align="end" class="px-8" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="kt_modal_add_image" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered mw-500px">
                <div class="modal-content">
                    <div class="modal-body scroll-y pt-12 px-10 pb-10">
                        <div class="mw-lg-500px mx-auto">
                            <div class="pb-7 text-center">
                                <h1 class="text-dark mb-3">Tambah Data</h1>
                                <div class="text-gray-800 fw-semibold fs-5">Unggah foto kendaraan secara manual di
                                    gerbang masuk/keluar untuk mencatat data parkir secara otomatis
                                </div>
                            </div>
                            <form @submit.prevent="submit">
                                <input type="file" class="form-control fs-5"
                                    @input="form.image_in = $event.target.files[0]"
                                    :class="{ 'is-invalid': errors.image_in }">
                                <div v-if="errors.image_in" class="text-danger mt-2">
                                    {{ errors . image_in }}
                                </div>
                                <div v-if="errors[0]" class="text-danger mt-2">
                                    {{ errors[0] }}
                                </div>
                                <button type="submit" id="kt_modal_submit_button"
                                    class="btn btn-md btn-myprimary w-100 fs-5 mt-6">
                                    <span class="indicator-label">Deteksi Plat</span>
                                    <span class="indicator-progress">
                                        Mohon Tunggu...
                                        <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
                                    </span>
                                </button>
                                <button class="btn btn-md btn-mylight w-100 fs-5 mt-2"
                                    data-bs-dismiss="modal">Batal</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import LayoutAdmin from '../../../Layouts/Admin.vue';
    import Pagination from '../../../Components/Pagination.vue';
    import {
        Head,
        Link,
        router
    } from '@inertiajs/vue3';
    import {
        reactive,
        ref,
        onMounted
    } from 'vue';
    import Swal from 'sweetalert2';

    export default {
        layout: LayoutAdmin,

        components: {
            Head,
            Link,
            Pagination,
        },

        props: {
            errors: Object,
            histories: Object,
            rates: Array,
        },

        setup() {
            const search = ref('' || (new URL(document.location)).searchParams.get('q'));

            const handleSearch = () => {
                router.get('/admin/histories', {
                    q: search.value,
                });
            }

            const form = reactive({
                image_in: '',
            });

            const submit = () => {
                const submitBtn = document.querySelector('#kt_modal_submit_button');
                if (submitBtn) {
                    submitBtn.setAttribute('data-kt-indicator', 'on');
                    submitBtn.setAttribute('disabled', true);
                }

                const payload = {
                    image_in: form.image_in,
                };

                const cleanup = () => {
                    if (submitBtn) {
                        submitBtn.removeAttribute('data-kt-indicator');
                        submitBtn.removeAttribute('disabled');
                    }
                };

                const modalEl = document.getElementById('kt_modal_add_image');
                const modal = bootstrap.Modal.getInstance(modalEl);

                router.post('/admin/histories', payload, {
                    onSuccess: () => {
                        if (modal) {
                            modal.hide();
                        }
                        Swal.fire({
                            title: 'Berhasil!',
                            text: 'Kendaraan Terdaftar Berhasil Disimpan!',
                            icon: 'success',
                            showConfirmButton: false,
                            buttonsStyling: false,
                            timer: 2000,
                            customClass: {
                                popup: 'swal-custom-icon',
                            }
                        });
                        resetForm();
                    },
                    onFinish: cleanup
                });
            };

            const destroy = (id) => {
                Swal.fire({
                    title: 'Apakah Anda yakin?',
                    text: "Anda tidak akan dapat mengembalikan ini!",
                    icon: 'warning',
                    buttonsStyling: false,
                    showCancelButton: true,
                    confirmButtonText: "Hapus",
                    cancelButtonText: "Batal",
                    customClass: {
                        popup: 'swal-custom-icon',
                        confirmButton: "btn btn-myprimary",
                        cancelButton: "btn btn-mydanger"
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        router.delete(`/admin/histories/${id}`);
                        Swal.fire({
                            title: 'Dihapus!',
                            text: 'Riwayat Parkir Berhasil Dihapus!',
                            icon: 'success',
                            timer: 2000,
                            showConfirmButton: false,
                            buttonsStyling: false,
                            customClass: {
                                popup: 'swal-custom-icon',
                            }
                        });
                    }
                });
            };

            const formatDate = (dateString) => {
                if (!dateString) return null;

                const date = new Date(dateString);
                let time = date.toLocaleTimeString('id-ID', {
                    hour12: false,
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                });

                // Ganti titik dengan titik dua
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
                search,
                handleSearch,
                form,
                submit,
                destroy,
                formatDate,
                formatNumber,
                calculateDuration
            };
        }
    }
</script>

<style>

</style>
