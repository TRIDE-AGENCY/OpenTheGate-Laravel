<template>
    <nav>
        <ul :class="`pagination pagination-sm justify-content-${align} m-0`">
            <li :class="['page-item previous', links[0].url === null ? 'disabled' : '']">
                <Link class="page-link page-link-myprimary" :href="links[0].url || '#'">
                    <i class="previous"></i>
                </Link>
            </li>
            <li v-for="(link, index) in links.slice(1, links.length - 1)" :key="index"
                :class="['page-item', link.active ? 'active' : '', link.url === null ? 'disabled' : '']">
                <Link class="page-link page-link-myprimary" :href="link.url || '#'">
                    <span v-html="link.label"></span>
                </Link>
            </li>
            <li :class="['page-item next', links[links.length - 1].url === null ? 'disabled' : '']">
                <Link class="page-link page-link-myprimary" :href="links[links.length - 1].url || '#'">
                    <i class="next"></i>
                </Link>
            </li>
        </ul>
    </nav>
</template>

<script>
    import {
        Link
    } from '@inertiajs/vue3';

    export default {
        props: {
            links: Array,
            align: String
        },

        components: {
            Link,
        },
    }
</script>

<style>

</style>
