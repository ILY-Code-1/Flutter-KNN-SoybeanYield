import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/firestore_dataset_service.dart';
import '../models/dataset_model.dart';

class DatasetManagementController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _datasetService = FirestoreDatasetService();

  final RxList<DatasetModel> datasets = <DatasetModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final Rx<String?> selectedFileName = Rx<String?>(null);
  final Rx<String?> selectedFilePath = Rx<String?>(null);
  final Rx<List<int>?> selectedFileBytes = Rx<List<int>?>(null);

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
    loadDatasets();
  }

  // ── Load ─────────────────────────────────────────────────────────────────

  Future<void> loadDatasets() async {
    isLoading.value = true;
    final result = await _datasetService.getAll();
    datasets.assignAll(result);
    isLoading.value = false;
  }

  // ── CRUD ────────────────────────────────────────────────────────────────────

  void confirmDelete(String id) {
    ConfirmDialog.show(
      title: 'Hapus Dataset',
      message: 'Data ini akan dihapus secara permanen. Lanjutkan?',
      confirmText: 'Hapus',
      isDanger: true,
      onConfirm: () => _deleteDataset(id),
    );
  }

  Future<void> _deleteDataset(String id) async {
    final ok = await _datasetService.delete(id);
    if (ok) {
      datasets.removeWhere((d) => d.id == id);
      Get.snackbar(
        'Berhasil',
        'Dataset berhasil dihapus',
        backgroundColor: AppColors.primaryGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Gagal',
        'Tidak dapat menghapus dataset. Coba lagi.',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    }
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
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    ConfirmDialog.show(
      title: 'Simpan Dataset',
      message: 'Pastikan data yang dimasukkan sudah benar.',
      confirmText: 'Simpan',
      isDanger: false,
      onConfirm: () => _saveManual(
        suhu: suhu,
        curahHujan: curahHujan,
        kelembaban: kelembaban,
        phTanah: phTanah,
        nitrogen: nitrogen,
        fosfor: fosfor,
        kalium: kalium,
        hasilPanen: hasilPanen,
      ),
    );
  }

  Future<void> _saveManual({
    required double suhu,
    required double curahHujan,
    required double kelembaban,
    required double phTanah,
    required double nitrogen,
    required double fosfor,
    required double kalium,
    required double hasilPanen,
  }) async {
    isLoading.value = true;
    final model = DatasetModel(
      id: '',
      suhu: suhu,
      curahHujan: curahHujan,
      kelembaban: kelembaban,
      phTanah: phTanah,
      nitrogen: nitrogen,
      fosfor: fosfor,
      kalium: kalium,
      hasilPanen: hasilPanen,
    );

    final docId = await _datasetService.add(model);
    isLoading.value = false;

    if (docId != null) {
      datasets.add(DatasetModel(
        id: docId,
        suhu: suhu,
        curahHujan: curahHujan,
        kelembaban: kelembaban,
        phTanah: phTanah,
        nitrogen: nitrogen,
        fosfor: fosfor,
        kalium: kalium,
        hasilPanen: hasilPanen,
      ));
      Get.snackbar(
        'Berhasil',
        'Dataset berhasil ditambahkan',
        backgroundColor: AppColors.primaryGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      clearForm();
      Get.back();
    } else {
      Get.snackbar(
        'Gagal',
        'Tidak dapat menyimpan dataset. Coba lagi.',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    }
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

  // ── Upload file ──────────────────────────────────────────────────────────

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'csv'],
        dialogTitle: 'Pilih file dataset',
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        selectedFileName.value = result.files.single.name;
        selectedFilePath.value = result.files.single.path;
        selectedFileBytes.value = result.files.single.bytes;
        Get.snackbar(
          'File Dipilih',
          '${result.files.single.name} siap untuk diupload',
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Membuka File',
        'Tidak dapat membuka file manager. Periksa izin aplikasi.',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> saveUploadedFile() async {
    if (selectedFileName.value == null) {
      Get.snackbar(
        'Error',
        'Pilih file terlebih dahulu',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    ConfirmDialog.show(
      title: 'Upload Dataset',
      message: 'Simpan data dari file ${selectedFileName.value} ke Firestore?',
      confirmText: 'Upload',
      isDanger: false,
      onConfirm: () => _processUpload(),
    );
  }

  Future<void> _processUpload() async {
    isUploading.value = true;

    try {
      String content = '';

      // Read file content
      if (selectedFileBytes.value != null) {
        content = String.fromCharCodes(selectedFileBytes.value!);
      } else if (selectedFilePath.value != null) {
        final file = File(selectedFilePath.value!);
        content = await file.readAsString();
      }

      if (content.isEmpty) {
        isUploading.value = false;
        Get.snackbar(
          'Gagal',
          'File kosong atau tidak dapat dibaca',
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      final lines = content
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      // Skip header if present (first line contains non-numeric chars typical for headers)
      List<String> dataLines = lines;
      if (lines.isNotEmpty && lines.first.contains('suhu')) {
        dataLines = lines.sublist(1);
      }

      final result = await _datasetService.uploadLines(dataLines);

      isUploading.value = false;

      final added = result['added'] ?? 0;
      final skipped = result['skipped'] ?? 0;
      final failed = result['failed'] ?? 0;

      if (failed > 0) {
        Get.snackbar(
          'Peringatan',
          '$failed baris gagal diproses. $added data ditambahkan, $skipped dilewati (duplikat).',
          backgroundColor: Colors.orange.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Berhasil',
          '$added data berhasil ditambahkan, $skipped data dilewati karena duplikat.',
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 5),
        );
      }

      selectedFileName.value = null;
      selectedFilePath.value = null;
      selectedFileBytes.value = null;

      // Refresh dataset list
      await loadDatasets();
      Get.back();
    } catch (e) {
      isUploading.value = false;
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat memproses file: $e',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void openManualInput() => Get.toNamed(AppRoutes.adminDatasetManual);
  void openUploadDataset() => Get.toNamed(AppRoutes.adminDatasetUpload);

  // ── Auth ──────────────────────────────────────────────────────────────────

  void logout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () => _auth.logoutWithLoading(),
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
