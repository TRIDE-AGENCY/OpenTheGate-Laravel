<template>

    <Head>
        <title>Kendaraan Terdaftar - BSS Parking</title>
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
                            <li class="breadcrumb-item pe-3 text-muted">Kendaraan Terdaftar</li>
                        </ol>
                        <h1 class="page-heading d-flex text-dark fw-bold flex-column justify-content-center my-0">Kendaraan Terdaftar</h1>
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
                                    placeholder="Cari kendaraan terdaftar disini..." v-model="search" />
                            </form>
                            <div class="card-toolbar m-0">
                                <button @click="() => { resetForm(); isEditMode = false; openDrawer(); }"
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
                                            <th class="bg-secondary min-w-150px">Nama</th>
                                            <th class="bg-secondary min-w-150px">Plat</th>
                                            <th class="bg-secondary min-w-225px">Keterangan</th>
                                            <th class="bg-secondary min-w-100px">Status</th>
                                            <th class="bg-secondary pe-8 min-w-125px"></th>
                                        </tr>
                                    </thead>
                                    <tbody class="fw-semibold text-gray-600">
                                        <tr v-if="carlists.data.length === 0">
                                            <td colspan="7" class="text-center py-10">
                                                <img src="/assets/media/illustrations/empty.png" alt="Tidak ada data"
                                                    style="max-height: 260px;">
                                                <h2 class="text-gray-800">Kendaraan Terdaftar Tidak Ditemukan</h2>
                                                <p class="text-gray-600 fs-4">Belum ada kendaraan terdaftar atau pencarian
                                                    tidak sesuai.</p>
                                            </td>
                                        </tr>
                                        <tr v-else v-for="(carlist, index) in carlists.data" :key="index">
                                            <td class="ps-8">
                                                {{ ++index + (carlists . current_page - 1) * carlists . per_page }}
                                            </td>
                                            <td class="text-gray-800">{{ carlist . name }}</td>
                                            <td>{{ carlist . plate }}</td>
                                            <td>{{ carlist . description ?? '-' }}</td>
                                            <td>
                                                <span class="badge badge-lg"
                                                    :class="{
                                                        'bg-mysuccess text-mysuccess': carlist.status === 'Y',
                                                        'bg-mydanger text-mydanger': carlist.status === 'N'
                                                    }">
                                                    {{ carlist . status === 'Y' ? 'Whitelist' : 'Blacklist' }}
                                                </span>
                                            </td>
                                            <td class="text-end pe-8">
                                                <button @click="editCarlist(carlist)"
                                                    class="btn btn-sm btn-icon btn-mysecondary me-2">
                                                    <i class="ri-edit-2-fill fs-3"></i></button>
                                                <button @click.prevent="destroy(carlist.id)"
                                                    class="btn btn-sm btn-icon btn-mydanger">
                                                    <i class="ri-delete-bin-fill fs-3"></i></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <Pagination :links="carlists.links" align="end" class="px-8" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <form @submit.prevent="submit">
            <div id="kt_drawer_example_advanced" class="bg-body" data-kt-drawer="true" data-kt-drawer-activate="true"
                data-kt-drawer-toggle="#kt_drawer_example_advanced_button"
                data-kt-drawer-close="#kt_drawer_example_advanced_close" data-kt-drawer-name="docs"
                data-kt-drawer-overlay="true" data-kt-drawer-width="{default:'90%', 'md': '500px'}"
                data-kt-drawer-direction="end">
                <div class="card w-100 rounded-0">
                    <div class="card-header ps-8 pe-5 border-bottom border-gray-300">
                        <div class="card-title">
                            <h2>{{ isEditMode ? 'Edit Data' : 'Tambah Data' }}</h2>
                        </div>
                        <div class="card-toolbar" id="kt_drawer_example_advanced_close">
                            <div class="btn btn-sm btn-icon btn-mylighten">
                                <i class="bi bi-x-lg fs-3"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-body bg-light px-8 py-7 d-flex flex-column gap-7">
                        <div class="flex-grow-1">
                            <div class="card border border-gray-300">
                                <div class="card-header h-auto p-6 border-bottom border-gray-300"
                                    style="min-height: unset;">
                                    <div class="card-title m-0">
                                        <h3>Data Pengguna</h3>
                                    </div>
                                </div>
                                <div class="card-body p-6">
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Nama Pengguna</label>
                                        <input type="text" class="form-control fs-5" v-model="form.name" required
                                            placeholder="Masukkan nama pengguna disini..."
                                            :class="{ 'is-invalid': errors.name }" />
                                        <div v-if="errors.name" class="text-danger mt-2">
                                            {{ errors . name }}
                                        </div>
                                    </div>
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Plat Kendaraan</label>
                                        <input type="text" class="form-control fs-5" v-model="form.plate" required
                                            placeholder="Masukkan plat kendaraan disini..."
                                            :class="{ 'is-invalid': errors.plate }" />
                                        <div v-if="errors.plate" class="text-danger mt-2">
                                            {{ errors . plate }}
                                        </div>
                                    </div>
                                    <div class="fv-row">
                                        <label class="required form-label fs-6">Status</label>
                                        <select  class="form-select fs-5" data-control="select2" data-hide-search="true" data-allow-clear="true"
                                            data-placeholder="Pilih status disini..." required v-model="form.status"
                                            :class="{ 'is-invalid': errors.status }">
                                            <option></option>
                                            <option value="Y">Whitelist</option>
                                            <option value="N">Blacklist</option>
                                        </select>
                                        <div v-if="errors.status" class="text-danger mt-2">
                                            {{ errors . status }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card border border-gray-300 mt-6">
                                <div class="card-header h-auto p-6 border-bottom border-gray-300"
                                    style="min-height: unset;">
                                    <div class="card-title m-0">
                                        <h3>Detail Parkir</h3>
                                    </div>
                                </div>
                                <div class="card-body p-6">
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Tarif Parkir</label>
                                        <select class="form-select fs-5" data-control="select2" data-hide-search="true" data-allow-clear="true"
                                            data-placeholder="Pilih tarif parkir disini..." required v-model="form.rate_id"
                                            :class="{ 'is-invalid': errors.rate_id }">
                                            <option></option>
                                            <option v-for="(rate, index) in rates.filter(v => v.status !== 'N')"
                                                :key="index" :value="rate.id">
                                                {{ rate . name }} ({{ rate . type }})
                                            </option>
                                        </select>
                                        <div v-if="errors.rate_id" class="text-danger mt-2">
                                            {{ errors . rate_id }}
                                        </div>
                                    </div>
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Mulai Berlaku</label>
                                        <input class="form-control fs-5" v-model="form.start_date" required
                                            placeholder="Pilih mulai berlaku disini..." id="kt_datepicker_1"
                                            :class="{ 'is-invalid': errors.start_date }"/>
                                        <div v-if="errors.start_date" class="text-danger mt-2">
                                            {{ errors . start_date }}
                                        </div>
                                    </div>
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Selesai Berlaku</label>
                                        <input class="form-control fs-5" v-model="form.end_date" required
                                            placeholder="Pilih selesai berlaku disini..." id="kt_datepicker_1"
                                            :class="{ 'is-invalid': errors.end_date }"/>
                                        <div v-if="errors.end_date" class="text-danger mt-2">
                                            {{ errors . end_date }}
                                        </div>
                                    </div>
                                    <div class="fv-row">
                                        <label class="form-label fs-6">Keterangan</label>
                                        <textarea class="form-control fs-5" data-kt-autosize="true" rows="3" v-model="form.description"
                                            placeholder="Masukkan deskripsi disini..." :class="{ 'is-invalid': errors.description }"></textarea>
                                        <div v-if="errors.description" class="text-danger mt-2">
                                            {{ errors . description }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button type="reset" class="btn btn-sm fw-bold btn-mylight fs-5 me-3"
                                id="kt_drawer_example_advanced_close">Batal</button>
                            <button type="submit" id="kt_drawer_submit_button"
                                class="btn btn-sm fw-bold btn-myprimary fs-5">
                                <span class="indicator-label">
                                    {{ isEditMode ? 'Edit Data' : 'Tambah Data' }}
                                </span>
                                <span class="indicator-progress">
                                    Mohon Tunggu... <span
                                        class="spinner-border spinner-border-sm align-middle ms-2"></span>
                                </span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
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
    import flatpickr from "flatpickr";

    export default {
        layout: LayoutAdmin,

        components: {
            Head,
            Link,
            Pagination,
        },

        props: {
            errors: Object,
            carlists: Object,
            rates: Array,
        },

        setup() {
            const search = ref('' || (new URL(document.location)).searchParams.get('q'));

            const handleSearch = () => {
                router.get('/admin/carlists', {
                    q: search.value,
                });
            }

            onMounted(() => {
                flatpickr("#kt_datepicker_1", {
                    dateFormat: "Y-m-d"
                });
            });

            const openDrawer = () => {
                const drawerEl = document.querySelector('#kt_drawer_example_advanced');
                if (drawerEl && window.KTDrawer) {
                    const drawer = KTDrawer.getInstance(drawerEl) || new KTDrawer(drawerEl);
                    drawer.show();
                }
            };

            const form = reactive({
                rate_id: '',
                name: '',
                plate: '',
                start_date: '',
                end_date: '',
                description: '',
                status: '',
            });

            const editing = ref(null);
            const isEditMode = ref(false);

            const resetForm = () => {
                form.rate_id = '';
                form.name = '';
                form.plate = '';
                form.start_date = '';
                form.end_date = '';
                form.description = '';
                form.status = '';

                isEditMode.value = false;
                editing.value = null;

                const drawerCloseBtn = document.querySelector('#kt_drawer_example_advanced_close');
                if (drawerCloseBtn) drawerCloseBtn.click();
            };

            const submit = () => {
                const submitBtn = document.querySelector('#kt_drawer_submit_button');
                if (submitBtn) {
                    submitBtn.setAttribute('data-kt-indicator', 'on');
                    submitBtn.setAttribute('disabled', true);
                }

                const payload = {
                    rate_id: form.rate_id,
                    name: form.name,
                    plate: form.plate,
                    start_date: form.start_date,
                    end_date: form.end_date,
                    description: form.description,
                    status: form.status,
                };

                const cleanup = () => {
                    if (submitBtn) {
                        submitBtn.removeAttribute('data-kt-indicator');
                        submitBtn.removeAttribute('disabled');
                    }
                };

                if (isEditMode.value && editing.value) {
                    // UPDATE
                    router.put(`/admin/carlists/${editing.value.id}`, payload, {
                        onSuccess: () => {
                            Swal.fire({
                                title: 'Berhasil!',
                                text: 'Kendaraan Terdaftar Diperbarui!',
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
                } else {
                    // STORE
                    router.post('/admin/carlists', payload, {
                        onSuccess: () => {
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
                }
            };

            const editCarlist = (carlist) => {
                isEditMode.value = true;
                editing.value = carlist;

                form.rate_id = carlist.rate_id;
                form.name = carlist.name;
                form.plate = carlist.plate;
                form.start_date = carlist.start_date;
                form.end_date = carlist.end_date;
                form.description = carlist.description;
                form.status = carlist.status;


                const drawerEl = document.querySelector('#kt_drawer_example_advanced');
                if (drawerEl && window.KTDrawer) {
                    const drawer = KTDrawer.getInstance(drawerEl) || new KTDrawer(drawerEl);
                    drawer.show();
                }
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
                        router.delete(`/admin/carlists/${id}`);
                        Swal.fire({
                            title: 'Dihapus!',
                            text: 'Kendaraan Terdaftar Berhasil Dihapus!',
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

            return {
                search,
                handleSearch,
                form,
                submit,
                destroy,
                resetForm,
                editCarlist,
                isEditMode,
                openDrawer
            };
        }
    }
</script>

<style>

</style>
