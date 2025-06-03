<template>

    <Head>
        <title>Administrator - BSS Parking</title>
    </Head>

    <form @submit.prevent="submit" class="form w-100" id="kt_sign_in_form">
        <div class="text-center mb-11">
            <h1 class="text-dark fs-2hx fw-bold mb-4">Hello Admin 👋</h1>
            <div class="text-gray-600 fw-semibold fs-4">Masuk untuk mengelola sistem BSS Parking</div>
        </div>
        <div class="fv-row mb-4">
            <input type="email" placeholder="Alamat Email" name="email" autocomplete="off" v-model="form.email"
                class="form-control fs-5" :class="{ 'is-invalid': errors.email }" />
            <div v-if="errors.email" class="text-danger mt-2">
                {{ errors . email }}
            </div>
        </div>
        <div class="fv-row mb-7">
            <input type="password" placeholder="Kata Sandi" name="password" autocomplete="off" v-model="form.password"
                class="form-control fs-5" :class="{ 'is-invalid': errors.password }" />
            <div v-if="errors.password" class="text-danger mt-2">
                {{ errors . password }}
            </div>
        </div>
        <div class="d-grid mb-10">
            <button type="submit" id="kt_sign_in_submit" class="btn btn-md btn-myprimary fs-5">
                <span class="indicator-label">Masuk</span>
                <span class="indicator-progress">Mohon tunggu...
                    <span class="spinner-border spinner-border-sm align-middle ms-2"></span></span>
            </button>
        </div>
    </form>
</template>

<script>
    import LayoutAuth from '../../Layouts/Auth.vue';
    import {
        Head,
        Link,
        router
    } from '@inertiajs/vue3';
    import {
        reactive
    } from 'vue';

    export default {
        layout: LayoutAuth,

        components: {
            Head,
            Link
        },

        props: {
            errors: Object,
            session: Object
        },

        setup() {
            const form = reactive({
                email: '',
                password: '',
            });

            const submit = () => {
                const submitBtn = document.querySelector('#kt_sign_in_submit');
                if (submitBtn) {
                    submitBtn.setAttribute('data-kt-indicator', 'on');
                    submitBtn.setAttribute('disabled', true);
                }

                router.post('/login', {
                    email: form.email,
                    password: form.password,
                }, {
                    onSuccess: () => {
                        window.location.reload();
                    },
                    onFinish: () => {
                        if (submitBtn) {
                            submitBtn.removeAttribute('data-kt-indicator');
                            submitBtn.removeAttribute('disabled');
                        }
                    }
                });
            }

            return {
                form,
                submit,
            };

        }

    }
</script>
