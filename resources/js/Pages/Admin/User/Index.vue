<template>

    <Head>
        <title>Akun - BSS Parking</title>
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
                            <li class="breadcrumb-item pe-3 text-muted">Akun</li>
                        </ol>
                        <div class="page-heading d-flex align-items-center">
                            <h1 class="mb-0 me-3">Akun</h1>
                            <span class="badge bg-myprimary text-white fs-6">Admin</span>
                        </div>
                    </div>
                </div>
            </div>
            <div id="kt_app_content" class="app-content flex-column-fluid">
                <div id="kt_app_content_container" class="app-container container-xxl px-0">
                    <form @submit.prevent="submit">
                        <div class="card border border-gray-300">
                            <div class="row align-items-start m-0">
                                <div class="col-md-4 col-xl-3 card-header px-8 py-7 border-0 pb-0">
                                    <div class="card-title d-flex flex-column m-0">
                                        <h2>Informasi Akun</h2>
                                        <p class="fs-5 text-gray-600 mt-3 mb-0 fw-normal">Mengelola data dasar dan
                                            identitas pengguna
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-8 col-xl-9 card-body px-8 py-7">
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Nama Pengguna</label>
                                        <input type="text" class="form-control fs-5" required
                                            placeholder="Masukkan nama pengguna disini..." v-model="form.name"
                                            :class="{ 'is-invalid': errors.name }" />
                                        <div v-if="errors.name" class="text-danger mt-2">
                                            {{ errors . name }}
                                        </div>
                                    </div>
                                    <div class="fv-row">
                                        <label class="required form-label fs-6">Alamat Email</label>
                                        <input type="email" class="form-control fs-5" required
                                            placeholder="Masukkan alamat email disini..." v-model="form.email"
                                            :class="{ 'is-invalid': errors.email }" />
                                        <div v-if="errors.email" class="text-danger mt-2">
                                            {{ errors . email }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card border border-gray-300 mt-6 mb-7">
                            <div class="row align-items-start m-0">
                                <div class="col-md-4 col-xl-3 card-header px-8 py-7 border-0 pb-0">
                                    <div class="card-title d-flex flex-column m-0">
                                        <h2>Kredensial Akun</h2>
                                        <p class="fs-5 text-gray-600 mt-3 mb-0 fw-normal">Mengatur keamanan akun dengan
                                            opsi perubahan kata sandi
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-8 col-xl-9 card-body px-8 py-7">
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Kata Sandi Lama</label>
                                        <input type="password" class="form-control fs-5"
                                            placeholder="Masukkan kata sandi lama disini..." v-model="form.current_password"
                                            :class="{ 'is-invalid': errors.current_password }" />
                                        <div v-if="errors.current_password" class="text-danger mt-2">
                                            {{ errors.current_password }}
                                        </div>
                                    </div>
                                    <div class="mb-5 fv-row">
                                        <label class="required form-label fs-6">Kata Sandi Baru</label>
                                        <input type="password" class="form-control fs-5"
                                            placeholder="Masukkan kata sandi baru disini..." v-model="form.password"
                                            :class="{ 'is-invalid': errors.password }" />
                                        <div v-if="errors.password" class="text-danger mt-2">
                                            {{ errors.password }}
                                        </div>
                                    </div>
                                    <div class="fv-row">
                                        <label class="required form-label fs-6">Konfirmasi Kata Sandi Baru</label>
                                        <input type="password" class="form-control fs-5"
                                            placeholder="Masukkan konfirmasi kata sandi baru disini..." v-model="form.password_confirmation" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button type="submit" id="submit_button"
                                class="btn btn-sm fw-bold btn-myprimary fs-5">
                                <span class="indicator-label">
                                    Simpan Perubahan
                                </span>
                                <span class="indicator-progress">
                                    Mohon Tunggu... <span
                                        class="spinner-border spinner-border-sm align-middle ms-2"></span>
                                </span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import LayoutAdmin from '../../../Layouts/Admin.vue';
    import { Head, Link, router } from '@inertiajs/vue3';
    import { reactive } from 'vue';
    import Swal from 'sweetalert2';

    export default {
        layout: LayoutAdmin,

        components: {
            Head,
            Link,
        },

        props: {
            errors: Object,
            user: Object
        },

        setup(props) {
            const form = reactive({
                name: props.user.name,
                email: props.user.email,
                current_password: '',
                password: '',
                password_confirmation: '',
            });

            const submit = () => {
                const submitBtn = document.querySelector('#submit_button');
                if (submitBtn) {
                    submitBtn.setAttribute('data-kt-indicator', 'on');
                    submitBtn.setAttribute('disabled', true);
                }

                const cleanup = () => {
                    if (submitBtn) {
                        submitBtn.removeAttribute('data-kt-indicator');
                        submitBtn.removeAttribute('disabled');
                    }
                };

                router.put(`/admin/user/${props.user.id}`, {
                    name: form.name,
                    email: form.email,
                    current_password: form.current_password,
                    password: form.password,
                    password_confirmation: form.password_confirmation,
                }, {
                    onSuccess: () => {
                        Swal.fire({
                            title: 'Berhasil!',
                            text: 'Data Admin Berhasil Diperbarui!',
                            icon: 'success',
                            showConfirmButton: false,
                            timer: 2000,
                            buttonsStyling: false,
                            customClass: {
                                popup: 'swal-custom-icon',
                            }
                        });
                        form.current_password = '';
                        form.password = '';
                        form.password_confirmation = '';
                    },
                    onFinish: cleanup
                });
            }

            return {
                form,
                submit,
            };
        }
    }
</script>

<style>

</style>
