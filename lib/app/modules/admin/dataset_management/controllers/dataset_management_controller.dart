import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/dataset_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../models/dataset_model.dart';

class DatasetManagementController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxList<DatasetModel> datasets = <DatasetModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<String?> selectedFileName = Rx<String?>(null);

  // ── Manual input form controllers ──
  final suhuController = TextEditingController();
  final curahHujanController = TextEditingController();
  final kelembabanController = TextEditingController();
  final phTanahController = TextEditingController();
  final nitrogenController = TextEditingController();
  final fosforController = TextEditingController();
  final kaliumController = TextEditingController();
  final hasilPanenController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    datasets.assignAll(DatasetDummy.getDatasets());
  }

  // ── CRUD ────────────────────────────────────────────────────────────────────

  void addDataset(DatasetModel dataset) {
    datasets.add(dataset);
    Get.snackbar(
      'Berhasil',
      'Dataset berhasil ditambahkan',
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // ── Manual form ─────────────────────────────────────────────────────────────

  void validateAndSave() {
    final suhu = double.tryParse(suhuController.text.trim());
    final curahHujan = double.tryParse(curahHujanController.text.trim());
    final kelembaban = double.tryParse(kelembabanController.text.trim());
    final phTanah = double.tryParse(phTanahController.text.trim());
    final nitrogen = double.tryParse(nitrogenController.text.trim());
    final fosfor = double.tryParse(fosforController.text.trim());
    final kalium = double.tryParse(kaliumController.text.trim());
    final hasilPanen = double.tryParse(hasilPanenController.text.trim());

    if (suhu == null ||
        curahHujan == null ||
        kelembaban == null ||
        phTanah == null ||
        nitrogen == null ||
        fosfor == null ||
        kalium == null ||
        hasilPanen == null) {
      Get.snackbar(
        'Data Tidak Valid',
        'Semua field harus diisi dengan angka yang valid',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    ConfirmDialog.show(
      title: 'Simpan Dataset',
      message: 'Pastikan data yang dimasukkan sudah benar.',
      confirmText: 'Simpan',
      isDanger: false,
      onConfirm: () {
        final newDataset = DatasetModel(
          id: (datasets.length + 1).toString(),
          suhu: suhu,
          curahHujan: curahHujan,
          kelembaban: kelembaban,
          phTanah: phTanah,
          nitrogen: nitrogen,
          fosfor: fosfor,
          kalium: kalium,
          hasilPanen: hasilPanen,
        );
        addDataset(newDataset);
        clearForm();
        Get.back();
      },
    );
  }

  void clearForm() {
    suhuController.clear();
    curahHujanController.clear();
    kelembabanController.clear();
    phTanahController.clear();
    nitrogenController.clear();
    fosforController.clear();
    kaliumController.clear();
    hasilPanenController.clear();
  }

  // ── Upload file ──────────────────────────────────────────────────────────────

  void simulateUpload() {
    selectedFileName.value = 'dataset.txt';
    Get.snackbar(
      'File Dipilih',
      'dataset.txt siap untuk diupload',
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void saveUploadedFile() {
    if (selectedFileName.value == null) {
      Get.snackbar(
        'Error',
        'Pilih file terlebih dahulu',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    ConfirmDialog.show(
      title: 'Upload Dataset',
      message: 'Simpan file ${selectedFileName.value} ke sistem?',
      confirmText: 'Upload',
      isDanger: false,
      onConfirm: () {
        Get.snackbar(
          'Berhasil',
          'Dataset berhasil diupload ke sistem',
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        selectedFileName.value = null;
        Get.back();
      },
    );
  }

  // ── Navigation ───────────────────────────────────────────────────────────────

  void openManualInput() => Get.toNamed(AppRoutes.adminDatasetManual);
  void openUploadDataset() => Get.toNamed(AppRoutes.adminDatasetUpload);

  // ── Auth ─────────────────────────────────────────────────────────────────────

  void logout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () {
        _auth.logout();
        Get.offAllNamed(AppRoutes.signIn);
      },
    );
  }

  @override
  void onClose() {
    suhuController.dispose();
    curahHujanController.dispose();
    kelembabanController.dispose();
    phTanahController.dispose();
    nitrogenController.dispose();
    fosforController.dispose();
    kaliumController.dispose();
    hasilPanenController.dispose();
    super.onClose();
  }
}
