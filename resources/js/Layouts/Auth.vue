<template>
    <section id="kt_body" class="app-blank app-blank">
        <div class="d-flex flex-column flex-root" id="kt_app_root">
            <div class="d-flex flex-column flex-lg-row flex-column-fluid">
                <div class="d-flex flex-column flex-lg-row-fluid w-lg-50 p-10 order-2 order-lg-1 justify-content-center align-items-center h-100">
                    <div class="d-flex flex-center flex-column flex-lg-row-fluid">
                        <div class="w-lg-450px">
                            <slot />
                        </div>
                    </div>
                    <div class="d-flex flex-center flex-wrap px-5 btn-link-myprimary pt-10">
						<a href="https://www.instagram.com/tride.dev/" class="btn-link-myprimary fs-5 fw-semibold" target="_blank">
                            <i class="bi bi-instagram fs-5 me-1"></i>
                            tride.dev
                        </a>
					</div>
                </div>
                <div class="d-flex flex-lg-row-fluid w-lg-50 bgi-size-cover bgi-position-center order-1 order-lg-2" style="background-image: url(/assets/media/illustrations/bss-bg.png)"></div>
            </div>
        </div>
    </section>
</template>

<script>
    export default {

    }
</script>

<style>
    #kt_body {
        height: 100vh;
    }

    #kt_app_root,
    .flex-root,
    .flex-column-fluid {
        height: 100%;
    }
</style>
