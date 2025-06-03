<template>

    <Head>
        <title>Tarif Parkir - BSS Parking</title>
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
                            <li class="breadcrumb-item pe-3 text-muted">Tarif Parkir</li>
                        </ol>
                        <h1 class="page-heading d-flex text-dark fw-bold flex-column justify-content-center my-0">Tarif
                            Parkir</h1>
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
                                    placeholder="Cari tarif parkir disini..." v-model="search" />
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
                                                <th class="bg-secondary min-w-150px">Tarif Parkir</th>
                                                <th class="bg-secondary min-w-150px">Jenis Kendaraan</th>
                                                <th class="bg-secondary min-w-150px">Jenis Plat</th>
                                                <th class="bg-secondary min-w-100px">Tipe Tarif</th>
                                                <th class="bg-secondary min-w-100px">Status</th>
                                                <th class="bg-secondary pe-8 min-w-125px"></th>
                                            </tr>
                                        </thead>
                                        <tbody class="fw-semibold text-gray-600">
                                            <tr v-if="rates.data.length === 0">
                                                <td colspan="7" class="text-center py-10">
                                                    <img src="/assets/media/illustrations/empty.png"
                                                        alt="Tidak ada data" style="max-height: 260px;">
                                                    <h2 class="text-gray-800">Tarif Parkir Tidak Ditemukan</h2>
                                                    <p class="text-gray-600 fs-4">Belum ada tarif parkir atau pencarian
                                                        tidak sesuai.</p>
                                                </td>
                                            </tr>
                                            <tr v-else v-for="(rate, index) in rates.data" :key="index">
                                                <td class="ps-8">
                                                    {{ ++index + (rates . current_page - 1) * rates . per_page }}
                                                </td>
                                                <td class="text-gray-800">{{ rate . name }}</td>
                                                <td>{{ rate . vehicle . type }}</td>
                                                <td>{{ rate . plate . type }}</td>
                                                <td>{{ rate . type }}</td>
                                                <td>
                                                    <span class="badge badge-lg"
                                                        :class="{
                                                            'bg-mysuccess text-mysuccess': rate.status === 'Y',
                                                            'bg-mydanger text-mydanger': rate.status === 'N'
                                                        }">
                                                        {{ rate . status === 'Y' ? 'Aktif' : 'Nonaktif' }}
                                                    </span>
                                                </td>
                                                <td class="text-end pe-8">
                                                    <button @click="editRate(rate)"
                                                        class="btn btn-sm btn-icon btn-mysecondary me-2">
                                                        <i class="ri-edit-2-fill fs-3"></i></button>
                                                    <button @click.prevent="destroy(rate.id)"
                                                        class="btn btn-sm btn-icon btn-mydanger">
                                                        <i class="ri-delete-bin-fill fs-3"></i></button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                            </div>
                            <Pagination :links="rates.links" align="end" class="px-8" />
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
                                        <h3>Detail Tarif</h3>
                                    </div>
                                </div>
                                <div class="card-body p-6">
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Nama Tarif</label>
                                        <input type="text" class="form-control fs-5" v-model="form.name" required
                                            placeholder="Masukkan nama tarif disini..."
                                            :class="{ 'is-invalid': errors.name }" />
                                        <div v-if="errors.name" class="text-danger mt-2">
                                            {{ errors . name }}
                                        </div>
                                    </div>
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Jenis Kendaraan</label>
                                        <select class="form-select fs-5" v-model="form.vehicle_id" required
                                            :class="{ 'is-invalid': errors.vehicle_id }">
                                            <option v-for="(vehicle, index) in vehicles.filter(v => v.status !== 'N')"
                                                :key="index" :value="vehicle.id">
                                                {{ vehicle . type }}
                                            </option>
                                        </select>
                                        <div v-if="errors.vehicle_id" class="text-danger mt-2">
                                            {{ errors . vehicle_id }}
                                        </div>
                                    </div>
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Jenis Plat</label>
                                        <select class="form-select fs-5" v-model="form.plate_id" required
                                            :class="{ 'is-invalid': errors.plate_id }">
                                            <option v-for="(plate, index) in plates.filter(p => p.status !== 'N')"
                                                :key="index" :value="plate.id">
                                                {{ plate . type }}
                                            </option>
                                        </select>
                                        <div v-if="errors.plate_id" class="text-danger mt-2">
                                            {{ errors . plate_id }}
                                        </div>
                                    </div>
                                    <div class="mb-5 fv-row">
                                        <label class="form-label fs-6">Deskripsi</label>
                                        <textarea class="form-control fs-5" data-kt-autosize="true" rows="3" v-model="form.description"
                                            placeholder="Masukkan deskripsi disini..." :class="{ 'is-invalid': errors.description }"></textarea>
                                        <div v-if="errors.description" class="text-danger mt-2">
                                            {{ errors . description }}
                                        </div>
                                    </div>
                                    <div class="fv-row">
                                        <label class="required form-label fs-6">Status</label>
                                        <select class="form-select fs-5" required v-model="form.status"
                                            :class="{ 'is-invalid': errors.status }">
                                            <option value="Y">Aktif</option>
                                            <option value="N">Nonaktif</option>
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
                                        <h3>Tarif Parkir</h3>
                                    </div>
                                </div>
                                <div class="card-body p-6">
                                    <div class="fv-row">
                                        <label class="required form-label fs-6">Tipe Tarif</label>
                                        <select class="form-select fs-5" v-model="form.type" required
                                            :class="{ 'is-invalid': errors.type }">
                                            <option value="Flat">Flat</option>
                                            <option value="Per Jam">Per Jam</option>
                                        </select>
                                        <div v-if="errors.type" class="text-danger mt-2">
                                            {{ errors . type }}
                                        </div>
                                    </div>
                                    <div class="mt-5 fv-row" v-if="form.type === 'Flat'">
                                        <label class="required form-label fs-6">Harga Tarif Flat</label>
                                        <div class="input-group fs-5">
                                            <span class="input-group-text" id="basic-addon2">Rp</span>
                                            <input type="number" class="form-control" v-model="form.flat_rate"
                                                aria-describedby="basic-addon2" placeholder="Masukkan harga disini..."
                                                :class="{ 'is-invalid': errors.flat_rate }" />
                                        </div>
                                        <div v-if="errors.flat_rate" class="text-danger mt-2">
                                            {{ errors . flat_rate }}
                                        </div>
                                    </div>

                                    <div v-else-if="form.type === 'Per Jam'">
                                        <div class="mt-5 fv-row">
                                            <label class="required form-label fs-6">Harga 1 Jam Pertama</label>
                                            <div class="input-group fs-5">
                                                <span class="input-group-text" id="basic-addon2">Rp</span>
                                                <input type="number" class="form-control"
                                                    v-model="form.first_hour_rate" aria-describedby="basic-addon2"
                                                    placeholder="Masukkan harga disini..."
                                                    :class="{ 'is-invalid': errors.first_hour_rate }" />
                                            </div>
                                            <div v-if="errors.first_hour_rate" class="text-danger mt-2">
                                                {{ errors . first_hour_rate }}
                                            </div>
                                        </div>
                                        <div class="mt-5 fv-row">
                                            <label class="required form-label fs-6">Harga 1 Jam Berikutnya</label>
                                            <div class="input-group fs-5">
                                                <span class="input-group-text" id="basic-addon2">Rp</span>
                                                <input type="number" class="form-control"
                                                    v-model="form.next_hour_rate" aria-describedby="basic-addon2"
                                                    placeholder="Masukkan harga disini..."
                                                    :class="{ 'is-invalid': errors.next_hour_rate }" />
                                            </div>
                                            <div v-if="errors.next_hour_rate" class="text-danger mt-2">
                                                {{ errors . next_hour_rate }}
                                            </div>
                                        </div>
                                        <div class="mt-5 fv-row">
                                            <label class="required form-label fs-6">Harga Maks. 1 Hari</label>
                                            <div class="input-group fs-5">
                                                <span class="input-group-text" id="basic-addon2">Rp</span>
                                                <input type="number" class="form-control"
                                                    v-model="form.max_hour_rate" aria-describedby="basic-addon2"
                                                    placeholder="Masukkan harga disini..."
                                                    :class="{ 'is-invalid': errors.max_hour_rate }" />
                                            </div>
                                            <div v-if="errors.max_hour_rate" class="text-danger mt-2">
                                                {{ errors . max_hour_rate }}
                                            </div>
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

    export default {
        layout: LayoutAdmin,

        components: {
            Head,
            Link,
            Pagination
        },

        props: {
            errors: Object,
            rates: Object,
            vehicles: Array,
            plates: Array
        },

        setup() {
            const search = ref('' || (new URL(document.location)).searchParams.get('q'));

            const handleSearch = () => {
                router.get('/admin/rates', {
                    q: search.value,
                });
            }

            const openDrawer = () => {
                const drawerEl = document.querySelector('#kt_drawer_example_advanced');
                if (drawerEl && window.KTDrawer) {
                    const drawer = KTDrawer.getInstance(drawerEl) || new KTDrawer(drawerEl);
                    drawer.show();
                }
            };

            const form = reactive({
                name: '',
                vehicle_id: '',
                plate_id: '',
                description: '',
                status: '',
                type: '',
                flat_rate: '',
                first_hour_rate: '',
                next_hour_rate: '',
                max_hour_rate: '',
            });

            const editing = ref(null);
            const isEditMode = ref(false);

            const resetForm = () => {
                form.name = '';
                form.vehicle_id = '';
                form.plate_id = '';
                form.description = '';
                form.status = '';
                form.type = '';
                form.flat_rate = '';
                form.first_hour_rate = '';
                form.next_hour_rate = '';
                form.max_hour_rate = '';

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
                    name: form.name,
                    vehicle_id: form.vehicle_id,
                    plate_id: form.plate_id,
                    description: form.description,
                    status: form.status,
                    type: form.type,
                    flat_rate: form.flat_rate,
                    first_hour_rate: form.first_hour_rate,
                    next_hour_rate: form.next_hour_rate,
                    max_hour_rate: form.max_hour_rate,
                };

                const cleanup = () => {
                    if (submitBtn) {
                        submitBtn.removeAttribute('data-kt-indicator');
                        submitBtn.removeAttribute('disabled');
                    }
                };

                if (isEditMode.value && editing.value) {
                    // UPDATE
                    router.put(`/admin/rates/${editing.value.id}`, payload, {
                        onSuccess: () => {
                            Swal.fire({
                                title: 'Berhasil!',
                                text: 'Tarif Parkir Diperbarui!',
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
                    router.post('/admin/rates', payload, {
                        onSuccess: () => {
                            Swal.fire({
                                title: 'Berhasil!',
                                text: 'Tarif Parkir Berhasil Disimpan!',
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

            const editRate = (rate) => {
                isEditMode.value = true;
                editing.value = rate;

                form.name = rate.name;
                form.vehicle_id = rate.vehicle_id;
                form.plate_id = rate.plate_id;
                form.description = rate.description;
                form.status = rate.status;
                form.type = rate.type;
                form.flat_rate = rate.flat_rate;
                form.first_hour_rate = rate.first_hour_rate;
                form.next_hour_rate = rate.next_hour_rate;
                form.max_hour_rate = rate.max_hour_rate;


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
                        router.delete(`/admin/rates/${id}`);
                        Swal.fire({
                            title: 'Dihapus!',
                            text: 'Tarif Parkir Berhasil Dihapus!',
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

            onMounted(() => {
                const el = document.querySelector('[data-control="select2"]');

                if (el) {
                    $(el).select2(); // inisialisasi Select2
                    $(el).on('change', function(e) {
                        form.type = e.target.value; // manual update
                    });
                }
            });

            return {
                search,
                handleSearch,
                form,
                submit,
                destroy,
                resetForm,
                editRate,
                isEditMode,
                openDrawer
            };
        }
    }
</script>

<style>

</style>
