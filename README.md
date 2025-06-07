# BSS Parking

**Pengelolaan Parkir Otomatis dengan YOLOv8 dan GPT-4o Vision Models.**

![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-8.3-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![npm](https://img.shields.io/badge/npm-CB3837?style=for-the-badge&logo=npm&logoColor=white)

---

## Persyaratan Sistem

Pastikan Anda memiliki versi berikut terinstal di sistem Anda:

-   **Composer:** `2.8.4`
-   **PHP:** `8.3.15`
-   **MySQL:** `8.0.30`
-   **Node.js** & **npm**

---

## Instalasi & Setup Project

Ikuti langkah-langkah mudah ini untuk menjalankan proyek secara lokal:

1.  **Clone repositori:**

    ```bash
    git clone [https://github.com/TRIDE-AGENCY/OpenTheGate-Website.git]
    ```

2.  **Instal dependensi:**

    ```bash
    composer install
    npm install
    ```

3.  **Siapkan konfigurasi:**

    ```bash
    cp .env.example .env
    php artisan key:generate
    ```

    -   **Penting:** Edit file `.env` dan atur detail koneksi database Anda (`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`). Pastikan database yang Anda tentukan sudah dibuat di MySQL.

4.  **Siapkan database & data awal:**

    ```bash
    php artisan migrate
    php artisan db:seed --class="DatabaseSeeder"
    ```

5.  **Optimasi & link storage:**

    ```bash
    php artisan storage:link
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    ```

6.  **Kompilasi aset frontend:**

    ```bash
    npm run dev
    # Gunakan npm run build untuk produksi
    ```

7.  **Jalankan aplikasi:**
    ```bash
    php artisan serve
    ```
    Aplikasi akan tersedia di `http://127.0.0.1:8000`. Selamat mencoba!

---
